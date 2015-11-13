//
//  VersionUpdateViewController.m
//  Care
//
//  Created by Vecklink on 14-6-21.
//
//

#import "VersionUpdate_ViewController.h"

@interface VersionUpdate_ViewController () {
    __weak IBOutlet UILabel *versionLabel;
    __weak IBOutlet UIButton *versionUpdateButton;
    NSString *version;
}
- (IBAction)onVersionUpdateButtonPressed:(UIButton *)sender;

@end

@implementation VersionUpdate_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"版本更新", nil);
    [self setBackButton];
    
    [versionUpdateButton setTitle:NSLocalizedString(@"版本更新", nil) forState:UIControlStateNormal];
    
    version = @"1.0.1";
    
    versionLabel.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"已有版本：", nil), NSLocalizedString(@"乐卡关爱", nil), version];
    
}

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)

- (IBAction)onVersionUpdateButtonPressed:(UIButton *)sender {
    
    
}

@end
