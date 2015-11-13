//
//  MessageCenter_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "RemoteCare_ViewController.h"
#import "RemoteCare_TableViewCell.h"
#import "OperationQueue.h"
#import "MD5.h"

@interface RemoteCare_ViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UIButton *getLocationButton;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *cueLabel;
    __weak IBOutlet UILabel *dateLabel;
    NSDateFormatter *df;
    
    IBOutlet UITableView *_devList;
    UIButton *submitButton;
    NSArray *devAscKeys;
}
- (IBAction)onGetLocationButtonPressed:(UIButton *)sender;

@end

@implementation RemoteCare_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"远程看护", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    [getLocationButton setTitle:NSLocalizedString(@"获取位置", nil) forState:UIControlStateNormal];
    cueLabel.text = NSLocalizedString(@"没有更多的历史记录了", nil);
    
    //看护内容TableView
    {
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageCenter_background2"]];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 370, 1)];
        v.backgroundColor = [UIColor colorWithRed:175/255.0 green:135/255.0 blue:105/255.0 alpha:1];
        _tableView.tableHeaderView = v;
        
        [_tableView registerNib:[UINib nibWithNibName:@"RemoteCare_TableViewCell" bundle:nil] forCellReuseIdentifier:@"RemoteCareCell"];
    }
    
    //选择设备TableView
    {
        int devCount = [UserData Instance].deviceDic.count;
        if (devCount > 4) {
            _devList.frame = CGRectMake(320-100, -4*40, 100, 4*40);
        } else {
            _devList.frame = CGRectMake(320-100, -devCount*40, 100, devCount*40);
        }
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:_devList.bounds];
        backgroundImgView.image = [UIImage imageNamed:@"03_around_dropDownList"];
        _devList.backgroundView = backgroundImgView;
        _devList.layer.borderWidth = 1;
        _devList.layer.borderColor = _Color_font1.CGColor;
        [self.view addSubview:_devList];
        
        devAscKeys = [UserData Instance].deviceDic.allKeys;
    }
    if ([UserData Instance].deviceDic.count) {
        //设备排序
        NSArray *keyArr = [[UserData Instance].deviceDic allKeys];
        devAscKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            return result==NSOrderedDescending;
        }];
    }
    
    //设置日期Label  格式：2014-08-07  星期四
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    dateLabel.text = [NSString stringWithFormat:@"%@  %@", [df stringFromDate:now], [MD5 getWeekStringWithDate:now]];
    
    [df setDateFormat:@"MM-dd\nhh:mm"];
}

-(void)viewWillAppear:(BOOL)animated {
    cueLabel.hidden = (self.selDev.remoteCare.count>5 ? YES:NO);
    [_tableView reloadData];
}

_Method_SetBackButton(nil, NO)

-(void)setSubmitButton {
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    if (self.selDev.avatar) {
        [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
    } else {
        [submitButton setImage:[UIImage imageNamed:@"2_avatar_child_88"] forState:UIControlStateNormal];
    }
    [submitButton addTarget:self action:@selector(onSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}
-(void)onSubmitButtonClick {
    submitButton.selected = !submitButton.selected;
    [UIView animateWithDuration:0.15 animations:^{
        if (submitButton.selected) {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, _devList.bounds.size.height/2-1);
        } else {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, -(_devList.bounds.size.height/2));
        }
    }];
}

- (IBAction)onGetLocationButtonPressed:(UIButton *)sender {
    
    [[OperationQueue Instance] setSingle:self.selDev];
    

        LookAtTheMap_ViewController *lookMapVC = [[LookAtTheMap_ViewController alloc] initWithNibName:@"LookAtTheMap_ViewController" bundle:nil];
        lookMapVC.dev = self.selDev;
        lookMapVC.type = 1;
        [self.navigationController pushViewController:lookMapVC animated:YES];
    
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return self.selDev.remoteCare.count;
    }
    return [UserData Instance].deviceDic.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView != _tableView) {
        return nil;
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageCenter_background2"]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 320-55, 25)];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = _Color_font1;
    lb.text = NSLocalizedString(@"历史记录", nil);
    [v addSubview:lb];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        RemoteCare_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemoteCareCell"];
        [cell refreshCellWithDictionary:self.selDev.remoteCare[self.selDev.remoteCare.count-1-indexPath.row] dateFormatter:df];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
            imgView.tag = 100;
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100-45, 40)];
            lb.font = [UIFont systemFontOfSize:10];
            lb.textColor = _Color_font2;
            lb.lineBreakMode = NSLineBreakByCharWrapping;
            lb.tag = 101;
            
            [cell addSubview:imgView];
            [cell addSubview:lb];
        }
        DeviceModel *dev = [UserData Instance].deviceDic[devAscKeys[indexPath.row]];
        ((UIImageView *)[cell viewWithTag:100]).image =[UIImage imageWithData:dev.avatar];
        ((UILabel *)[cell viewWithTag:101]).text =dev.nickName;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _devList) {
        self.selDev = [UserData Instance].deviceDic[devAscKeys[indexPath.row]];
        [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
        
        [_tableView reloadData];
        cueLabel.hidden = (self.selDev.remoteCare.count>5 ? YES:NO);
        [self onSubmitButtonClick];
    } else {
        LookAtTheMap_ViewController *lookMapVC = [[LookAtTheMap_ViewController alloc] initWithNibName:@"LookAtTheMap_ViewController" bundle:nil];
        
        NSDictionary *dic = self.selDev.remoteCare[self.selDev.remoteCare.count-1-indexPath.row];
        
        NSLog(@"dic = %@", dic);
        
        lookMapVC.phoneL = dic[@"phoneL"];
        lookMapVC.devL = dic[@"devL"];
        lookMapVC.type = 2;
        lookMapVC.dev = self.selDev;
        [self.navigationController pushViewController:lookMapVC animated:YES];
    }
}

@end