//
//  DeviceModel.h
//  Q2_local
//
//  Created by Vecklink on 14-7-15.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MessageModel.h"

@interface DeviceModel : NSObject

@property (nonatomic, copy) NSString *nickName;         //名字
@property (nonatomic, strong) NSData *avatar;           //头像
@property (nonatomic,strong) NSString *avatarUrl;       //头像url
@property (atomic, assign) int electricity;             //设备电量

@property (nonatomic, assign) NSInteger careInterval;   //关爱间隔

@property (nonatomic, copy) NSString *phoneNumber;      //设备手机号
@property (nonatomic, copy) NSString *bindIMEI;         //设备IMEI
@property (nonatomic, copy) NSString *fenceId;          //围栏编号

@property (nonatomic, strong) NSObject *musicItem;      //预警音乐

//设备所在经纬度
@property (nonatomic, assign) CGFloat la;
@property (nonatomic, assign) CGFloat lo;
@property (nonatomic,copy) NSString *locateTime; //  定位的时间
@property (nonatomic, assign) BOOL positioningType; //定位类型：0 gps, 1 gsm

@property (atomic, assign) BOOL online;             //在线状态

//Care
@property (nonatomic, assign) int careDist;         //关爱距离
@property (atomic, strong) NSNumber *nowDist;       //当前距离
@property (nonatomic, assign) int careType;         //关爱类型  0离开预警范围  1进入预警范围

// fence
@property (nonatomic,assign) int fenceDist;    //围栏半径
@property (nonatomic,assign) int fenceType;    //1、进入报警  2、离开报警
@property (nonatomic,assign) double lat;  //围栏中心纬度
@property (nonatomic,assign) double lng;  //围栏中心经度

//远程看护
@property (nonatomic, strong) NSMutableArray *remoteCare;
@property (nonatomic,assign) int type;   //1、围栏设备  2、关爱设备
//消息中心
@property (strong) NSMutableArray *messageArr;

-(instancetype)initWithName:(NSString *)name phone:(NSString *)phone imei:(NSString *)imei withUrl:(NSString *)url;

@end
