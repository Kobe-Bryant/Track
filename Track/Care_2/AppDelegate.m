//
//  AppDelegate.m
//  Care_2
//
//  Created by JIA on 14-8-11.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AppDelegate.h"
#import "Nav_ViewController.h"
#import "HomePage_ViewController.h"
#import "UserData.h"

#define APIKey AIzaSyDIz_0k1tNqndRTaaFOrouNP8NrNTU7OHI

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Google地图APIKey
   // [GMSServices provideAPIKey:@"AIzaSyDIz_0k1tNqndRTaaFOrouNP8NrNTU7OHI"];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    HomePage_ViewController *homePageVC = [[HomePage_ViewController alloc] initWithNibName:@"HomePage_ViewController" bundle:nil];
    //    ClientViewController *clientVC = [[ClientViewController alloc] init];
    
    Nav_ViewController *nav = [[Nav_ViewController alloc] initWithRootViewController:homePageVC];
    [self.window setRootViewController:nav];
    
    //设置状态栏
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
        
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UserData Instance] saveCustomObject:[UserData Instance]];
    [[UserData Instance] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UserData Instance] saveCustomObject:[UserData Instance]];
    [[UserData Instance] save];
}

@end
