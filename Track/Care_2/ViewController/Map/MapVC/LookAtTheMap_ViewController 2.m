//
//  LookAtTheMap_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-27.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "LookAtTheMap_ViewController.h"
#define _Get_LocInfo_Count 15

@interface LookAtTheMap_ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate> {
    NSString *rightBtTitle;
    __weak IBOutlet MKMapView *_mapView;
    __weak IBOutlet UIButton *aimBtn;
    __weak IBOutlet UILabel *msgLabel;
    
    CLLocationManager * _manager;
    CLPlacemark *devMark;
    
    MKAnnotationView *lastAnnotationView;
    
    int count;
    BOOL isRegion;
}

- (IBAction)onAimButtonPressed:(UIButton *)sender;

@end

@implementation LookAtTheMap_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"地图", nil);
    
    [self setBackButton];
    isRegion = NO;
    
    if (self.type!=2) {
        rightBtTitle = (self.type ? NSLocalizedString(@"记录位置", nil) : NSLocalizedString(@"编辑", nil));
        [self setSubmitButton];
        self.devL = [[CLLocation alloc] initWithLatitude:self.dev.la longitude:self.dev.lo];
        [self startLocationManager];
        if (self.dev.online && self.devL) {
            //添加设备大头针
            MapAnnotation *annotation =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:self.devL.coordinate];
            [_mapView addAnnotation:annotation];
        }
    } else {
        //添加大头针
        MapAnnotation *pA =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:self.phoneL.coordinate];
        pA.tag = 30;
        MapAnnotation *dA =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:self.devL.coordinate];
        
        [_mapView addAnnotation:pA];
        [_mapView addAnnotation:dA];
    }
    
    //测试经纬度 “ la:22.55467253 lo:113.94541041 ”
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.type) {
        msgLabel.hidden = YES;
    } else {
        msgLabel.text = [NSString stringWithFormat:NSLocalizedString(@"     预警距离%d米", nil), self.dev.careDist];
    }
}

_Method_SetBackButton(nil, NO)

_Method_SetSubmitButton(rightBtTitle, (@selector(onRightButtonPressed)), _StringWidth(rightBtTitle))

-(void)onRightButtonPressed {
    if (self.type) {
        if (!self.dev.online || !self.devL) {
            CustomIOS7AlertView *alertView;
            alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"未搜寻到设备所在位置", nil)];
            [alertView show];
            return;
        }
        
        //记录位置
        if ([devMark name]) {
            NSLog(@"记录位置：%@", [devMark name]);
            //            [self.dev.remoteCare addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date", [devMark name], @"location", nil]];
            [self.dev.remoteCare addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date", [devMark name], @"location", self.phoneL, @"phoneL", self.devL, @"devL", nil]];
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"记录成功", nil)];
            [alerView show];
        } else {
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"正在定位，请稍等", nil)];
            [alerView show];
        }
    } else {
        //编辑
        AddCare_ViewController *addCareVC = [[AddCare_ViewController alloc] initWithNibName:@"AddCare_ViewController" bundle:nil];
        addCareVC.dev = self.dev;
        [self.navigationController pushViewController:addCareVC animated:YES];
    }
}

- (IBAction)onAimButtonPressed:(UIButton *)sender {
    if (self.type == 2) {
        [_mapView setCenterCoordinate:[self.phoneL coordinate] animated:YES];
    } else {
        [_mapView setCenterCoordinate:[_mapView.userLocation coordinate] animated:YES];
    }
}

- (void)startLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_manager) {
            _manager = [[CLLocationManager alloc]init];
            _manager.delegate = self;
            [_manager setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
            [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
        
        _mapView.showsUserLocation = YES;
        [_manager startUpdatingLocation];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"亲，您还没将定位功能打开哟，赶紧打开吧！", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.phoneL = [locations lastObject];
    NSLog(@"BBBBBBBBBBBB  %@---%d", self.phoneL, count);
    if ([self.phoneL.timestamp timeIntervalSinceNow] < -5.0) {
        return;
    }
    if (self.phoneL.horizontalAccuracy < 0) {
        return;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.phoneL.coordinate, 3000, 3000);
    [_mapView setRegion:region animated:YES];
    
    [_manager stopUpdatingLocation];
    _manager.delegate = Nil;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error is %@",error);
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [_manager stopUpdatingLocation];
    _manager.delegate = Nil;
}

//根据经纬度解析成位置
-(void)getlocationInfoWith:(CLGeocoder *)g isPhone:(BOOL)isPhone view:(MKAnnotationView *)annotationView prefix:(NSString *)prefix {
    [g reverseGeocodeLocation:(isPhone ? self.phoneL:self.devL) completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks lastObject];
        if ([mark name]) {
            [annotationView setContent:[NSString stringWithFormat:@"%@%@", prefix, [mark name]]];
            if (!isPhone) {
                devMark = mark;
            }
            count = 0;
        } else {
            [NSThread sleepForTimeInterval:0.2];
            count++;
            if (count < _Get_LocInfo_Count) {
                [self getlocationInfoWith:g isPhone:isPhone view:annotationView prefix:prefix];
            }
        }
    }];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"03_map_end"];
        annotationView.bounds = CGRectMake(0, 0, 45, 54);
        [annotationView setAvatar:[UIImage imageWithData:[UserData Instance].avatarData]];
        [annotationView setContentHide:NO];
        [annotationView setContent:[NSString stringWithFormat:@"ME:%@", NSLocalizedString(@"加载中...", nil)]];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [self getlocationInfoWith:geocoder isPhone:YES view:annotationView prefix:@"ME:"];
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static  NSString * annotationIdentifier = @"annotation identifier";
        MKPinAnnotationView * pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            CLGeocoder * geocoder = [[CLGeocoder alloc] init];
            
            if (((MapAnnotation *)annotation).tag) {
                annotationView.image = [UIImage imageNamed:@"03_map_end"];
                annotationView.bounds = CGRectMake(0, 0, 45, 54);
                [annotationView setAvatar:[UIImage imageWithData:[UserData Instance].avatarData]];
                [annotationView setContentHide:NO];
                
                NSString *prefix = @"ME:";
                [annotationView setContent:[NSString stringWithFormat:@"ME:%@", prefix, NSLocalizedString(@"加载中...", nil)]];
                
                [self getlocationInfoWith:geocoder isPhone:YES view:annotationView prefix:prefix];
                
            } else {
                annotationView.image = [UIImage imageNamed:@"03_map_start"];
                annotationView.bounds = CGRectMake(0, 0, 45, 54);
                [annotationView setAvatar:[UIImage imageWithData:self.dev.avatar]];
                
                NSString *prefix = self.dev.positioningType ? @"GSM:":@"GPS:";
                [annotationView setContent:[NSString stringWithFormat:@"%@%@", prefix, NSLocalizedString(@"加载中...", nil)]];
                [self getlocationInfoWith:geocoder isPhone:NO view:annotationView prefix:prefix];
                
                if (self.type==2 && !isRegion) {
                    isRegion = YES;
                    
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.devL.coordinate, 3000, 3000);
                    [_mapView setRegion:region animated:NO];
                    
                    if (self.phoneL) {
                        [_mapView removeOverlays:_mapView.overlays];
                        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[self.phoneL coordinate] radius:self.dev.careDist];
                        [_mapView addOverlay:circle];
                    }
                }
            }
            
            return annotationView;
        }else{
            pinView.annotation = annotation;
            return pinView;
        }
    }
    
    return nil;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (lastAnnotationView) {
        [lastAnnotationView viewWithTag:100].hidden = YES;
    }
    lastAnnotationView = view;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    
    [_mapView removeOverlays:_mapView.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:loc radius:self.dev.careDist];
    [_mapView addOverlay:circle];
    
    [_manager stopUpdatingLocation];
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
        _circleView.fillColor =  [UIColor colorWithRed:137/255.0 green:170/255.0 blue:213/255.0 alpha:0.2];
        _circleView.strokeColor = [UIColor colorWithRed:117/255.0 green:161/255.0 blue:220/255.0 alpha:0.8];
        _circleView.lineWidth=2.0;
        return _circleView;
    }
    return nil;
}

@end