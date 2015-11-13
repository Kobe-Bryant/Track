//
//  Map.h
//  Mapdksl000
//
//  Created by HelloWorld on 14-7-25.
//  Copyright (c) 2014年 JF. All rights reserved.
//
//此对象用于：给出设备坐标，定位手机坐标与计算出设备于手机的距离

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PhoneLocation : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager * _manager ;
    
    void (^onLocationFinish)(CLLocation *phoneLocation);
}

+(PhoneLocation *)Instance;

-(void)setOnLocationFinish:(void (^)(CLLocation *phoneL))onLocationFinish;
-(void)startLocation;

-(CLLocation *)locationWithLa:(CGFloat)la lo:(CGFloat)lo;
-(CGFloat)getDistanceWithDevLocation:(CLLocation *)devL phoneLocation:(CLLocation *)phoneL;

@end
