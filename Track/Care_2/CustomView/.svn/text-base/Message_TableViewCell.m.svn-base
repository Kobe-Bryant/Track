//
//  Message_TableViewCell.m
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Message_TableViewCell.h"

@implementation Message_TableViewCell {
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *contentLabel;
    __weak IBOutlet UIButton *msgButton;
    
    MessageModel *msgObj;
}

-(void)refreshCellWithModel:(MessageModel *)_msgObj dateFormatter:(NSDateFormatter *)df {
    msgObj = _msgObj;
    
    dateLabel.text = [df stringFromDate:msgObj.createDate];;
    contentLabel.text = NSLocalizedString(msgObj.content, nil);
    
    msgButton.selected = msgObj.isRead;
    contentLabel.textColor = (msgObj.isRead ? [UIColor grayColor]:_Color_font2);
}

- (IBAction)onCellMsgButtonPressed:(UIButton *)bt {
    bt.selected = YES;
    contentLabel.textColor = [UIColor grayColor];
    if (_onCellMsgButtonPressed != NULL) {
        self.onCellMsgButtonPressed();
    }
}
- (IBAction)onDeleteButtonPressed:(UIButton *)bt {
    if (_onMsgDeleteButtonPressed != NULL) {
        self.onMsgDeleteButtonPressed(msgObj);
    }
}

@end
