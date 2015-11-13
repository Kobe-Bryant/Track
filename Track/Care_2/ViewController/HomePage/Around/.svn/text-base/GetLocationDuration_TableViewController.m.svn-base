//
//  careInterval_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-9.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "GetLocationDuration_TableViewController.h"

@interface GetLocationDuration_TableViewController () {
    UITableViewCell *_cell;
    
    NSArray *itemTitleArray;
    
    int selectedIndex;
}

@end

@implementation GetLocationDuration_TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButton];
    [self setSubmitButton];
    
    UITableView *_tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 60)];
    lb.numberOfLines = 2;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor orangeColor];
    lb.font = [UIFont systemFontOfSize:13];
    lb.text = NSLocalizedString(@"提示：设置时间越短，位置显示的实时性越强！", nil);
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [v addSubview:lb];
    _tableView.tableHeaderView = v;
    
    if (!itemTitleArray) {
        itemTitleArray = @[@60, @30, @20, @15, @10, @5];
    }
}

_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(onSaveButtonPressed)), _StringWidth(NSLocalizedString(@"保存", nil)))

-(void)onSaveButtonPressed {
    [self.obj setValue:itemTitleArray[selectedIndex] forKey:@"careInterval"];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存成功", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_second_background"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_second_background_selected"]]];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor whiteColor];
        lb.font = [UIFont systemFontOfSize:13];
        lb.text = [NSString stringWithFormat:@"%@s", itemTitleArray[indexPath.row]];
        [cell addSubview:lb];
        
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell) {
        if (![_cell isEqual:[tableView cellForRowAtIndexPath:indexPath]]) {
            _cell.selected = NO;
        }
        _cell = nil;
    }
    selectedIndex = indexPath.row;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([itemTitleArray[indexPath.row] integerValue] == [[self.obj valueForKey:@"careInterval"] integerValue]) {
        cell.selected = YES;
        selectedIndex = indexPath.row;
        _cell = cell;
    }
}

@end
