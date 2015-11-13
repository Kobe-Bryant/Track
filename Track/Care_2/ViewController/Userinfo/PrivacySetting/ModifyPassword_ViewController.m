//
//  ModifyPasswold_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "ModifyPassword_ViewController.h"

@interface ModifyPassword_ViewController () {
    
    __weak IBOutlet UILabel *accountLabel;
    __weak IBOutlet UITextField *currentPasswordTextField;
    __weak IBOutlet UITextField *newPasswordTextField;
    __weak IBOutlet UITextField *confirmPasswordTextField;
    
    ASIHTTPRequest *req;
}
- (IBAction)onModifyPasswordButtonPressed:(UIButton *)sender;

@end

@implementation ModifyPassword_ViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改密码", nil);
    [self setBackButton];
    
    accountLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"乐卡帐号", nil), [UserData Instance].account];
}

_Method_SetBackButton(nil, NO)
_Method_textFieldEvent((@[currentPasswordTextField, newPasswordTextField, confirmPasswordTextField]))

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (([textField.text length] + [string length] - range.length) > 30 && textField == currentPasswordTextField) {
        return NO;
    }
    return YES;
}

- (IBAction)onModifyPasswordButtonPressed:(UIButton *)sender {
    [self touchesBegan:nil withEvent:nil];
    
    if ([currentPasswordTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入当前密码", nil)];
        [alertView show];
        return;
    } else if ([newPasswordTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入新密码", nil)];
        [alertView show];
        return;
    } else if ([confirmPasswordTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入确认密码", nil)];
        [alertView show];
        return;
    } else if (![newPasswordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"两次密码输入不一致，请重新输入", nil)];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            newPasswordTextField.text = @"";
            confirmPasswordTextField.text = @"";
        }];
        [alertView show];
        return;
    } else if (![MD5 validatePassword:newPasswordTextField.text]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"密码由6-16位数字、字母组成，不可包含空格和特殊字符", nil)];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_changepassword forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[MD5 md5:currentPasswordTextField.text] forKey:@"oldPassword"];
    [signInfo setValue:[MD5 md5:newPasswordTextField.text] forKey:@"newPassword"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response= :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"修改成功", nil)];
        [alertView show];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    })
}
_Method_RequestFailed()

@end
