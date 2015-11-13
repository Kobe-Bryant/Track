//
//  ForgetPassword_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-13.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "ForgetPassword_ViewController.h"

@interface ForgetPassword_ViewController () {
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    
    ASIHTTPRequest *req;
}

@end

@implementation ForgetPassword_ViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"忘记密码", nil);
    [self setBackButton];
    [self setSubmitButton];
}

//textField事件
_Method_textFieldEvent((@[userNameTextField, passwordTextField]))
//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"下一步", nil), (@selector(onNextButtonPressed)), _StringWidth(NSLocalizedString(@"下一步", nil)))


-(void)setSubmitButton2 {
    NSString * buttonTitle = @"";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [buttonTitle boundingRectWithSize:CGSizeMake(0, 16) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, size.width+10, 44);
    [submitButton setImage:[UIImage imageNamed:@"01_btn_nav"] forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"01_btn_nav_selected"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(onNextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};

    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, size.width+10, 45)];
    lb.text = buttonTitle;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont boldSystemFontOfSize:14];
    lb.textColor = _Color_font1;
    [submitButton addSubview:lb];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}

-(void)onNextButtonPressed {
    [self touchesBegan:nil withEvent:nil];
    
    if ([userNameTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入邮箱名", nil)];
        [alertView show];
        return;
    } else if (![MD5 validateEmail:userNameTextField.text]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"邮箱格式不正确", nil)];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_resetpasswordbyemail forKey:@"method"];
    [signInfo setValue:userNameTextField.text forKey:@"email"];
    [signInfo setValue:[MD5 md5:passwordTextField.text] forKey:@"newPassword"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}

-(void)viewDidAppear:(BOOL)animated {
    [userNameTextField becomeFirstResponder];
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    _Code_HTTPResponseCheck(jsonDic, {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"密码重置邮件发送成功，请到邮箱验证后登录", nil)];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
    })
}
_Method_RequestFailed()

@end
