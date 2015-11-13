//
//  MovnowAccount_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-13.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MovnowAccount_ViewController.h"

@interface MovnowAccount_ViewController () {
    
    __weak IBOutlet UILabel *uidLabel;
    __weak IBOutlet UILabel *accountLabel;
}

@end

@implementation MovnowAccount_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"乐卡帐号", nil);
    uidLabel.text = [UserData Instance].uid;
    accountLabel.text = [UserData Instance].account;
    
    [self setBackButton];
}

_Method_SetBackButton(nil, NO)

@end
