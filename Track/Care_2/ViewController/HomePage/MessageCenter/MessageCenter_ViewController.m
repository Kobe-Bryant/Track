//
//  MessageCenter_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MessageCenter_ViewController.h"
#import "MessageDetail_ViewController.h"
#import "Message_TableViewCell.h"
#import "MD5.h"

@interface MessageCenter_ViewController () {
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *msgLabel;
    __weak IBOutlet UILabel *cueLabel;
    __weak IBOutlet UILabel *dateLabel;
    NSDateFormatter *df;
    
    IBOutlet UITableView *_devList;
    UIButton *submitButton;
    NSArray *devAscKeys;
}
- (IBAction)onMessageButtonPressed:(UIButton *)sender;
- (IBAction)onTrashButtonPressed:(UIButton *)sender;

@end

@implementation MessageCenter_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"消息中心", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    _scrollView.contentSize = CGSizeMake(370, 418);
    
    msgLabel.text = NSLocalizedString(@"消息中心", nil);
    cueLabel.text = NSLocalizedString(@"没有更多的历史记录了", nil);
    
    
    //消息内容TableView
    {
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageCenter_background"]];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 370, 7)];
        v.backgroundColor = _tableView.backgroundColor;
        _tableView.tableHeaderView = v;
        
        [_tableView registerNib:[UINib nibWithNibName:@"Message_TableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    }
    cueLabel.hidden = (self.selDev.messageArr.count>5 ? YES:NO);
    
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
    
    [[SocketClient Instance] setDidDevMsgArrChange:^{
        [_tableView reloadData];
    }];
}

_Method_SetBackButton(nil, NO)

-(void)setSubmitButton {
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
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

- (IBAction)onMessageButtonPressed:(UIButton *)sender {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)onTrashButtonPressed:(UIButton *)bt {
    bt.selected = !bt.selected;
    if (bt.selected) {
        [_scrollView setContentOffset:CGPointMake(50, 0) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return self.selDev.messageArr.count;
    }
    return [UserData Instance].deviceDic.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        Message_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
        
        MessageModel *msgObj = self.selDev.messageArr[self.selDev.messageArr.count-1-indexPath.row];
        
        [cell setOnCellMsgButtonPressed:^{
            msgObj.isRead = YES;
            MessageDetail_ViewController *msgDetailVC = [[MessageDetail_ViewController alloc] initWithNibName:@"MessageDetail_ViewController" bundle:nil];
            msgDetailVC.msgObj = msgObj;
            [msgDetailVC setOnMsgDeleteButtonPress:^{
                [self.selDev.messageArr removeObject:msgObj];
                [_tableView reloadData];
                cueLabel.hidden = (self.selDev.messageArr.count>5 ? YES:NO);
            }];
            
            [self.navigationController pushViewController:msgDetailVC animated:YES];
        }];
        [cell setOnMsgDeleteButtonPressed:^(MessageModel *msg){
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:self.selDev.messageArr.count-1-[self.selDev.messageArr indexOfObject:msg] inSection:0];
            [self.selDev.messageArr removeObject:msg];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexP] withRowAnimation:UITableViewRowAnimationMiddle];
//            [_tableView reloadData];
            cueLabel.hidden = (self.selDev.messageArr.count>5 ? YES:NO);
        }];
        [cell refreshCellWithModel:msgObj dateFormatter:df];
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
        cueLabel.hidden = (self.selDev.messageArr.count>5 ? YES:NO);
        [self onSubmitButtonClick];
    }
}
@end

