//
//  SocketClient.h
//  Q2_local
//
//  Created by Vecklink on 14-7-27.
//  Copyright (c) 2014年 Joe. All rights reserved.
//
//socket客户端，接收服务端推送的设备坐标、设备电量

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "UserData.h"
#import "PhoneLocation.h"
#import "MusicPlayerController.h"

#import "ASIFormDataRequest.h"

@interface SocketClient : NSObject {
    
    AsyncSocket *serverSocket;
    
    NSOperationQueue *quene;
    NSTimer *timer;
}

@property (copy) void (^didDevOnlineChange)(DeviceModel *dev);
@property (copy) void (^didDevElectricityChange)(DeviceModel *dev);
@property (copy) void (^didDevMsgArrChange)();

+(SocketClient *)Instance;

-(void)connectToHost;
-(void)disconnect;

@end
