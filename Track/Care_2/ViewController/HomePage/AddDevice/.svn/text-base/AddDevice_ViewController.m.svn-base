//
//  AddDevice_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-9.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AddDevice_ViewController.h"
#import "DeviceModel.h"

@interface AddDevice_ViewController () {
    __weak IBOutlet UITextField *uPhoneTextField1;
    __weak IBOutlet UITextField *eqPhoneTextField1;
}

@end

@implementation AddDevice_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"绑定电话号码", nil);
    [self setBackButton];
    [self setSubmitButton];
}

_Method_textFieldEvent((@[uPhoneTextField1, eqPhoneTextField1]))

_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"下一步", nil), (@selector(onAddDeviceButtonPressed)), _StringWidth(NSLocalizedString(@"下一步", nil)))

-(void)onAddDeviceButtonPressed {
    [self touchesBegan:nil withEvent:nil];
    
    NSString *message;
    if ([eqPhoneTextField1.text isEqualToString:@""]) {
        message = NSLocalizedString(@"请输入设备手机号", nil);
    } else if (eqPhoneTextField1.text.length<9 || eqPhoneTextField1.text.length>11) {
        message = NSLocalizedString(@"只能输入9位或11位数字", nil);
    }
//    else if (![MD5 checkPhoneNumInput:uPhoneTextField1.text] || ![MD5 checkPhoneNumInput:eqPhoneTextField1.text]) {
//        message = NSLocalizedString(@"手机号码格式不正确，请输入正确的手机号码", nil);
//    }
    if (message) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:message];
        [alertView show];
        return;
    }
    

    DeviceSetting_TableViewController *devSettingTVC = [[DeviceSetting_TableViewController alloc] initWithNibName:@"DeviceSetting_TableViewController" bundle:nil];
    devSettingTVC.tempUphone = @"123456789";
    devSettingTVC.tempEqphone = eqPhoneTextField1.text;
    devSettingTVC.isAdd=YES;
    [self.navigationController pushViewController:devSettingTVC animated:YES];
}



@end
