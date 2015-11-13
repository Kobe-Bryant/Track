//
//  Around_TableViewCell.h
//  Q2_local
//
//  Created by Vecklink on 14-7-18.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"

#import "ASIHTTPRequest.h" 
#import "MD5.h"

@interface Around_TableViewCell : UITableViewCell {
    void (^onCancelCareButtonPressed)(DeviceModel *devObj);
    void (^onLookMapButtonPressed)(DeviceModel *devObj);
}
-(void)refreshCellWithDevObj:(DeviceModel *)devObj;

-(void)setOnCancelCareButtonPressed:(void (^)(DeviceModel *devObj))onCancelCareButtonPressed;
-(void)setOnLookMapButtonPressed:(void (^)(DeviceModel *devObj))onLookMapButtonPressed;

@end
