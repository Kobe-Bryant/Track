//
//  SelectCareDev_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-25.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "SelectCareDev_TableViewController.h"

@interface SelectCareDev_TableViewController () {
    UITableView *_tableView;
    
    NSArray *ascKeys;
}

@end

@implementation SelectCareDev_TableViewController

-(void)setDidSelectDevice:(void (^)(DeviceModel *))_didSelectDevice {
    didSelectDevice = _didSelectDevice;
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
    
    NSArray *keyArr = [self.notCareDevDic allKeys];
    ascKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        return result==NSOrderedDescending;
    }];
}

_Method_SetBackButton(nil, NO);

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notCareDevDic.count;
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
        imgView.layer.borderWidth = _Avatar_width;
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
    DeviceModel *devObj = self.notCareDevDic[ascKeys[indexPath.row]];
    ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageWithData:devObj.avatar];
    ((UILabel *)[cell viewWithTag:101]).text = devObj.nickName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (didSelectDevice != NULL) {
        didSelectDevice(self.notCareDevDic[ascKeys[indexPath.row]]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
