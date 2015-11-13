//
//  HomePageDevices_View.h
//  Q2_local
//
//  Created by Vecklink on 14-7-19.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomIOS7AlertView.h"
#import "UserData.h"
#import "ASIHTTPRequest.h"
#import "MD5.h"
#import "MBProgressHUD.h"

@interface HomePage_DevicesView : UIView

@property (copy) void(^didDevSelected)();
@property (copy) void(^didRequestDevListFinish)();

@property (nonatomic, weak) UINavigationController *navigationController;



-(void)refreshDevicesView;
-(void)refreshDevicesOnlineState;
-(void)refreshDeviceOnlineState:(DeviceModel *)dev;

@end
