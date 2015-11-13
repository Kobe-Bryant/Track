//
//  Map.m
//  Mapdksl000
//
//  Created by HelloWorld on 14-7-25.
//  Copyright (c) 2014年 JF. All rights reserved.
//

#import "PhoneLocation.h"
#import "CustomIOS7AlertView.h"

@implementation PhoneLocation

+(PhoneLocation *)Instance
{
    static PhoneLocation *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[PhoneLocation alloc] init];
        }
        return _instance;
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        [_manager setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
        [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}
-(void)setOnLocationFinish:(void (^)(CLLocation *))_onLocationFinish {
    onLocationFinish = _onLocationFinish;
}

-(void)startLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_manager startUpdatingLocation];
    } else {
        static BOOL remind = YES;
        if (remind) {
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"亲，您还没将定位功能打开哟，赶紧打开吧！", nil)];
            [alertView show];
            remind = NO;
        }
    }
}

-(CLLocation *)locationWithLa:(CGFloat)la lo:(CGFloat)lo {
    return [[CLLocation alloc]initWithLatitude:la longitude:lo];
}
-(CGFloat)getDistanceWithDevLocation:(CLLocation *)devL phoneLocation:(CLLocation *)phoneL {
    NSLog(@"手机位置 =%@\n ", phoneL);
    NSLog(@"设备位置：%@\n ", devL);
    //计算手机与设备之间的距离
    return [phoneL distanceFromLocation:devL];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *phoneL = [locations lastObject];
    
    if ([phoneL.timestamp timeIntervalSinceNow] < -5.0) {
		return;
	}
	if (phoneL.horizontalAccuracy < 0) {
		return;
	}
    NSLog(@"startLocation--------D");
    //调用block
    if (onLocationFinish != NULL) {
        onLocationFinish(phoneL);
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"手机定位失败：error is %@",error);
    if (error.code == kCLErrorLocationUnknown) {
		return;
	}
    [_manager stopUpdatingLocation];
}

@end
