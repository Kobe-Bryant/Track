//
//  LookFenceMap_ViewController.m
//  Care_2
//
//  Created by adear on 14/11/10.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "LookFenceMap_ViewController.h"
#import "AnnotationView.h"
#import "MapAnnotation.h"

@interface LookFenceMap_ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    __weak IBOutlet MKMapView *fenceMapView;
    CLLocationManager * _manager;  // 定位类
    CLLocationCoordinate2D deviceCoord;
    CLLocationCoordinate2D fenceCoord;
    CLLocation *deviceLoc;
    CLLocation *fenceLoc;
    BOOL warning;// 报警状态
    
}

@end

@implementation LookFenceMap_ViewController


- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"围栏", nil);
    warning = NO;
    [self setBackButton];
    fenceMapView.delegate = self;
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(0, 2, 45, 44);
    [headBtn setImage:[UIImage imageWithData:self.device.avatar] forState:UIControlStateNormal];
    headBtn.imageEdgeInsets = (UIEdgeInsets){0,20,0,-20};
    headBtn.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:headBtn];

    //定位到围栏的位置
    fenceCoord.longitude = self.device.lng;
    fenceCoord.latitude = self.device.lat;
    NSLog(@">>>>>%f,%f",self.device.lng,self.device.lat);
    
    MKCoordinateSpan span;
    span.longitudeDelta = 0.005;
    span.latitudeDelta = 0.005;
    fenceCoord = CLLocationCoordinate2DMake(self.device.lat,self.device.lng);
    [fenceMapView setRegion:MKCoordinateRegionMake(fenceCoord, span)];
    fenceMapView.delegate = self;
    // 画围栏圈
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:fenceCoord radius:self.device.fenceDist];
    [fenceMapView addOverlay:circle];

    
    
    // 注册通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDevice) name:@"sing_ind" object:nil];
     NSLog(@"注册");
   // [self setupLocationManager];
    

}

// 定位到设备的位置
- (IBAction)locationDevClick:(UIButton *)sender {
    
    
    [fenceMapView setCenterCoordinate:deviceCoord animated:YES];
    NSLog(@">>>>>>%f>>>%f",deviceCoord.latitude,deviceCoord.longitude);
    MapAnnotation * annotation = [[MapAnnotation alloc] initWithTitle:nil Coordinate2D:deviceCoord];
    [fenceMapView addAnnotation:annotation];
}

-(void)getDevice // 获取设备位置
{
    NSLog(@"获取设备位置");
    DeviceModel *dev=[UserData Instance].deviceDic[_device.bindIMEI];
    NSLog(@"%f %f",dev.lo,dev.la);
    deviceCoord = CLLocationCoordinate2DMake(dev.la,dev.lo);
    NSLog(@"-------%f%f",dev.la,dev.lo);

    deviceCoord.longitude = dev.lo;
    deviceCoord.latitude = dev.la;
    //    MKCoordinateSpan span;
    //    span.longitudeDelta = 0.005;
    //    span.latitudeDelta = 0.005;
    //    [fenceMapView setRegion:MKCoordinateRegionMake(deviceCoord, span)];

}


#pragma mark - 定位
- (void)setupLocationManager
{
    //  允许访问用户当前的位置
    fenceMapView.showsUserLocation = YES;
    // 创建一个定位的对象
    _manager = [[CLLocationManager alloc] init];
    // 判断的手机的定位功能是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        
        // 通过代理的形式返回用户当前的经纬度
        _manager.delegate = self;
        // 定位距离(有三种)
        _manager.distanceFilter = kCLLocationAccuracyHundredMeters;
        // 定位效果
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 启动位置更新
        [_manager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil   message:NSLocalizedString(@"亲，您还没将定位功能打开哟，赶紧打开吧！", nil)
        delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - CLLocationManagerDelegate 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 定位成功回调
    NSLog(@"定位成功 %@",locations);
    CLLocation * location = locations[0];
    NSLog(@"定位成功 返回用户当前位置的经纬度 %f %f",location.coordinate.latitude,location.coordinate.longitude);
    // 拿到定位位置的经纬度(结构体)
    CLLocationCoordinate2D coodinate2D = location.coordinate;
    // 地图前往定位处
    [fenceMapView setRegion:MKCoordinateRegionMake(coodinate2D, fenceMapView.region.span) animated:YES];
    // 停止位置更新
    [_manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // 定位失败回调
    NSLog(@"error is %@",error);
}


#pragma mark - MKMapViewDelegate 地图类代理
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    if (view == nil){
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyAnnotation"];
    }
    
    // MKAnnotationView 专有的 可以定制大头针
    NSLog(@"*****_fenceType = %d,_FenceDist = %d",_device.fenceType,_device.fenceDist);
    NSLog(@"距离是%ld",(long)[self makeDistance]);
    
    
    // 根据经纬度 编码为 改点的详细信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:fenceCoord.latitude longitude:fenceCoord.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        // 详细位置信息类（国家 省 市 自治区 街道 邮政编码...）
        CLPlacemark * placeMark = placemarks[0];
        NSLog(@">>>%@ %@ %@ %@ %@ %@",placeMark.name,placeMark.locality,placeMark.country,placeMark.thoroughfare,placeMark.ISOcountryCode,placeMark.ocean);
    
    switch (_device.fenceType) {
        case 1:
        {
            if ([self makeDistance] <= _device.fenceDist) {
                warning = YES;
                view.image = [UIImage imageNamed:@"03_map_end"];
                [view setContent:[NSString stringWithFormat:@"%@%@%d%@%@",placeMark.thoroughfare,NSLocalizedString(@"为中心，半径", nil),_device.fenceDist,NSLocalizedString(@"米", nil),NSLocalizedString(@"进入预警", nil)]];

            }else{
                warning = NO;
                view.image = [UIImage imageNamed:@"03_map_start"];
                [view setContent:placeMark.name];
            }
        }
            break;
        case 2:
        {
            if ([self makeDistance] >= _device.fenceDist) {
                warning = YES;
                view.image = [UIImage imageNamed:@"03_map_end"];
                [view setContent:[NSString stringWithFormat:@"%@%@%d%@%@",placeMark.thoroughfare,NSLocalizedString(@"为中心，半径", nil),_device.fenceDist,NSLocalizedString(@"米", nil),NSLocalizedString(@"离开预警", nil)]];
            }else{
                warning = NO;
                view.image = [UIImage imageNamed:@"03_map_start"];
                [view setContent:placeMark.name];
                NSLog(@"warning is %d",warning);
            }
        }
            break;
    }
    NSLog(@"fenceType=%d",_device.fenceType);
    NSLog(@"====%@",view.image);
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_device.avatar]];
    icon.frame = CGRectMake(6, 5, view.frame.size.width-12, view.frame.size.height-18);
    [view addSubview:icon];
        
    }];
    
    return view;
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
        
        switch (_device.fenceType) {
            case 1:
            {
                if ([self makeDistance] <= _device.fenceDist) {
                    
                    _circleView.fillColor =  [UIColor colorWithRed:255/255.0 green:108/255.0 blue:9/255.0 alpha:0.1];
                    _circleView.strokeColor = [UIColor colorWithRed:255/255.0 green:110/255.0 blue:9/255.0 alpha:0.8];
                    _circleView.lineWidth=2.0;
                    
                }else{
                    _circleView.fillColor =  [UIColor colorWithRed:96/255.0 green:188/255.0 blue:75/255.0 alpha:0.1];
                    _circleView.strokeColor = [UIColor colorWithRed:96/255.0 green:180/255.0 blue:75/255.0 alpha:0.8];
                    _circleView.lineWidth=2.0;
                    
                     }
            }
                break;
            case 2:
            {
                if ([self makeDistance] >= _device.fenceDist)
                {
                    _circleView.fillColor =  [UIColor colorWithRed:255/255.0 green:108/255.0 blue:9/255.0 alpha:0.1];
                    _circleView.strokeColor = [UIColor colorWithRed:255/255.0 green:110/255.0 blue:9/255.0 alpha:0.8];
                    _circleView.lineWidth=2.0;
                }else{
                    _circleView.fillColor =  [UIColor colorWithRed:96/255.0 green:188/255.0 blue:75/255.0 alpha:0.1];
                    _circleView.strokeColor = [UIColor colorWithRed:96/255.0 green:180/255.0 blue:75/255.0 alpha:0.8];
                    _circleView.lineWidth=2.0;
                    }
            }
                break;
        }
        return _circleView;
    }
    return nil;
}

// 计算距离
-(NSInteger)makeDistance{
    
    DeviceModel *dev=[UserData Instance].deviceDic[_device.bindIMEI];
    deviceLoc = [[CLLocation alloc]initWithLatitude:dev.la longitude:dev.lo];
    
    fenceLoc = [[CLLocation alloc]initWithLatitude:fenceCoord.latitude longitude:fenceCoord.longitude];
    
    return [deviceLoc distanceFromLocation:fenceLoc];
}
_Method_SetBackButton(nil, NO)


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sing_ind"object:nil];

}

@end
