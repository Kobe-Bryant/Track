//
//  Nav_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-17.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Nav_ViewController.h"
#import "AsyncUdpSocket.h"

#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"

#import "ASIHTTPRequest.h"

@interface Nav_ViewController ()<UINavigationControllerDelegate> {
    
    NSMutableArray *ipArray;
    NSMutableArray *nameArray;
    
    BOOL inUse;
}

@end

@implementation Nav_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    //导航栏不透明（实体）
    self.navigationBar.translucent = NO;
    //设置导航背景
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"01_nav_background_64"] forBarMetrics:UIBarMetricsDefault];
    //设置导航标题颜色
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:_Color_font1 forKey:NSForegroundColorAttributeName];
    
    inUse = NO;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!inUse) {
        inUse = YES;
        [super pushViewController:viewController animated:animated];
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (!inUse) {
        inUse = YES;
        return [super popViewControllerAnimated:animated];
    }
    return nil;
}
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (!inUse) {
        inUse = YES;
        return [super popToRootViewControllerAnimated:animated];
    }
    return nil;
}
-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!inUse) {
        inUse = YES;
        return [super popToViewController:viewController animated:animated];
    }
    return nil;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    inUse = NO;
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    _Code_HTTPResponseCheck(jsonDic, {
        if ([request.username isEqualToString:_Interface_user_updateinfo]) {
            NSLog(@"用户信息修改成功！");
        } else if ([request.username isEqualToString:_Interface_user_logout]) {
            NSLog(@"线上注销成功！");
        } else if ([request.username isEqualToString:_Interface_tracker_bind]) {
            NSLog(@"绑定设备成功！");
        }
    })
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    
    if ([request.username isEqualToString:_Interface_tracker_bind]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:@"Error" message:NSLocalizedString([request error].localizedDescription, nil)];
        [alertView show];
    }
    NSLog(@"HttpRequest Error > ________%@\n\n______________url=%@\n\n______________%@\n", self, [request url] , [request error]);
}

@end
