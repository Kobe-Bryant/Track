//
//  SocketClient.m
//  Q2_local
//
//  Created by Vecklink on 14-7-27.
//  Copyright (c) 2014年 Joe. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "SocketClient.h"
#define _OperationCount 1
//#define _SocketHost @"www.movnow.cn"
//#define _SocketHost @"113.108.103.150"
//#define _SocketPost 8323

#define _SocketHost @"push.movnow.com"
#define _SocketPost 8323

#define _Send_Ping_packet_interval 60

@implementation SocketClient
{
    int num;
}

+(SocketClient *)Instance
{
    static SocketClient *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[SocketClient alloc] init];
        }
        return _instance;
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // A(监听收对方发来的数据)  server（连接服务器）  B（对方）
        // 服务器socket
        serverSocket =[[AsyncSocket alloc] initWithDelegate:self];
        
        quene = [[NSOperationQueue alloc] init];
        [quene setMaxConcurrentOperationCount:_OperationCount];
    }
    return self;
}

-(void)connectToHost {
    if (![serverSocket isConnected]) {
        [serverSocket disconnect];
        [serverSocket connectToHost:_SocketHost onPort:_SocketPost error:nil];
    }
    else{
        NSLog(@"已经和服务器连接");
    }
}
-(void)sendLoginMsg {
    num =1;
    NSString *msg = [NSString stringWithFormat:@"{\"msgId\":\"%@\",\"type\":\"login\",\"version\":\"1.0.0\",\"userId\":%@, \"sessionId\":\"%@\"}\r\n",[NSString stringWithFormat:@"%d",num],[UserData Instance].uid, [UserData Instance].sessionId];
    num++;
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [serverSocket writeData:data withTimeout:-1 tag:400];
}

-(void)disconnect {
    [serverSocket disconnect];
    [timer invalidate];
    timer = nil;
    NSLog(@"断开Socket连接");
}


#pragma mark - AsyncSocket.h Delegate

// 写数据成功 自动回调
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    // 获取用户列表
    if (sock==serverSocket) {
        NSLog(@"向服务器%@发送消息成功",[sock connectedHost]);
    }
    // 继续监听
    [sock readDataWithTimeout:-1 tag:500];
}

// 成功连接后自动回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [sock readDataWithTimeout:-1 tag:200];
    NSLog(@"已经连接到服务器:%@",host);
    //发送登录消息
    [self sendLoginMsg];
}



// 客户端接收到了数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 收到服务器给的消息
    if (sock==serverSocket) {
        NSLog(@"收到服务端%@消息：%@", [sock connectedHost], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *revDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //收到ack包，开始发ping包
        if ([revDic[@"type"] isEqualToString:@"ack"]) {
            if (timer == nil) {
                timer = [NSTimer scheduledTimerWithTimeInterval:_Send_Ping_packet_interval target:self selector:@selector(sendSocketPingPacket) userInfo:nil repeats:YES];
            }
        }
        
        //收到eq_stat(设备状态)包
//        {"type":"eq_stat","id":"261111111111117","ol":"off","t":1407811898627}
        if ([revDic[@"type"] isEqualToString:@"eq_stat"]) {
            for (NSString *eqid in [UserData Instance].deviceDic.allKeys) {
                if ([eqid isEqualToString:revDic[@"id"]]) {
                    
                    NSLog(@"收到%@设备状态 %@", eqid, ([revDic[@"ol"] isEqualToString:@"off"] ? @"off":@"on"));
                    
                    BOOL _online =[revDic[@"ol"] isEqualToString:@"off"] ? NO:YES;
                    
                    DeviceModel *dev = [UserData Instance].deviceDic[eqid];
                    if (dev.online != _online) {
                        
                        dev.online = _online;
                        if (!dev.online) {
                            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
//                            dev.nowDist = @(0);
                        }
                        
                        if (_didDevOnlineChange != NULL) {
                            self.didDevOnlineChange(dev);
                        }
                    }
                    
                    int ele = ((NSNumber *)revDic[@"eqp"]).intValue;
                    if (dev.electricity != ele) {
                        dev.electricity = ele;
                        if ([[UserData Instance].likeDevIMEI isEqualToString:dev.bindIMEI]) {
                            if (_didDevElectricityChange != NULL) {
                                self.didDevElectricityChange(dev);
                            }
                        }
                    }
                    if (dev.online && dev.electricity < 30) {
                        NSString *msgStr = [NSString stringWithFormat:NSLocalizedString(@"%@电量不足，请及时充电 \n设备号：%@，电量：%d", nil), dev.nickName, dev.bindIMEI, dev.electricity];
                        NSLog(@"%@", msgStr);
                        
                        MessageModel *msg = [[MessageModel alloc] initWithContent:msgStr];
                        [dev.messageArr addObject:msg];
                        if (_didDevMsgArrChange) {
                            self.didDevMsgArrChange();
                        }
                        [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                }
            }
        }
        
        
        
        
        //收到设备位置包
        if ([revDic[@"type"] isEqualToString:@"eq_loc"]) {
            
            DeviceModel *dev = [UserData Instance].deviceDic[revDic[@"id"]];
            if (!dev) {
                return;
            }
            
            NSDictionary *subRevDic = revDic[@"loc"][0];
            
            NSLog(@"NSDictionary=%@",subRevDic);
            
            if (subRevDic[@"ceil"]) {
                
                return;
                
                //基站定位
                int mcc = ((NSString *)subRevDic[@"mcc"]).intValue;
                int mnc = ((NSString *)subRevDic[@"mnc"]).intValue;
                int cid = ((NSNumber *)subRevDic[@"ceil"][0][@"cid"]).intValue;
                int lac = ((NSNumber *)subRevDic[@"ceil"][0][@"lac"]).intValue;
                NSLog(@"mcc =%d %d %d %d", mcc, mnc, cid, lac);
//                22.54579926,113.95293427 
//                int mcc = 460;
//                int mnc = 0;
//                int cid = 3873;
//                int lac = 10350;
                
                NSMutableData *reData = [self GetFormPostDataWithCid:cid mcc:mcc mnc:mnc lac:lac];
                
                NSURL *url = [NSURL URLWithString:@"http://203.208.46.147/glm/mmap"];
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request addRequestHeader:@"Content-Type" value:@"application/binary"];
                [request setRequestMethod:@"POST"];
                [request setPostBody:reData];
                request.delegate = self;
                request.tag = 99;
                [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:revDic[@"id"], @"eqid", nil]];
                [quene addOperation:request];
                
                //。。。Code
            } else {
                //gps定位
                NSLog(@"GPS定位");
                
                CGFloat la = ((NSNumber *)subRevDic[@"la"]).doubleValue;
                CGFloat lo = ((NSNumber *)subRevDic[@"lo"]).doubleValue;
                la/=1000000;
                lo/=1000000;
                NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[subRevDic[@"t"] doubleValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *regStr = [df stringFromDate:dt];
                dev.locateTime=regStr;
                [self calculateDistWithDev:dev la:la lo:lo positioningType:NO];
            }
        }
        
        
        //
        if([revDic[@"type"] isEqualToString:@"single-ind"])
        {
            NSLog(@"收到单点信息");
           DeviceModel *dev = [UserData Instance].deviceDic[revDic[@"id"]];
            
            NSLog(@"bindIMEI=%@",dev.bindIMEI);
            NSDictionary *subRevDic = revDic[@"loc"][0];
            CGFloat la = ((NSNumber *)subRevDic[@"la"]).doubleValue;
            CGFloat lo = ((NSNumber *)subRevDic[@"lo"]).doubleValue;
            la/=1000000;
            lo/=1000000;
            dev.la=la;
            dev.lo=lo;
            NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[subRevDic[@"t"] doubleValue]];
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *regStr = [df stringFromDate:dt];
            dev.locateTime=regStr;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sing_ind" object:nil userInfo:nil];
            NSLog(@"发送");
        }
        
        // 收到围栏提醒信息
        
        if([revDic[@"type"] isEqualToString:@"fence_warn"])
        {
            DeviceModel *dev = [UserData Instance].deviceDic[revDic[@"id"]];
            MessageModel *msg = [[MessageModel alloc] initWithContent:NSLocalizedString(@"您设置的围栏触发预警，请及时查看处理",nil)];
            [dev.messageArr addObject:msg];
            [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];
        }
    }

    // 继续监听
    [sock readDataWithTimeout:-1 tag:100];
}

-(void)sendSocketPingPacket {
    if (![serverSocket isConnected]) {
        [self connectToHost];
    }
    NSString *msg = [NSString stringWithFormat:@"{\"msgId\":\"%@\",\"type\":\"ping\"}\r\n",[NSString stringWithFormat:@"%d",num]];
    num++;
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [serverSocket writeData:data withTimeout:-1 tag:400];
}

-(void)calculateDistWithDev:(DeviceModel *)dev la:(CGFloat)la lo:(CGFloat)lo positioningType:(BOOL)pType{
    dev.la = la;
    dev.lo = lo;
    
    NSLog(@"开始计算距离");
    [[PhoneLocation Instance] setOnLocationFinish:^(CLLocation *phoneL) {
        [UserData Instance].location = phoneL;
        
        NSLog(@"AAAAAAAAAAAAAwDist");
        CLLocation *devL = [[PhoneLocation Instance] locationWithLa:la lo:lo];
        NSLog(@"手机位置 =%@\n ", phoneL);
        NSLog(@"设备位置：%@\n ", devL);
//        CGFloat dist = [[PhoneLocation Instance] getDistanceWithDevLocation:devL phoneLocation:phoneL];
        CLLocationDistance dist = [phoneL distanceFromLocation:devL];
        NSLog(@"BBBBBBBBBBBwDist");
        
        //保存手机坐标和设备距离
        NSString *strD = [NSString stringWithFormat:@"%d", (int)dist];
        NSLog(@"CCCCCCCCCwDist  %@", strD);
        NSLog(@"DDDDDDDDDwDist  %d", strD.intValue);
        NSLog(@"dev =%@, dev.nowDist =%@", dev, [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]]);
//        dev.nowDist = [NSNumber numberWithInt:strD.intValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:strD forKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"设备离我%@米", [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]]);
        if (dist > dev.careDist) {
            NSLog(@"设备超出关爱距离%d米", [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]].intValue-dev.careDist);
            //。。。Code
            MessageModel *msg = [[MessageModel alloc] initWithContent:[NSString stringWithFormat:NSLocalizedString(@"您的宠物已经超出%d米的关爱范围啦，赶快去找找它吧", nil), dev.careDist]];
            [dev.messageArr addObject:msg];
            if (_didDevMsgArrChange) {
                self.didDevMsgArrChange();
            }
            
            //设置设备在线
            if (!dev.online) {
                dev.online = YES;
                if (!dev.electricity) {
                    dev.electricity = 40;
                }
                
                if (_didDevOnlineChange != NULL) {
                    self.didDevOnlineChange(dev);
                }
            }
            
            [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];
        }
    }];
    [[PhoneLocation Instance] startLocation];
}

#pragma mark delegate
-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSLog(@"NSOperationQueue response:%@", [request responseString]);
    if (request.tag == 99) {
        NSLog(@"Google API response.length =%lu", [request responseData].length);
        
        const char *a = [[request responseData] bytes];
        
        int i=3;
        long long code = a[i]*256*256*256+a[i+1]*256*256+a[i+2]*256+a[i+3];
        if (!code) {
            i+=4;
            CGFloat la = a[i]*256*256*256+a[i+1]*256*256+a[i+2]*256+a[i+3];
            i+=4;
            CGFloat lo = a[i]*256*256*256+a[i+1]*256*256+a[i+2]*256+a[i+3];
            la /= 1000000.0;
            lo /= 1000000.0;
            NSLog(@"-----la:%f,  lo:%f", la, lo);
            
            DeviceModel *dev = [UserData Instance].deviceDic[[request userInfo][@"eqid"]];
            [self calculateDistWithDev:dev la:la lo:lo positioningType:NO];
        }
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    if (dic[@"battery"]) {
        return;
        
        NSLog(@"%@", request.userInfo[@"eqid"]);
        DeviceModel *dev = [UserData Instance].deviceDic[request.userInfo[@"eqid"]];
        dev.electricity = ((NSString *)dic[@"battery"]).intValue;
        if (dev.electricity < 30) {
            NSString *msgStr = [NSString stringWithFormat:NSLocalizedString(@"%@电量不足，请及时充电 \n设备号：%@，电量：%d", nil), dev.nickName, dev.bindIMEI, dev.electricity];
            NSLog(@"%@", msgStr);
            
            MessageModel *msg = [[MessageModel alloc] initWithContent:msgStr];
            [dev.messageArr addObject:msg];
            if (_didDevMsgArrChange) {
                self.didDevMsgArrChange();
            }
            [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest*)request
{
    NSLog(@"HttpRequest Error > ________%@\n\n______________url=%@\n\n______________%@\n", self, [request url] , [request error]);
}

#pragma mark - Google API
-(NSMutableData *) GetFormPostDataWithCid:(int)cellTowerId mcc:(int)mobileCountryCode mnc:(int) mobileNetworkCode lac:(int)locationAreaCode
{
    Byte pd[55] = {0};
    pd[1] = 14;     //0x0e;
    pd[16] = 27;    //0x1b;
    pd[47] = (Byte) 255;   //0xff;
    pd[48] = (Byte) 255;   //0xff;
    pd[49] = (Byte) 255;   //0xff;
    pd[50] = (Byte) 255;   //0xff;
    
    // GSM uses 4 digits while UTMS used 6 digits (hex)
    pd[28] = (cellTowerId > 65536) ? (Byte) 5 : (Byte) 3;
    
    [self Shift:pd :17 :mobileNetworkCode];
    [self Shift:pd :21 :mobileCountryCode];
    [self Shift:pd :31 :cellTowerId];
    [self Shift:pd :35 :locationAreaCode];
    [self Shift:pd :39 :mobileNetworkCode];
    [self Shift:pd :43 :mobileCountryCode];
    return [NSMutableData dataWithBytes:pd length:sizeof(pd)];
}
-(void) Shift:(Byte *)data :(int) startIndex :(int)leftOperand
{
    int rightOperand = 24;
    
    for (int i = 0; i < 4; i++, rightOperand -= 8)
    {
        data[startIndex++] = (Byte) ((leftOperand >> rightOperand) & 255);
    }
}
@end
