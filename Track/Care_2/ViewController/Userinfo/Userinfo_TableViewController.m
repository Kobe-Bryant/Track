//
//  Userinfo_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Userinfo_TableViewController.h"

@interface Userinfo_TableViewController () {
    UITableView *_tableView;
    
    NSArray *itemTitleArray;
    
    ASIHTTPRequest *req;
}

@end

@implementation Userinfo_TableViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"个人信息", nil);
    [self setBackButton];
    
    _tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 7)];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(15, 20, 290, 40);
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bt setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"03_set_btn_long"] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"03_set_btn_long_selected"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(logoff) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:bt];
    _tableView.tableFooterView = tableFooterView;
    
    itemTitleArray = [NSArray arrayWithObjects:NSLocalizedString(@"我", nil), NSLocalizedString(@"乐卡帐号", nil), NSLocalizedString(@"我的设备", nil), NSLocalizedString(@"安全与隐私", nil), NSLocalizedString(@"关于一米", nil), nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}
_Method_SetBackButton(nil, NO)

-(void)logoff {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleThreeWithTitle:NSLocalizedString(@"提醒", nil) message:NSLocalizedString(@"退出乐卡将接收不到乐卡的服务，您确定？", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            NSLog(@"执行注销");
            NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
            [signInfo setValue:_Interface_user_logout forKey:@"method"];
            [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
            [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
            
            NSString *sign = [MD5 createSignWithDictionary:signInfo];
            NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
            
            req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
            [req setUsername:_Interface_user_logout];
            req.delegate = self.navigationController;
            [req startAsynchronous];
            
            //不管线上注销是否成功，本地执行注销
            [[UserData Instance] logoff];
            //清除自动登录
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AccountUid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertView show];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemTitleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        return 48;
    }
    return 72;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background_selected"]]];
        
        if (!indexPath.row) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 60, 60)];
            imgView.layer.cornerRadius = 7;
            imgView.layer.masksToBounds = YES;
            imgView.tag = 100;
            [cell addSubview:imgView];
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(86, 25, 100, 21)];
            lb.font = [UIFont boldSystemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.text = itemTitleArray[indexPath.row];
            [cell addSubview:lb];
        } else {
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(19, 13, 150, 21)];
            lb.font = [UIFont boldSystemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.text = itemTitleArray[indexPath.row];
            [cell addSubview:lb];
        }
    }
    ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageWithData:[UserData Instance].avatarData];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    switch (indexPath.row) {
        case 0: {   //我（用户设置）
            UserSetting_TableViewController *userSettingTVC = [[UserSetting_TableViewController alloc] initWithNibName:@"UserSetting_TableViewController" bundle:nil];
            [self.navigationController pushViewController:userSettingTVC animated:YES];
        }   break;
        case 1: {   //乐卡帐号
            MovnowAccount_ViewController *movnowAccountVC = [[MovnowAccount_ViewController alloc] initWithNibName:@"MovnowAccount_ViewController" bundle:nil];
            [self.navigationController pushViewController:movnowAccountVC animated:YES];
        }   break;
        case 2: {   //我的设备
            MyDevice_TableViewController *myDeviceTVC = [[MyDevice_TableViewController alloc] initWithNibName:@"MyDevice_TableViewController" bundle:nil];
            [self.navigationController pushViewController:myDeviceTVC animated:YES];
        }   break;
        case 3: {   //安全与隐私
            PrivacySetting_ViewController *privacySettingVC = [[PrivacySetting_ViewController alloc] initWithNibName:@"PrivacySetting_ViewController" bundle:nil];
            [self.navigationController pushViewController:privacySettingVC animated:YES];
        }   break;
        case 4: {   //关于乐卡关爱
            AboutMovnow_TableViewController *aboutMovnowVC = [[AboutMovnow_TableViewController alloc] initWithNibName:@"AboutMovnow_TableViewController" bundle:nil];
            [self.navigationController pushViewController:aboutMovnowVC animated:YES];
        }   break;
    }
}

@end
