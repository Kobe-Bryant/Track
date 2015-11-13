//
//  Map.m
//  Mapdksl000
//
//  Created by HelloWorld on 14-7-25.
//  Copyright (c) 2014年 JF. All rights reserved.
//

#import "OperationQueue.h"

#define _OperationCount 1       //列队使用线程数量
#define _getElectricitySec 60   //多久获取一次设备电量

@implementation OperationQueue
@synthesize careDevDic;

+(OperationQueue *)Instance
{
    static OperationQueue *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[OperationQueue alloc] init];
        }
        return _instance;
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        quene = [[NSOperationQueue alloc] init];
        [quene setMaxConcurrentOperationCount:_OperationCount];
        loginDuration = 0;
        timer = nil;
        
        //设置播放列表
        NSMutableArray *devItems = [NSMutableArray array];
        for (DeviceModel *devObj in [UserData Instance].deviceDic.allValues) {
            if (devObj.musicItem) {
                [devItems addObject:devObj.musicItem];
            }
        }
        if (devItems.count) {
            MPMediaItemCollection *mic = [[MPMediaItemCollection alloc] initWithItems:devItems];
            [[MusicPlayerController Instance] setQueueWithItemCollection:mic];
        }
    }
    return self;
}


-(void)login {
    if (timer == nil) {
        //timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timing) userInfo:nil repeats:YES];
    }
}
-(void)timing
{
    
    
    if (!careDevDic) {
        //查看关爱设备列表
        NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
        [signInfo setValue:_Interface_tracker_mycare forKey:@"method"];
        [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
        [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
        
        NSString *sign = [MD5 createSignWithDictionary:signInfo];
        NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
        request.tag = 30;
        request.delegate = self;
        [quene addOperation:request];
    } else {
  
        for (DeviceModel *dev in careDevDic.allValues) {
            
            break;
            
            if (loginDuration % dev.careInterval == 0) {
                [[SocketClient Instance] connectToHost];
                
                //发起单次点名请求
                NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
                [signInfo setValue:_Interface_tracker_single forKey:@"method"];
                [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
                [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
                [signInfo setValue:[NSNumber numberWithInteger:dev.careInterval] forKey:@"live"];
                [signInfo setValue:@"-" forKey:@"token"];
                [signInfo setValue:dev.bindIMEI forKey:@"eqid"];
                
                NSString *sign = [MD5 createSignWithDictionary:signInfo];
                NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
                request.delegate = self;
                request.tag = 50;
                request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:dev.bindIMEI , @"eqid", nil];
                [quene addOperation:request];
            }
        }
    }
    
    if (loginDuration % 20 == 0) {
        [[SocketClient Instance] connectToHost];
    }
//    if (loginDuration % 5 == 0) {
//        [[SocketClient Instance] connectToHost];
//        
//        NSString *eqidStr = @"141000000001107";
//        //发起单次点名请求
//        NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
//        [signInfo setValue:_Interface_tracker_single forKey:@"method"];
//        [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
//        [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//        [signInfo setValue:@(100) forKey:@"live"];
//        [signInfo setValue:@"-" forKey:@"token"];
//        [signInfo setValue:eqidStr forKey:@"eqid"];
//        
//        NSString *sign = [MD5 createSignWithDictionary:signInfo];
//        NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
//        
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        request.delegate = self;
//        request.tag = 50;
//        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:eqidStr , @"eqid", nil];
//        [quene addOperation:request];
//    }
    
    loginDuration++;
 //   NSLog(@"loginDuration =%llu", loginDuration);
}
-(void)logoff {
    [quene cancelAllOperations];
    loginDuration = 0;
    [timer invalidate];
    timer = nil;
}

-(void) setSingle:(DeviceModel *)dev
{
    
    
    [[SocketClient Instance] connectToHost];
    
    NSLog(@"发起单次点名请求");
    //发起单次点名请求
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_single forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    [signInfo setValue:[NSNumber numberWithInteger:15] forKey:@"live"];
    [signInfo setValue:@"-" forKey:@"token"];
    [signInfo setValue:dev.bindIMEI forKey:@"eqid"];
    
    NSLog(@"dev.bindIMEI=%@",dev.bindIMEI);
    
    NSLog(@"signInfo=%@",signInfo);
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    request.delegate = self;
    request.tag = 50;
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:dev.bindIMEI , @"eqid", nil];
    [quene addOperation:request];
}

#pragma mark delegate
-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSLog(@"NSOperationQueue response:%@", [request responseString]);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"dic=%@",dic);
    
    if (request.tag == 50) {
        NSLog(@"获取设备在线状态成功");
        if (dic[@"error"] && [dic[@"error"] isEqualToString:@"0"]) {
            
            DeviceModel *dev = [UserData Instance].deviceDic[request.userInfo[@"eqid"]];
            if (!dev.online) {
                dev.online = YES;
                if (_didDevOnlineChange != NULL) {
                    self.didDevOnlineChange(dev);
                }
            }
        } else if (dic[@"error"] && [dic[@"error"] isEqualToString:@"15"]) {
            
//            if (dic[@"subErrors"] && [(dic[@"subErrors"][0][@"message"]) isEqualToString:@"设备离线"]) {
//                DeviceModel *dev = [UserData Instance].deviceDic[request.userInfo[@"eqid"]];
//                if (dev.online) {
//                    dev.online = NO;
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", dev.bindIMEI]];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
////                    dev.nowDist = @(0);
//                    
//                    if (_didDevOnlineChange != NULL) {
//                        self.didDevOnlineChange(dev);
//                    }
//                }
//            }
        }
        
    } else if (request.tag == 30) {
        NSLog(@"获取关爱设备列表成功！");
        if (!careDevDic) {
            careDevDic = [[NSMutableDictionary alloc] init];
        }
        [careDevDic removeAllObjects];
        for (NSDictionary *devDic in dic[@"list"]) {
            DeviceModel *devObj = [UserData Instance].deviceDic[devDic[@"eqId"]];
            if (devObj) {
                [careDevDic setValue:devObj forKey:devObj.bindIMEI];
            }
        }
    } 
}
-(void)requestFailed:(ASIHTTPRequest*)request
{
    NSLog(@"HttpRequest Error > ________%@\n\n______________url=%@\n\n______________%@\n", self, [request url] , [request error]);
}

@end
