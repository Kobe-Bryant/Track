//
//  AddCare_ViewController.h
//  Q2_local
//
//  Created by JIA on 14-7-24.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "MD5.h"

@interface AddCare_ViewController : UIViewController {
    void (^onOpenCareButtonPressed)(DeviceModel *devObj);
}

-(void)setOnOpenCareButtonPressed:(void (^)(DeviceModel *))onOpenCareButtonPressed;

@property (nonatomic, weak) DeviceModel *dev;
@property (nonatomic, assign) BOOL isCareDev;
@property (nonatomic,assign) NSInteger fenceNum;
@property (nonatomic,copy) NSArray *fenceDevArr;
@end
