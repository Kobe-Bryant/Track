//
//  ModifyUserName_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "ModifyUserName_ViewController.h"

@interface ModifyUserName_ViewController () {
    
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UILabel *msgLabel;
}

@end

@implementation ModifyUserName_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改昵称", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    userNameTextField.text = [self.obj valueForKey:@"nickName"];
    msgLabel.text = NSLocalizedString(@"只能是1-8个汉字、字母、数字、或随意组合", nil);
}

-(void)viewDidAppear:(BOOL)animated {
    [userNameTextField becomeFirstResponder];
}

_Method_textFieldEvent(@[userNameTextField])
_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(onSaveButtonPressed)), _StringWidth(NSLocalizedString(@"保存", nil)))

-(void)onSaveButtonPressed {
    [self touchesBegan:nil withEvent:nil];
    
    if ([userNameTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"昵称不能为空", nil)];
        [alertView show];
        return;
    }

//    只能是1-8个汉字、字母、数字、或随意组合
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        if (userNameTextField.text.length > 8) {
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:@"提醒" message:@"昵称不能超过8个字符，请重新输入"];
            [alerView show];
            return;
        }
    }
    [self.obj setValue:userNameTextField.text forKey:@"nickName"];
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存成功", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) {
        return YES;
    }
    
    char ch = [string characterAtIndex:0];
    if (3==strlen([string UTF8String])
        || ((ch > 47)&&(ch < 58))
        || ((ch > 64)&&(ch < 91))
        || ((ch > 96)&&(ch < 123))){
    } else {
        //特殊字符不给输入
        return NO;
    }
    
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        if ([textField.text length]  >= 8) {
            return NO;
        }

    }else{
        if ([textField.text length]  >= 20) {
            return NO;
        }
    }
    
    return YES;
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

@end
