//
//  RemoteCare_TableViewCell.m
//  Q2_local
//
//  Created by Vecklink on 14-8-1.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "RemoteCare_TableViewCell.h"

@implementation RemoteCare_TableViewCell {
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *contentLabel;
    
    NSDictionary *msgObj;
}

-(void)refreshCellWithDictionary:(NSDictionary *)_msgObj dateFormatter:(NSDateFormatter *)df {
    msgObj = _msgObj;
    
    dateLabel.text = [df stringFromDate:msgObj[@"date"]];;
    contentLabel.text = NSLocalizedString(msgObj[@"location"], nil);
}

@end
