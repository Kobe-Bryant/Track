//
//  Message_TableViewCell.h
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface Message_TableViewCell : UITableViewCell

@property (copy) void(^onCellMsgButtonPressed)();
@property (copy) void(^onMsgDeleteButtonPressed)(MessageModel *msg);

-(void)refreshCellWithModel:(MessageModel *)msgObj dateFormatter:(NSDateFormatter *)df;

@end
