//
//  Around_TableViewCell.m
//  Q2_local
//
//  Created by Vecklink on 14-7-18.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Around_TableViewCell.h"

@interface Around_TableViewCell() {
    
    __weak IBOutlet UILabel *userNameLabel;
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UILabel *devNameLabel;
    __weak IBOutlet UIImageView *devImageView;
    
    __weak IBOutlet UILabel *careDistLabel;
    __weak IBOutlet UILabel *nowDistLabel;
    __weak IBOutlet UILabel *nowDistExplainLabel;
    
    __weak IBOutlet UIImageView *careTypeImageView;
    
    __weak IBOutlet UIButton *cancelLocationButton;
    __weak IBOutlet UIButton *lookAtTheMapButton;
    DeviceModel *devObj;
}
- (IBAction)onCancelLocationButtonPressed:(UIButton *)sender;
- (IBAction)onLookAtTheMapButtonPressed:(UIButton *)sender;

@end

@implementation Around_TableViewCell

- (void)awakeFromNib
{
    // Initialization code
    userImageView.layer.cornerRadius = 7;
    userImageView.layer.masksToBounds = YES;
   // devImageView.layer.cornerRadius = devImageView.bounds.size.height/2;
    devImageView.layer.masksToBounds = YES;
    devImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    devImageView.layer.borderWidth = 1;
    
    [cancelLocationButton setTitle:NSLocalizedString(@"取消定位", nil) forState:UIControlStateNormal];
    [lookAtTheMapButton setTitle:NSLocalizedString(@"地图查看", nil) forState:UIControlStateNormal];
    
    if (_Is_En_Language) {
        cancelLocationButton.titleLabel.font = [UIFont systemFontOfSize:12];
        cancelLocationButton.titleLabel.numberOfLines = 2;
        cancelLocationButton.frame = CGRectMake(23, 88, 76, 30);
        
        lookAtTheMapButton.titleLabel.font = [UIFont systemFontOfSize:12];
        lookAtTheMapButton.titleLabel.numberOfLines = 2;
        lookAtTheMapButton.frame = CGRectMake(226, 88, 76, 30);
    }
    
    self.backgroundColor = _Color_background;
}

-(void)setOnCancelCareButtonPressed:(void (^)(DeviceModel *devObj))_onCancelCareButtonPressed {
    onCancelCareButtonPressed = _onCancelCareButtonPressed;
}
-(void)setOnLookMapButtonPressed:(void (^)(DeviceModel *devObj))_onLookMapButtonPressed {
    onLookMapButtonPressed = _onLookMapButtonPressed;
}

-(void)refreshCellWithDevObj:(DeviceModel *)_devObj {
    devObj = _devObj;
    
    userImageView.image = [UIImage imageWithData:[UserData Instance].avatarData];
    userNameLabel.text = [UserData Instance].nickName;
    devImageView.image = [UIImage imageWithData:devObj.avatar];
    devNameLabel.text = devObj.nickName;
    
    careDistLabel.text = [NSString stringWithFormat:NSLocalizedString(@"预设%d米范围", nil), devObj.careDist];
    NSLog(@"careDist＝%d",devObj.careDist);
//    nowDistLabel.text = [NSString stringWithFormat:@"%@", devObj.nowDist];
    nowDistLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", devObj.bindIMEI]];

    
    NSMutableString *nowDistExplainStr = [NSMutableString stringWithString:NSLocalizedString(@"当前距离  ", nil)];
    if (!_Is_En_Language) {
        for (int i=0; i<nowDistLabel.text.length; i++) {
            [nowDistExplainStr appendString:@"  "];
        }
        [nowDistExplainStr appendString:NSLocalizedString(@"米范围", nil)];
    } else {
        nowDistExplainLabel.textAlignment = NSTextAlignmentLeft;
        nowDistExplainLabel.center = CGPointMake(162, nowDistExplainLabel.center.y);
        nowDistLabel.textAlignment = NSTextAlignmentLeft;
        nowDistLabel.center = CGPointMake(223, nowDistLabel.center.y);
        
    }
    
    nowDistExplainLabel.text = nowDistExplainStr;
    
    careTypeImageView.image = [UIImage imageNamed:(devObj.careType ? @"03_around_ico_fence":@"03_around_ico_care")];
}

- (IBAction)onCancelLocationButtonPressed:(UIButton *)sender {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleThreeWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"要取消对 %@ 的关爱吗？", nil), devObj.nickName] cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            if (onCancelCareButtonPressed != NULL) {
                onCancelCareButtonPressed(devObj);
            }
        }
    }];
    [alertView show];
}

- (IBAction)onLookAtTheMapButtonPressed:(UIButton *)sender {
    if (onLookMapButtonPressed != NULL) {
        onLookMapButtonPressed(devObj);
    }
}

@end
