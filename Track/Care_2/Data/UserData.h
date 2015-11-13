//
//  UserData.h
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DeviceModel.h"
#import "OperationQueue.h"

@interface UserData : NSObject

@property (nonatomic, copy) NSString *uid;          //用户ID
@property (nonatomic, copy) NSString *sessionId;    //登录校验

@property (nonatomic, copy) NSString *account;      //登录帐号
@property (nonatomic, copy) NSString *tempAccount;

@property (nonatomic, copy) NSString *nickName;     //昵称
@property (nonatomic, strong) NSData *avatarData;   //头像
@property (nonatomic, strong) NSString *avatarUrl;  // 头像的地址
@property (nonatomic, assign) int sex;              //性别  0女 1男

@property (nonatomic, strong) NSMutableDictionary *deviceDic;   //绑定设备，设备号为key
@property (nonatomic, copy) NSString *likeDevIMEI;              //常用设备的设备号

//手机所在经纬度
@property (nonatomic, strong) CLLocation* location;

+(UserData *)Instance;

-(BOOL)isLogin;
//读档     0自动登录： 程序启动后，读取本地所有数据
//        1登录：     读取本地配置数据
-(BOOL)autoLoginWithUid:(NSString *)uid type:(int)type;
//归档
-(void)saveCustomObject:(UserData *)obj;

-(void)logoff;

- (void)save;

@end
