//
//  RegisterFinish_ViewController.m
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import "RegisterFinish_ViewController.h"
#import "Login_ViewController.h"

@interface RegisterFinish_ViewController () {
    
    __weak IBOutlet UILabel *uidLabel;
}
- (IBAction)onReturnLoginPageButtonPressed:(UIButton *)sender;

@end

@implementation RegisterFinish_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"注册乐卡帐号", nil);
    [self setBackButton];
    
    if (_uid && _uid.intValue!=0) {
        uidLabel.text = _uid.stringValue;
    }
}

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)

//返回登录页面
- (IBAction)onReturnLoginPageButtonPressed:(UIButton *)sender {
    if (self.navigationController.viewControllers.count > 5) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    } else {
        Login_ViewController *loginVC = [[Login_ViewController alloc] initWithNibName:@"Login_ViewController" bundle:nil];
        self.navigationController.viewControllers = @[self.navigationController.viewControllers[0], loginVC, self];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

@end
