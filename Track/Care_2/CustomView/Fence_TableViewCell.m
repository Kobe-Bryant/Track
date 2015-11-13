//
//  Fence_TableViewCell.m
//  Care_2
//
//  Created by lq on 14-11-6.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Fence_TableViewCell.h"


@interface Fence_TableViewCell()
{

    __weak IBOutlet UILabel *devNameLabel;
    __weak IBOutlet UIImageView *devImageView;
    __weak IBOutlet UILabel *fenceDistLabel;
    __weak IBOutlet UILabel *explainLabel1;
    __weak IBOutlet UILabel *explainLabel2;
    
    __weak IBOutlet UIButton *cancelLocationButton;
    __weak IBOutlet UIButton *lookAtTheMapButton;

     DeviceModel *devObj;
    
}

- (IBAction)onCancelLocationButtonPressed:(UIButton *)sender;
- (IBAction)onLookAtTheMapButtonPressed:(UIButton *)sender;

@end


@implementation Fence_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
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
}

-(void)setOnCancelCareButtonPressed:(void (^)(DeviceModel *devObj))_onCancelCareButtonPressed {
    onCancelCareButtonPressed = _onCancelCareButtonPressed;
}
-(void)setOnLookMapButtonPressed:(void (^)(DeviceModel *devObj))_onLookMapButtonPressed {
    onLookMapButtonPressed = _onLookMapButtonPressed;
}


// 取消定位
- (IBAction)onCancelLocationButtonPressed:(UIButton *)sender {
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleThreeWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"要取消对 %@ 的预警吗？", nil), devObj.nickName] cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            if (onCancelCareButtonPressed != NULL) {
                onCancelCareButtonPressed(devObj);
            }
        }
    }];
    [alertView show];
}

// 地图查看
- (IBAction)onLookAtTheMapButtonPressed:(UIButton *)sender {
    
    if (onLookMapButtonPressed != NULL) {
        onLookMapButtonPressed(devObj);
    }

}



- (void)refreshCellWithDevObj:(DeviceModel *)_devObj
{
    devObj = _devObj;
    
    devImageView.image = [UIImage imageWithData:devObj.avatar];
    devNameLabel.text = devObj.nickName;
    NSLog(@"fenceDist=%d", devObj.fenceDist);

    fenceDistLabel.text = [NSString stringWithFormat:@"%d", devObj.fenceDist];
    explainLabel1.text = NSLocalizedString(@"预设", nil);
    explainLabel2.text = NSLocalizedString(@"米范围", nil);
    
}




@end

