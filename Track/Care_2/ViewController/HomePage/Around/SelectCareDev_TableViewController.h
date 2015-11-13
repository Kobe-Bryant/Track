//
//  SelectCareDev_TableViewController.h
//  Q2_local
//
//  Created by Vecklink on 14-7-25.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface SelectCareDev_TableViewController : UITableViewController {
    void(^didSelectDevice)(DeviceModel *devObj);
}

@property (nonatomic, weak) NSMutableDictionary *notCareDevDic;

-(void)setDidSelectDevice:(void (^)(DeviceModel *))didSelectDevice;

@end
