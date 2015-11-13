//
//  Fence_TableViewCell.h
//  Care_2
//
//  Created by lq on 14-11-6.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface Fence_TableViewCell : UITableViewCell{
    void (^onCancelCareButtonPressed)(DeviceModel *devObj);
    void (^onLookMapButtonPressed)(DeviceModel *devObj);


}

- (void)refreshCellWithDevObj:(DeviceModel *)devObj;

-(void)setOnCancelCareButtonPressed:(void (^)(DeviceModel *devObj))onCancelCareButtonPressed;
-(void)setOnLookMapButtonPressed:(void (^)(DeviceModel *devObj))onLookMapButtonPressed;

@end
