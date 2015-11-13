//
//  MessageDetail_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MessageDetail_ViewController.h"
#import "RemoteCare_TableViewCell.h"

@interface MessageDetail_ViewController () {
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UILabel *msgLabel;
    
    NSDateFormatter *df;
}

- (IBAction)onMessageButtonPressed:(UIButton *)sender;
- (IBAction)onTrashButtonPressed:(UIButton *)sender;

@end

@implementation MessageDetail_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"消息中心", nil);
    [self setBackButton];
    msgLabel.text = NSLocalizedString(@"消息详情", nil);
    
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageCenter_background"]];
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd\nhh:mm"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RemoteCare_TableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    
}

_Method_SetBackButton(nil, NO)

- (IBAction)onMessageButtonPressed:(UIButton *)sender {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)onTrashButtonPressed:(UIButton *)sender {
    [_scrollView setContentOffset:CGPointMake(50, 0) animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteCare_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    [cell refreshCellWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.msgObj.createDate, @"date", self.msgObj.content, @"location", nil] dateFormatter:df];
    cell.backgroundColor = [UIColor clearColor];
    
    if (![cell viewWithTag:100]) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(320, 9, 50, 24);
        [bt setBackgroundImage:[UIImage imageNamed:@"03_delete_text_background"] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"03_delete_text_background_2"] forState:UIControlStateHighlighted];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [bt setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        
        [bt addTarget:self action:@selector(onMsgDeleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 100;
        [cell addSubview:bt];
    }
    
    return cell;
}

-(void)onMsgDeleteButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_onMsgDeleteButtonPress != NULL) {
        self.onMsgDeleteButtonPress();
    }
}
@end
