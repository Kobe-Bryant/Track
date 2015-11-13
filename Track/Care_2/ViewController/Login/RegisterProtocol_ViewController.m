//
//  RegisterProtocol_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-15.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "RegisterProtocol_ViewController.h"

@interface RegisterProtocol_ViewController () {
    
    __weak IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imageView;
}

@end

@implementation RegisterProtocol_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"注册协议", nil);
    [self setBackButton];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    scrollView.bounces = NO;
    [scrollView setContentSize:CGSizeMake(320, imageView.bounds.size.height-40)];
    [imageView setFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [scrollView addSubview:imageView];
}

_Method_SetBackButton(nil, NO)

@end
