//
//  DeviceSetting_TableViewController.h
//  Q2_local
//
//  Created by JIA on 14-7-9.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyUserName_ViewController.h"
#import "GetLocationDuration_TableViewController.h"

#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "ASIHTTPRequest.h"
#import "MD5.h"

@interface DeviceSetting_TableViewController : UITableViewController

@property (nonatomic,assign) BOOL isAdd;
@property (nonatomic, copy) NSString *tempUphone;
@property (nonatomic, copy) NSString *tempEqphone;
@property (nonatomic, copy) NSString *IMEIID;

@property (nonatomic, strong) DeviceModel *devObj;

@end
