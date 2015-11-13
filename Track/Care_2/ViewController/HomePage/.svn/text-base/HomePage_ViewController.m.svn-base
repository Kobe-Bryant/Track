//
//  HomePage_ViewController.m
//  Care
//
//  Created by Vecklink on 14-7-7.
//
//

#import "HomePage_ViewController.h"
#import "HomePage_WeatherView.h"
#import "HomePage_DevicesView.h"
#import "Nav_ViewController.h"
#import "RemoteCare_ViewController.h"
#import "QrcodeScanningVC.h"
@interface HomePage_ViewController () {
    
  
    __weak IBOutlet UIButton *loginButton;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIImageView *AdImageView;
    __weak IBOutlet UILabel *devElectricityLabel;
    UIButton *avatarButton;
    UILabel *userNameLabel;
    
    __weak IBOutlet UIButton *remoteButton;
    __weak IBOutlet UIButton *aroundButton;
    HomePage_DevicesView *devsView;
    HomePage_WeatherView *weatherView;
    
    DeviceModel *selectDevice_;
    
    
}
- (IBAction)onLoginButtonPressed:(UIButton *)sender;
- (IBAction)onRegisterButtonPressed:(UIButton *)sender;
- (IBAction)onStartCareButtonPressed:(UIButton *)sender;
- (IBAction)onRemoteCareButtonPressed:(UIButton *)sender;
- (IBAction)onAroundButtonPressed:(UIButton *)sender;
- (IBAction)onMessageCenterButtonPressed:(UIButton *)sender;

@end

@implementation HomePage_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自动登录
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccountUid"];
    if (uid && ![uid isEqualToString:@""]) {
        [[UserData Instance] autoLoginWithUid:uid type:0];
    }
    
    NSLog(@"uid =%@", [UserData Instance].uid);
    NSLog(@"session =%@", [UserData Instance].sessionId);
    
    
//    //引导页
//    if ([self isFirstRun]) {
//        GuideViewController *lead = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
//        //[self.navigationController pushViewController:lead animated:NO];
//        [self presentViewController:lead animated:YES completion:nil];
//    }

    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self refreshUIWithIsLogin];
    [devsView refreshDevicesView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)refreshUIWithIsLogin {
    if (!weatherView) {
        weatherView = [[NSBundle mainBundle] loadNibNamed:@"HomePage_WeatherView" owner:nil options:nil][0];
        weatherView.frame = CGRectMake(0, 80, 320, 141);
        [self.view addSubview:weatherView];
    }
    BOOL isLogin = [[UserData Instance] isLogin];
    
    NSLog(@"------------------------------------------------------");
    if (isLogin) {
        
        //登录后
        NSLog(@"isLogin");
        if (!avatarButton) {            //创建头像Button
            avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
            avatarButton.frame = CGRectMake(15, 25, 50, 50);
            UIImage *avatarImage = [UIImage imageWithData:[UserData Instance].avatarData];
            if (!avatarImage) {
                [UserData Instance].avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_child_88"]);
            }
            
            [avatarButton addTarget:self action:@selector(onAvatarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            avatarButton.layer.cornerRadius = 7;
            avatarButton.layer.masksToBounds = YES;
            [self.view addSubview:avatarButton];
        }
        
        if (!userNameLabel) {           //创建昵称Label
            userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 40, 200, 20)];
            userNameLabel.textColor = _Color_font1;
            userNameLabel.font = [UIFont boldSystemFontOfSize:14];
            [self.view addSubview:userNameLabel];
        }

        if (!devsView) {
            devsView = [[NSBundle mainBundle] loadNibNamed:@"HomePage_DevicesView" owner:nil options:nil][0];
            devsView.navigationController = self.navigationController;
            devsView.frame = AdImageView.frame;
            
            __block UILabel *devEleLabel = devElectricityLabel;
            [devsView setDidDevSelected:^{
                DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
                selectDevice_=dev;
                devEleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"当前设备电量：%d%%", nil), dev.electricity];
                devEleLabel.hidden = !dev.online;
                aroundButton.userInteractionEnabled = dev.online;
                remoteButton.userInteractionEnabled = dev.online;
                if (!dev.online) {
                    [aroundButton setImage:[UIImage imageNamed:@"main_around_tv_off_line"] forState:UIControlStateNormal];
                }else{
                    [aroundButton setImage:[UIImage imageNamed:@"01_btn_bottom_around"] forState:UIControlStateNormal];
                }
            }];
            
            __block HomePage_ViewController *vc = self;
            [devsView setDidRequestDevListFinish:^{
                NSLog(@"============");
                [vc refreshUIWithIsLogin];
            }];
            
            [self.view addSubview:devsView];
            [self.view bringSubviewToFront:AdImageView];
            
            
            //开始请求列队
            [[OperationQueue Instance] setDidDevOnlineChange:^(DeviceModel *dev) {
                [devsView refreshDeviceOnlineState:dev];
                [aroundButton setImage:[UIImage imageNamed:@"main_around_tv_off_line"] forState:UIControlStateNormal];
                aroundButton.selected = NO;
                if (isLogin && [UserData Instance].deviceDic.count) {
                    for (DeviceModel *dev in [UserData Instance].deviceDic.allValues) {
                        if (dev.online) {
                            [aroundButton setImage:[UIImage imageNamed:@"01_btn_bottom_around"] forState:UIControlStateNormal];
                            aroundButton.selected = YES;
                        }
                    }
                }
                
                devElectricityLabel.hidden = !dev.online;
            }];
            //设备在线状态改变
            [[SocketClient Instance] setDidDevOnlineChange:^(DeviceModel *dev) {
                [devsView refreshDeviceOnlineState:dev];
                
                [aroundButton setImage:[UIImage imageNamed:@"main_around_tv_off_line"] forState:UIControlStateNormal];
                aroundButton.selected = NO;
                if (isLogin && [UserData Instance].deviceDic.count) {
                    for (DeviceModel *dev in [UserData Instance].deviceDic.allValues) {
                        if (dev.online) {
                            [aroundButton setImage:[UIImage imageNamed:@"01_btn_bottom_around"] forState:UIControlStateNormal];
                            aroundButton.selected = YES;
                        }
                    }
                }
                
                devElectricityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"当前设备电量：%d%%", nil), ((DeviceModel *)[UserData Instance].deviceDic[[UserData Instance].likeDevIMEI]).electricity];
                
                devElectricityLabel.hidden = !dev.online;
            }];
        }
        
        [[OperationQueue Instance] login];
        //开启Socket
        [[SocketClient Instance] connectToHost];
    }
    
    [avatarButton setImage:[UIImage imageWithData:[UserData Instance].avatarData] forState:UIControlStateNormal];
    userNameLabel.text = [UserData Instance].nickName;
    
    AdImageView.hidden = [UserData Instance].deviceDic.count;
    loginButton.hidden = isLogin;
    registerButton.hidden = isLogin;
    
    avatarButton.hidden = !isLogin;
    userNameLabel.hidden = !isLogin;
    
    [aroundButton setImage:[UIImage imageNamed:@"main_around_tv_off_line"] forState:UIControlStateNormal];
    aroundButton.selected = NO;
    if (isLogin && [UserData Instance].deviceDic.count) {
        for (DeviceModel *dev in [UserData Instance].deviceDic.allValues) {
            if (dev.online) {
                [aroundButton setImage:[UIImage imageNamed:@"01_btn_bottom_around"] forState:UIControlStateNormal];
                aroundButton.selected = YES;
                
                if ([UserData Instance].deviceDic.count==1) {
                    devElectricityLabel.hidden = NO;
                }
            }
        }
    } else {
        devElectricityLabel.hidden = YES;
    }
    
//    DeviceModel *dev2 = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
//    [[MusicPlayerController Instance] playWithMusicItem:dev2.musicItem isStop:YES];
}

-(void)onAvatarButtonPressed {
    Userinfo_TableViewController *userinfoTVC = [[Userinfo_TableViewController alloc] initWithNibName:@"Userinfo_TableViewController" bundle:nil];
    [self.navigationController pushViewController:userinfoTVC animated:YES];
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    Login_ViewController *loginVC = [[Login_ViewController alloc] initWithNibName:@"Login_ViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)onRegisterButtonPressed:(UIButton *)sender {
    RegisterPage_ViewController *registerVC = [[RegisterPage_ViewController alloc] initWithNibName:@"RegisterPage_ViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)onStartCareButtonPressed:(UIButton *)sender {
    if ([[UserData Instance] isLogin]) {
        
        QrcodeScanningVC *scanVC = [[QrcodeScanningVC alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
        
    } else {
        [self onLoginButtonPressed:nil];
    }
}

- (IBAction)onRemoteCareButtonPressed:(UIButton *)sender {
    if ([[UserData Instance] isLogin]) {
        if (![UserData Instance].deviceDic.count) {
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请先选择/添加设备", nil)];
            [alertView show];
            return;
        }
        
        RemoteCare_ViewController *remoteCareVC = [[RemoteCare_ViewController alloc] initWithNibName:@"RemoteCare_ViewController" bundle:nil];
        remoteCareVC.selDev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
        [self.navigationController pushViewController:remoteCareVC animated:YES];
    } else {
        [self onLoginButtonPressed:nil];
    }
}

- (IBAction)onAroundButtonPressed:(UIButton *)sender {
//    sender.selected = YES;

   
    if ([[UserData Instance] isLogin]) {
        if (!aroundButton.selected) {
            return;
        }

        Around_TableViewController *aroundTVC = [[Around_TableViewController alloc] initWithNibName:@"Around_TableViewController" bundle:nil];
        aroundTVC.devModel=selectDevice_;
        [self.navigationController pushViewController:aroundTVC animated:YES];
       
    
    } else {
        [self onLoginButtonPressed:nil];
    }

}

- (IBAction)onMessageCenterButtonPressed:(UIButton *)sender {
    
    if ([[UserData Instance] isLogin]) {
        if (![UserData Instance].deviceDic.count) {
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请先选择/添加设备", nil)];
            [alertView show];
            return;
        }
        
        MessageCenter_ViewController *messageCenterVC = [[MessageCenter_ViewController alloc] initWithNibName:@"MessageCenter_ViewController" bundle:nil];
        messageCenterVC.selDev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
        [self.navigationController pushViewController:messageCenterVC animated:YES];
    } else {
        [self onLoginButtonPressed:nil];
    }
}


//判断是否第一次运行程序
- (BOOL)isFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"IsFirstRead"]) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"IsFirstRead"];
        [defaults synchronize];
        return YES;
    }
    return NO;
}





@end
