//
//  MyDevice_TableViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-9.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MyDevice_TableViewController.h"

@interface MyDevice_TableViewController () {
    UITableView *_tableView;
    NSArray *ascKeys;
    
    UILabel *messageLabel;
    
    ASIHTTPRequest *req;
}

@end

@implementation MyDevice_TableViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的设备", nil);
    [self setBackButton];

    _tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 7)];
    
    //查看绑定设备列表
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_my forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
    
    [self refreshTableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshTableView];
}

_Method_SetBackButton(nil, NO)

-(void)refreshTableView {
    NSArray *keyArr = [[UserData Instance].deviceDic allKeys];
    ascKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        return result==NSOrderedDescending;
    }];
    
    if (![UserData Instance].deviceDic.count) {
        if (!messageLabel) {
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 150)];
            messageLabel.numberOfLines = 0;
            messageLabel.text = NSLocalizedString(@"您还没有添加设备哦", nil);
            messageLabel.textColor = [UIColor grayColor];
            messageLabel.font = [UIFont systemFontOfSize:15];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [_tableView addSubview:messageLabel];
        }
        messageLabel.hidden = (keyArr.count ? YES:NO);
    }
    
    [_tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserData Instance].deviceDic.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background_selected"]]];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 60, 60)];
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        imgView.layer.borderWidth = 1;
        imgView.layer.cornerRadius = imgView.bounds.size.height/2;
        imgView.layer.masksToBounds = YES;
        imgView.tag = 100;
        [cell addSubview:imgView];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(110, 24, 100, 21)];
        lb.font = [UIFont boldSystemFontOfSize:16];
        lb.textColor = [UIColor whiteColor];
        lb.tag = 101;
        [cell addSubview:lb];
    }
    DeviceModel *devObj = [UserData Instance].deviceDic[ascKeys[indexPath.row]];
    ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageWithData:devObj.avatar];
    ((UILabel *)[cell viewWithTag:101]).text = devObj.nickName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceSetting_TableViewController *deviceSettingTVC = [[DeviceSetting_TableViewController alloc] initWithNibName:@"DeviceSetting_TableViewController" bundle:nil];
    
    DeviceModel *devObj=[UserData Instance].deviceDic[ascKeys[indexPath.row]];
    
    deviceSettingTVC.tempEqphone=devObj.phoneNumber;
    
    deviceSettingTVC.devObj = devObj;
    [self.navigationController pushViewController:deviceSettingTVC animated:YES];
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        NSLog(@"获取设备列表成功！");
        
        NSMutableDictionary *newDeviceDic = [NSMutableDictionary dictionary];
        for (NSDictionary *devDic in jsonDic[@"list"]) {
            
            
            DeviceModel *devObj = [UserData Instance].deviceDic[devDic[@"eqId"]];
            devObj.phoneNumber=devDic[@"eqPhone"]; // 强制取出phoneNumber
          //  devObj.bindIMEI = devDic[@"eqid"];
            if (!devObj) {
                NSLog(@"eqPhone=%@",devDic[@"eqPhone"]);
                NSLog(@"IMEI=====%@",devDic[@"eqid"]);
                devObj = [[DeviceModel alloc] initWithName:devDic[@"eqTitle"] phone:devDic[@"eqPhone"] imei:devDic[@"eqId"] withUrl:devDic[@"eqPic"]];
            }
            [newDeviceDic setValue:devObj forKey:devObj.bindIMEI];
        }
        [UserData Instance].deviceDic = newDeviceDic;
        [[UserData Instance] saveCustomObject:[UserData Instance]];
        
        [self refreshTableView];
    })
}
_Method_RequestFailed()

@end
