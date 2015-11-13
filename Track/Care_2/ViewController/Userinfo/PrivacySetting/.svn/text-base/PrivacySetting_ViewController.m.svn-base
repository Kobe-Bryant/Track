//
//  PrivacySetting_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "PrivacySetting_ViewController.h"
#import "ModifyPassword_ViewController.h"

@interface PrivacySetting_ViewController ()


- (IBAction)onModifyPasswordButtonPressed:(UIButton *)sender;

@end

@implementation PrivacySetting_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"安全与隐私", nil);
    [self setBackButton];
}

_Method_SetBackButton(nil, NO)

- (IBAction)onModifyPasswordButtonPressed:(UIButton *)sender {
    ModifyPassword_ViewController *modifyPasswordVC = [[ModifyPassword_ViewController alloc] initWithNibName:@"ModifyPassword_ViewController" bundle:nil];
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

@end
