//
//  RegisterPage_ViewController.m
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import "RegisterPage_ViewController.h"

@interface RegisterPage_ViewController () {
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIButton *checkButton;
    
    ASIHTTPRequest *req;
}
- (IBAction)onCheckButtonPressed:(UIButton *)bt;
- (IBAction)onProtocolButtonPressed:(UIButton *)sender;

@end

@implementation RegisterPage_ViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"注册乐卡帐号", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    if (_tempAccount && ![_tempAccount isEqualToString:@""]) {
        userNameTextField.text = _tempAccount;
        passwordTextField.text = _tempPassword;
    }
}

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

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)

_Method_SetSubmitButton(NSLocalizedString(@"提交", nil), (@selector(onSubmitButtonPressed)), _StringWidth(NSLocalizedString(@"提交", nil)))

-(void)onSubmitButtonPressed {
    [self touchesBegan:nil withEvent:nil];
    
    if ([userNameTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入邮箱名", nil)];
        [alertView show];
        return;
    } else if (![MD5 validateEmail:userNameTextField.text]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"邮箱格式不正确", nil)];
        [alertView show];
        return;
    } else if ([passwordTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入密码", nil)];
        [alertView show];
        return;
    } else if (![MD5 validatePassword:passwordTextField.text]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"密码由6-16位数字、字母组成，不可包含空格和特殊字符", nil)];
        [alertView show];
        return;
    } else if (!checkButton.selected) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请确认是否已经阅读《一米注册协议》", nil)];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_registerbyemail forKey:@"method"];
    [signInfo setValue:userNameTextField.text forKey:@"email"];
    [signInfo setValue:[MD5 md5:passwordTextField.text] forKey:@"password"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}



//CheckBox
- (IBAction)onCheckButtonPressed:(UIButton *)bt {
    bt.selected = !bt.selected;
}

- (IBAction)onProtocolButtonPressed:(UIButton *)sender {
    RegisterProtocol_ViewController *registerProtocolVC = [[RegisterProtocol_ViewController alloc] initWithNibName:@"RegisterProtocol_ViewController" bundle:nil];
    [self.navigationController pushViewController:registerProtocolVC animated:YES];
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    _Code_HTTPResponseCheck(jsonDic, {
        RegisterFinish_ViewController *registerFinishVC = [[RegisterFinish_ViewController alloc] initWithNibName:@"RegisterFinish_ViewController" bundle:nil];
        registerFinishVC.uid = jsonDic[@"userId"];
        [self.navigationController pushViewController:registerFinishVC animated:YES];
        
        [UserData Instance].tempAccount = userNameTextField.text;
    })
}

_Method_RequestFailed()

@end
