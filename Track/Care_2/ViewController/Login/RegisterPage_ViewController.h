//
//  RegisterPage_ViewController.h
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import <UIKit/UIKit.h>
#import "RegisterFinish_ViewController.h"
#import "RegisterProtocol_ViewController.h"

#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"

#import "UserData.h"
#import "ASIHTTPRequest.h"
#import "MD5.h"

@interface RegisterPage_ViewController : UIViewController

@property (nonatomic, copy) NSString *tempAccount;
@property (nonatomic, copy) NSString *tempPassword;

@end
