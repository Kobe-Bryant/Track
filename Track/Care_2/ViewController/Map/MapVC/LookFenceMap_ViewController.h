//
//  LookFenceMap_ViewController.h
//  Care_2
//
//  Created by adear on 14/11/10.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
@interface LookFenceMap_ViewController : UIViewController

@property (nonatomic,strong)DeviceModel *device;
-(void)getDevice;
@end
