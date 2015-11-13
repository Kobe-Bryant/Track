//
//  Map.h
//  Mapdksl000
//
//  Created by HelloWorld on 14-7-25.
//  Copyright (c) 2014年 JF. All rights reserved.
//
//（请求列队）此对象用于频繁发起http：单次点名请求、设备电量请求

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UserData.h"
#import "MD5.h"
#import "SocketClient.h"

@interface OperationQueue : NSObject {
    NSOperationQueue *quene;
    unsigned long long loginDuration;   //登录后持续时间
    NSTimer *timer;
}

@property (copy) void (^didDevOnlineChange)(DeviceModel *dev);

@property (nonatomic, strong) NSMutableDictionary *careDevDic;

+(OperationQueue *)Instance;

-(void) setSingle:(DeviceModel *)dev;

-(void)login;
-(void)logoff;

@end
