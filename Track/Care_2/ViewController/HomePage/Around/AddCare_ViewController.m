//
//  AddCare_ViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-24.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AddCare_ViewController.h"
#import "SelectCareDev_TableViewController.h"
#import "GetLocationDuration_TableViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "AnnotationView.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "MD5.h"

@interface AddCare_ViewController ()<CLLocationManagerDelegate,UITextFieldDelegate,UISearchBarDelegate,MKMapViewDelegate,CustomIOS7AlertViewDelegate> {
    
    
    __weak IBOutlet UIButton *openCareBtn;
    __weak IBOutlet UILabel *fenceNameLabel;
    __weak IBOutlet UIImageView *headImage;
    IBOutlet UIView *grayView;
    
    __weak IBOutlet UIButton *selectBtn;
    __weak IBOutlet UISearchBar *_serarchBar;
    __weak IBOutlet MKMapView *fenceMapView;
    __weak IBOutlet UITextField *fenceDistTextField;
    __weak IBOutlet UITextField *selectTextField;
    IBOutlet UIView *fenceView;
    
    __weak IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIView *careView;
    __weak IBOutlet UIImageView *cAvatarImageView;
    __weak IBOutlet UILabel *cDevNameLabel;
    __weak IBOutlet UITextField *distTextField;
    __weak IBOutlet UIView *addCareView;
    __weak IBOutlet UIButton *careBtn;
    __weak IBOutlet UIButton *fenceBtn;
    UIButton *lastBt;
    ASIHTTPRequest *req;
    ASIHTTPRequest *req1;
    UIView *_selectCtnView;
    CLLocationManager * _manager;  // 定位类
    CLLocationCoordinate2D _userCoord; // 定位用户位置的经纬度
    CLLocationCoordinate2D _devCoord; // 定位设备位置的经纬度
    CLLocationCoordinate2D _coord; // 点击位置的经纬度(结构体)
    
    //设置围栏的经、纬度
    double longitude_;    //经度
    double latitude_;     //纬度
    int fenceType_;       //1，进入报警；2，离开报警
    int type_;            //1、关爱  2、围栏
    
    UIButton *saveBtn;
    UIButton *conditionBtn; //进入预警，离开预警 Btn
    NSMutableArray *_annotations; //大头针数组
    NSMutableArray *overlayArr;   //圈圈数组
    BOOL cail;
    
    BOOL isRepeat_;   
}
- (IBAction)onCareButtonPressed:(UIButton *)sender;
- (IBAction)onFenceButtonPressed:(UIButton *)sender;
- (IBAction)onOpenCareButtonPressed:(UIButton *)sender;
@end

@implementation AddCare_ViewController

-(void)setOnOpenCareButtonPressed:(void (^)(DeviceModel *))_onOpenCareButtonPressed {
    onOpenCareButtonPressed = _onOpenCareButtonPressed;
}

-(void)dealloc {
    [req clearDelegatesAndCancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sing_ind"object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    NSLog(@"bindIMEI    =%@",self.dev.bindIMEI);
    _annotations = [NSMutableArray array];
    overlayArr = [NSMutableArray array];
    self.title = NSLocalizedString(@"选择身边的对象", nil);
    fenceType_=1;   //设置围栏默认报警方式
    type_=1;        //设置默认类型为关爱
    [self setBackButton];
    
    contentScrollView.contentSize = CGSizeMake(320*2, contentScrollView.bounds.size.height);
    lastBt = (UIButton *)[self.view viewWithTag:100];
    fenceView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 453);
    [contentScrollView addSubview:careView];
    [contentScrollView addSubview:fenceView];
    cAvatarImageView.layer.cornerRadius = cAvatarImageView.bounds.size.height/2;
    cAvatarImageView.layer.masksToBounds = YES;
    cAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    cAvatarImageView.layer.borderWidth = 2;
    
    headImage.layer.cornerRadius = cAvatarImageView.bounds.size.height/2;
    headImage.layer.masksToBounds = YES;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.layer.borderWidth = 2;
    
    _serarchBar.backgroundColor = [UIColor colorWithRed:145 green:119 blue:78 alpha:0.1];
    
    distTextField.delegate = self;
    fenceDistTextField.delegate = self;
    _serarchBar.delegate = self;
    fenceMapView.delegate = self;
    
    if (_isCareDev) {
        //  [self setSubmitButton];
        addCareView.frame = CGRectMake(0, 125, 320, 91);
        openCareBtn.userInteractionEnabled = NO;
        distTextField.text = [NSString stringWithFormat:@"%d", self.dev.careDist];
    } else {
        addCareView.frame = CGRectMake(0, 186, 320, 91);
        openCareBtn.userInteractionEnabled = YES;
        distTextField.text = @"100";
    }
    cAvatarImageView.image = [UIImage imageWithData:self.dev.avatar];
    cDevNameLabel.text = self.dev.nickName;
    fenceNameLabel.text = self.dev.nickName;
    headImage.image = [UIImage imageWithData:self.dev.avatar];
    
#pragma mark - 弹出预警条件视图
    _selectCtnView = [[UIView alloc] initWithFrame:CGRectMake(selectTextField.frame.origin.x,selectBtn.frame.origin.y+selectBtn.frame.size.height,selectBtn.frame.size.width,30)];
    _selectCtnView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"03_around_contact_background"]];
    _selectCtnView.hidden = YES;
    [fenceView addSubview:_selectCtnView];
    
    
    conditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    conditionBtn.frame = CGRectMake(0, 0, _selectCtnView.frame.size.width, 30);
    [conditionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [conditionBtn setBackgroundImage:[UIImage imageNamed:@"03_changeDevice_selected"] forState:UIControlStateNormal];
    [conditionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCtnView addSubview:conditionBtn];
    
   // 定位到设备位置
    // 注册通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDevLocation) name:@"sing_ind" object:nil];
   

 //    [self setupLocationManager]; //  定位
    
    // 判断如果已经存在围栏
    if (_fenceDevArr) {
        cail = NO;
        for(DeviceModel *fencedev in _fenceDevArr)
        {
            CLLocationCoordinate2D fenceCoord = CLLocationCoordinate2DMake(fencedev.lat, fencedev.lng);
            fenceMapView.delegate = self;
            //  [fenceMapView removeOverlays:fenceMapView.overlays];
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:fenceCoord radius:fencedev.fenceDist];
            
            [fenceMapView addOverlay:circle];
            NSLog(@"---%f______%f",fencedev.lat, fencedev.lng);
           
        }
    }
    NSLog(@">>>>>>>%@",_fenceDevArr);
    
    
    //监听键盘状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //添加长按手势
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [fenceMapView addGestureRecognizer:longPress];

}


//根据键盘的大小动态调整输入框坐标
- (void)keyboardWillShow:(NSNotification *)notification{
    CGSize size = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%lf",size.height);
    [UIView animateWithDuration:0.3 animations:^{
        _serarchBar.frame = CGRectMake(11,453-size.height-44, 298, 44);
    }];
    NSLog(@"%f",_serarchBar.frame.origin.y);
}


- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        _serarchBar.frame = CGRectMake(11, 409, 298, 44);
    }];
}


_Method_SetBackButton(nil, NO);
//_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(onSubmitButtonPressed)), _StringWidth(NSLocalizedString(@"保存", nil)))

-(void)getDevLocation
{
    
    _devCoord.longitude = _dev.lo;
    _devCoord.latitude = _dev.la;
    NSLog(@"-----设备的经度=%f,纬度=%f",_dev.lo,_dev.la);
    MKCoordinateSpan span;
    span.longitudeDelta = 0.005;
    span.latitudeDelta = 0.005;
    [fenceMapView setRegion:MKCoordinateRegionMake(_devCoord, span)];
    MapAnnotation * annotation = [[MapAnnotation alloc] initWithTitle:nil Coordinate2D:_devCoord];
    annotation.tag = 10;
    [fenceMapView addAnnotation:annotation];
}


#pragma mark - 定位
- (void) setupLocationManager {
    
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"亲，您还没将定位功能打开哟，赶紧打开吧！", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alert show];

    }
}

-(void)onSubmitButtonPressed {
    if (distTextField.text.integerValue<100) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入大于100的关爱距离", nil)];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            distTextField.text = @"100";
        }];
        [alertView show];
        return;
    }
    
//    self.dev.careDist = distTextField.text.integerValue;
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存成功", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}
- (IBAction)beginEdit:(UITextField *)sender {
    grayView.frame = CGRectMake(0, 0, 320, 368);
    [self.view addSubview:grayView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [grayView removeFromSuperview];    
    [fenceDistTextField resignFirstResponder];
    [distTextField resignFirstResponder];
}


#pragma mark - SearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_serarchBar resignFirstResponder];
    
    __block MKCoordinateRegion region;
    NSString *oreillyAddress = _serarchBar.text;;  //测试使用中文也可以找到经纬度具体的可以多尝试看看~
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil)
        {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            MKCoordinateSpan spans;
            spans.latitudeDelta = 0.0005;
            spans.longitudeDelta = 0.0005;
            CLLocationCoordinate2D coord;
            coord.latitude = firstPlacemark.location.coordinate.latitude;
            coord.longitude = firstPlacemark.location.coordinate.longitude;
            region.span = spans;
            region.center = coord;
            [fenceMapView setRegion:region animated:YES];
        }
        else if ([placemarks count] == 0 && error == nil)
        {
            CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"抱歉，未找到结果!", nil)];
            [alert show];
        }
        else if (error != nil)
        {
            CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"抱歉，未找到结果!", nil)];
            [alert show];
        }
    }];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_serarchBar resignFirstResponder];
}

-(void)hideTextField {
    [distTextField resignFirstResponder];
}

- (IBAction)onCareButtonPressed:(UIButton *)bt {
    lastBt.selected = NO;
    lastBt = bt;
    lastBt.selected = YES;
    fenceBtn.selected = NO;
    saveBtn.hidden = YES;
    [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)onFenceButtonPressed:(UIButton *)bt {
    careBtn.selected = NO;
    fenceBtn.selected = YES;
    [self saveBtn];
    if (_fenceNum ==3) {
        saveBtn.hidden = YES;
    }else
    {
        saveBtn.hidden = NO;
    }
    [contentScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    
}
-(void)saveBtn{
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 2, 45, 44);
    [saveBtn setImage:[UIImage imageNamed:@"01_btn_nav"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"01_btn_nav_selected"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:138.0/255 green:90.0/255 blue:51.0/255 alpha:1.0] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnPressd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    saveBtn.imageEdgeInsets = (UIEdgeInsets){0,20,0,-20};
    saveBtn.titleEdgeInsets = (UIEdgeInsets){0,-65,0,-20};
    
}

-(void)saveBtnPressd{
    CLLocationCoordinate2D fenceCoord1;
    CLLocationDistance distance;
    int dist;
  
    //计算距离
    if (_fenceDevArr) {
      
        for(DeviceModel *model in _fenceDevArr)
        {
            fenceCoord1 = CLLocationCoordinate2DMake(model.lat, model.lng);
            CLLocation *oldLoc1 = [[CLLocation alloc]initWithLatitude:fenceCoord1.latitude longitude:fenceCoord1.longitude];
            CLLocation *clickLoc = [[CLLocation alloc]initWithLatitude:_coord.latitude longitude:_coord.longitude];

            distance = [clickLoc distanceFromLocation:oldLoc1];
            NSLog(@"distance = %f",distance);
            dist = model.fenceDist;
            NSLog(@">>>%d",dist + [fenceDistTextField.text intValue]);
            if (distance < (dist + [fenceDistTextField.text intValue]) )
            {
                NSLog(@"isRepeat_");
                isRepeat_=YES;
                continue;
            }
            
        }
    }
    
    //   CLLocationDistance distance = [ distanceFromLocation _coord];
    if ([fenceDistTextField.text intValue]<200 || [fenceDistTextField.text intValue]>5000) {
        CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"请输入大于200米且小于5000米的关爱距离",nil)];
        [alert show];
        return;
    }else if (!_coord.latitude)
    {
    
        CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"围栏区域还未设置", nil)];
        [alert show];
        return;

    }
    else if(isRepeat_ == YES)
    {
         isRepeat_= NO;
        CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"围栏范围重复", nil)];
        [alert show];
        return;
    }
   
//    NSLog(@"isRepeat = %@",isRepeat_);
    [self addfence];
    NSLog(@"saveBtn");
    CustomIOS7AlertView *aler = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"保存成功", nil)];
    [aler show];
    aler.delegate = self;
    
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView close];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)longPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan){
    
        [fenceMapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
        [fenceMapView removeOverlays:overlayArr];
        [overlayArr removeLastObject];

        // 获取用户手势作用点的坐标
        CGPoint point = [sender locationInView:fenceMapView];
        // 将UIVIEW坐标转化为经纬度
        _coord = [fenceMapView convertPoint:point toCoordinateFromView:fenceMapView];
        longitude_=_coord.longitude;
        latitude_=_coord.latitude;
    
        cail = YES;
        //    fenceMapView.delegate = self;
        // [fenceMapView removeOverlays:fenceMapView.overlays];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:_coord radius:[fenceDistTextField.text intValue]];
        [fenceMapView addOverlay:circle];
        [overlayArr addObject:circle];

        NSLog(@"经度＝%lf，纬度＝ %lf",_coord.longitude,_coord.latitude);
    
        // 动态 添加大头针到指定位置
        MapAnnotation * annotation = [[MapAnnotation alloc] initWithTitle:nil Coordinate2D:_coord];
        [fenceMapView addAnnotation:annotation];
        [_annotations addObject:annotation];
    }
}

- (IBAction)selectCondition:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            _selectCtnView.hidden = NO;
            [fenceView bringSubviewToFront:_selectCtnView];
            if ([selectTextField.text isEqualToString:@"Into warning"]) {
                [conditionBtn setTitle:@"Off warning" forState:UIControlStateNormal];
            }else if([selectTextField.text isEqualToString:@"Off warning"]) {
                [conditionBtn setTitle:@"Into warning" forState:UIControlStateNormal];
            }
            else if ([selectTextField.text isEqualToString:@"进入预警"]) {
                [conditionBtn setTitle:@"离开预警" forState:UIControlStateNormal];
            }
            else if ([selectTextField.text isEqualToString:@"离开预警"]){
                [conditionBtn setTitle:@"进入预警" forState:UIControlStateNormal];
            }
        }];
    }else{
        _selectCtnView.hidden = YES;
    }
    
}


- (IBAction)onOpenCareButtonPressed:(UIButton *)sender {
    if (distTextField.text.integerValue<100) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入大于100的关爱距离", nil)];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            distTextField.text = @"100";
        }];
        [alertView show];
        return;
    }
    //添加关爱设备
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_care forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    [signInfo setValue:distTextField.text forKey:@"dist"];
    [signInfo setValue:[NSNumber numberWithInteger:self.dev.careInterval] forKey:@"interval"];
    [signInfo setValue:self.dev.bindIMEI forKey:@"eqid"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
    CustomIOS7AlertView *aler = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"开启关爱成功", nil)];
    [aler show];
    aler.delegate = self;
}

//
//- (IBAction)onSetIntervalButtonPressed:(UIButton *)sender {
//    GetLocationDuration_TableViewController *getLocationDurationTVC = [[GetLocationDuration_TableViewController alloc] initWithNibName:@"GetLocationDuration_TableViewController" bundle:nil];
//    getLocationDurationTVC.obj = self.dev;
//    [self.navigationController pushViewController:getLocationDurationTVC animated:YES];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) {
        return YES;
    }
    if (([textField.text length] + [string length] - range.length) > 4) {
        return NO;
    }
    return YES;
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        if (onOpenCareButtonPressed != NULL) {
            //线上添加关爱成功
            onOpenCareButtonPressed(self.dev);
            self.dev.careDist = distTextField.text.integerValue;
            NSLog(@"--%d",self.dev.careDist);
            [self.navigationController popViewControllerAnimated:YES];
        }
    })
}
_Method_RequestFailed()

#pragma mark - CLLocationManagerDelegate 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 定位成功回调
    NSLog(@"定位成功 %@",locations);
    CLLocation * location = locations[0];
    NSLog(@"定位成功 返回用户当前位置的经纬度 %f %f",location.coordinate.latitude,location.coordinate.longitude);
    // 拿到定位位置的经纬度(结构体)
    _userCoord = location.coordinate;
    
    MKCoordinateSpan span;
    span.longitudeDelta = 0.005;
    span.latitudeDelta = 0.005;
     // 地图前往定位处
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coodinate2D, 3000, 3000);
//    [fenceMapView setRegion:region animated:YES];
    [fenceMapView setRegion:MKCoordinateRegionMake(_userCoord,span) animated:YES];
    // 停止位置更新
    [_manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // 定位失败回调
    NSLog(@"error is %@",error);
}

- (void)btnClick:(UIButton *)btn  // 条件选择按钮
{
    if ([btn.titleLabel.text isEqualToString:@"进入预警"] || [btn.titleLabel.text isEqualToString:@"Enter the warning"]) {
        fenceType_ = 1;
    }else{
        fenceType_ = 2;
    }
    NSLog(@"fenceType_ = %d",fenceType_);
    selectTextField.text = btn.titleLabel.text;
    _selectCtnView.hidden = YES;
    selectBtn.selected = NO;
}


#pragma mark－添加围栏
-(void)addfence
{
    NSLog(@"bindIMEI=%@",self.dev.bindIMEI);
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_addfence forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    [signInfo setValue:[NSNumber numberWithInteger:[fenceDistTextField.text integerValue]] forKey:@"dist"];
    [signInfo setValue:[NSNumber numberWithDouble:latitude_] forKey:@"lat"];
    [signInfo setValue:[NSNumber numberWithDouble:longitude_] forKey:@"lnt"];
    [signInfo setValue:self.dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:[NSNumber numberWithInt:fenceType_] forKey:@"type"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    NSLog(@"urlStr=%@",urlStr);
    
    req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req1.delegate = self;
    [req1 startAsynchronous];
    _Code_ShowLoading
}



#pragma mark - MKMapViewDelegate 地图类代理
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MKAnnotationView * view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    if (view == nil){
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyAnnotation"];
        view.centerOffset = CGPointMake(0, -14);
    }

    
    // 根据经纬度 编码为 改点的详细信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        [view setContentHide:YES];
         view.canShowCallout = NO;
        CLLocation * location = [[CLLocation alloc] initWithLatitude:_userCoord.latitude longitude:_userCoord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
            // 详细位置信息类（国家 省 市 自治区 街道 邮政编码...）
            CLPlacemark * placeMark = placemarks[0];
            [view setContent:placeMark.name];
        
        }];
        
        return view;
    }
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        
        
        view.image = [UIImage imageNamed:@"03_map_start"];
        UIImageView *icon = [[UIImageView alloc] initWithFrame: CGRectMake(6, 5, view.frame.size.width-12, view.frame.size.height-18)];
      
        if (cail == NO) {
            icon.image = [UIImage imageWithData:_dev.avatar];
            CLLocation * location = [[CLLocation alloc] initWithLatitude:_devCoord.latitude longitude:_devCoord.longitude];
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
                // 详细位置信息类（国家 省 市 自治区 街道 邮政编码...）
                CLPlacemark * placeMark = placemarks[0];
                [view setContent:placeMark.name];
            }];

        }else{
             icon.image = [UIImage imageNamed:@"3_avatar_pet_88"];
            CLLocation * location = [[CLLocation alloc] initWithLatitude:_coord.latitude longitude:_coord.longitude];
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
                CLPlacemark * placeMark = placemarks[0];
                [view setContent:placeMark.name];
            }];

        }
            [view addSubview:icon];
    }
  
    return view;
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{

    MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
    if (cail) {
        _circleView.fillColor =  [UIColor colorWithRed:96/255.0 green:188/255.0 blue:75/255.0 alpha:0.1];
        _circleView.strokeColor = [UIColor colorWithRed:96/255.0 green:180/255.0 blue:75/255.0 alpha:0.8];
        _circleView.lineWidth=2.0;
    }else{
        _circleView.fillColor =  [UIColor colorWithRed:255/255.0 green:108/255.0 blue:9/255.0 alpha:0.1];
        _circleView.strokeColor = [UIColor colorWithRed:255/255.0 green:110/255.0 blue:9/255.0 alpha:0.8];
        _circleView.lineWidth=2.0;
    }
    return _circleView;
}

@end
