//
//  HomePage_ViewController.h
//  Care
//
//  Created by Vecklink on 14-7-7.
//
//

#import <UIKit/UIKit.h>
#import "Login_ViewController.h"
#import "RegisterPage_ViewController.h"
#import "AddDevice_ViewController.h"
#import "Userinfo_TableViewController.h"
#import "Around_TableViewController.h"
#import "MessageCenter_ViewController.h"
#import "DeviceModel.h"
@interface HomePage_ViewController : UIViewController
@property (nonatomic,weak) DeviceModel * model;
@end
