//
//  Login_ViewController.m
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import "Login_ViewController.h"
@interface Login_ViewController ()<ASIHTTPRequestDelegate> {
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIButton *autoLoginButton;
    
    ASIHTTPRequest *req;
}
- (IBAction)onCheckButtonPressed:(UIButton *)sender;
- (IBAction)onForgetPasswordButtonPressed:(UIButton *)sender;
- (IBAction)onRegisterButtonPressed:(UIButton *)sender;
- (IBAction)onLoginButtonPressed:(UIButton *)sender;
@end


@implementation Login_ViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"登录", nil);
    [self setBackButton];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"tempAccount"]) {
        userNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"tempAccount"];
    } else if ([UserData Instance].tempAccount) {
        userNameTextField.text = [UserData Instance].tempAccount;
    }
}

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)

//textField事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == userNameTextField) {
        [textField setBackground:[UIImage imageNamed:@"02_textField_account_selected"]];
    } else {
        [textField setBackground:[UIImage imageNamed:@"02_textField_password_selected"]];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == userNameTextField) {
        [textField setBackground:[UIImage imageNamed:@"02_textField_account"]];
    } else {
        [textField setBackground:[UIImage imageNamed:@"02_textField_password"]];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//CheckBox
- (IBAction)onCheckButtonPressed:(UIButton *)bt {
    bt.selected = !bt.selected;
}

//忘记密码
- (IBAction)onForgetPasswordButtonPressed:(UIButton *)sender {
    ForgetPassword_ViewController *forgetPasswordVC = [[ForgetPassword_ViewController alloc] initWithNibName:@"ForgetPassword_ViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

//注册
- (IBAction)onRegisterButtonPressed:(UIButton *)sender {
    RegisterPage_ViewController *registerVC = [[RegisterPage_ViewController alloc] initWithNibName:@"RegisterPage_ViewController" bundle:nil];
    registerVC.tempAccount = userNameTextField.text;
    registerVC.tempPassword = passwordTextField.text;
    [self.navigationController pushViewController:registerVC animated:YES];
}

//登录
- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    [self touchesBegan:nil withEvent:nil];
    
    if ([userNameTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入邮箱名", nil)];
        [alertView show];
        return;
    } else if ([passwordTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入密码", nil)];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_login forKey:@"method"];
    [signInfo setValue:userNameTextField.text forKey:@"username"];
    [signInfo setValue:[MD5 md5:passwordTextField.text] forKey:@"password"];
    
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
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        NSLog(@"登录成功！");
        
        NSLog(@"jsonDic=%@",jsonDic);
          
       // [UserData Instance].account = jsonDic[@"message"];
        [UserData Instance].account = jsonDic[@"email"];
        [UserData Instance].uid = ((NSNumber *)jsonDic[@"userId"]).stringValue;
        [UserData Instance].sessionId = jsonDic[@"sessionId"];
        if (jsonDic[@"nickName"]) {
            [UserData Instance].nickName = [jsonDic[@"nickName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        } else {
            [UserData Instance].nickName = @"";
        }
        
        [UserData Instance].sex = ((NSNumber *)jsonDic[@"sex"]).intValue;
        
        [UserData Instance].avatarUrl=jsonDic[@"avatar"];
        NSLog(@"-----avatarUrl = %@]",jsonDic[@"avatar"]);
        
        [UserData Instance].avatarData=[NSData dataWithContentsOfURL:[NSURL URLWithString:jsonDic[@"avatar"]]];
        
        //保存Uid、Account
        if (autoLoginButton.selected) {
            [[NSUserDefaults standardUserDefaults] setObject:[UserData Instance].uid forKey:@"AccountUid"];
        } else {
            //清除自动登录
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AccountUid"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[UserData Instance].account forKey:@"tempAccount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //如果读档失败，就存档
        if (![[UserData Instance] autoLoginWithUid:[UserData Instance].uid type:1]) {
            
            if ([UIImage imageWithData:[UserData Instance].avatarData] == nil) {
                
                [UserData Instance].avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_child_88"]);
            }
            [[UserData Instance] saveCustomObject:[UserData Instance]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    })
}

_Method_RequestFailed()

@end
