//
//  MessageDetail_ViewController.h
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageDetail_ViewController : UIViewController

@property (copy) void (^onMsgDeleteButtonPress)();
@property (nonatomic, weak) MessageModel *msgObj;

@end
