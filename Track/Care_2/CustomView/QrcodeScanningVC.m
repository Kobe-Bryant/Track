//
//  QrcodeScanningVC.m
//  Care_2
//
//  Created by lq on 14-12-3.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "QrcodeScanningVC.h"
#import "DeviceSetting_TableViewController.h"
#import "MD5.h"

@interface QrcodeScanningVC ()<CustomIOS7AlertViewDelegate>

@end

@implementation QrcodeScanningVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = NSLocalizedString(@"扫描二维码或条形码", nil);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"03_around_contact_background"]];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(100, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 70)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines = 0;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text = NSLocalizedString(@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别", nil);
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.1f];
    
    [self setBackButton];
}
_Method_SetBackButton(nil, NO)
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [timer invalidate];
//    }];
    [timer invalidate];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self setupCamera];
//}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
 //   _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    DeviceSetting_TableViewController *devSettingTVC = [[DeviceSetting_TableViewController alloc] initWithNibName:@"DeviceSetting_TableViewController" bundle:nil];
    devSettingTVC.tempUphone = @"123456789";
    devSettingTVC.tempEqphone = @"18574235650";
    devSettingTVC.IMEIID = stringValue;
    devSettingTVC.isAdd=YES;
//    if (![MD5 isPureInt:stringValue withNum:15]) {
//        
//        CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"扫描内容格式不正确！", nil)];
//        [alert show];
//        alert.delegate = self;
//    }else{
        [timer invalidate];
        NSLog(@">>>>>>>>>>>>>>>%@",stringValue);
        [self.navigationController pushViewController:devSettingTVC animated:YES];
  //  }
    
//    [self dismissViewControllerAnimated:YES completion:^
//     {
//         [timer invalidate];
//         NSLog(@">>>>>>>>>>>>>>>%@",stringValue);
//     }];
}


- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView close];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
