//
//  HomePageWeather_View.m
//  Q2_local
//
//  Created by Vecklink on 14-7-19.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "HomePage_WeatherView.h"

#define _API_Weather @"http://forecast.sina.cn/app/update.php?device=iPad&uid=7eb58143ba6221dbe9b3d557b9588875ff7048c5&os=ios7.1.1&pver=2.010&pt=4&token=ff00fb202705779e40c65b08a685da1654c64f090405731e14c2&pid=free"
@interface HomePage_WeatherView() {
    
    __weak IBOutlet UIImageView *backgroundImageView;
    
    __weak IBOutlet UILabel *airTemperatureLabel;
    __weak IBOutlet UILabel *cityLabel;
    __weak IBOutlet UILabel *windLabel;
    __weak IBOutlet UILabel *rainLabel;
    __weak IBOutlet UIImageView *rainImageView;
    
    UIView *shadowView;
    
    BOOL isHide;
    
    NSDictionary *imgNameDic;
    
    ASIHTTPRequest *req;
}

@end

@implementation HomePage_WeatherView

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
-(void)awakeFromNib {
    self.clipsToBounds = YES;
    
    [self setWeatherHide:YES];
    return;
    
    if (!shadowView) {
        shadowView = [[UIView alloc] initWithFrame:backgroundImageView.bounds];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(235, -100, 85, 1000);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor clearColor].CGColor,
                           (id)[UIColor blackColor].CGColor,
                           nil];
        [shadowView.layer insertSublayer:gradient atIndex:0];
        shadowView.layer.masksToBounds = YES;
        
        [backgroundImageView addSubview:shadowView];
    }
    [self refreshWeatherView];
}

-(void)refreshWeatherView {
    return;
    
    //获取天气
    [self sendGetWeatherHTTPRequest];
}

-(void)setWeatherHide:(BOOL)hide {
    if (isHide != hide) {
        isHide = hide;
        airTemperatureLabel.hidden = hide;
        cityLabel.hidden = hide;
        windLabel.hidden = hide;
        rainLabel.hidden = hide;
        rainImageView.hidden = hide;
        shadowView.hidden = hide;
    }
}

-(void)sendGetWeatherHTTPRequest {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&city=%@", _API_Weather, @"CHXX0120"];
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding error:nil];
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    NSString *isValid = [[rootElement attributeForName:@"valid"] stringValue];
    if ([isValid isEqualToString:@"no"]) {
        [self setWeatherHide:YES];
        return;
    } else {
        [self setWeatherHide:NO];
    }
    
    cityLabel.text = [[rootElement attributeForName:@"location"] stringValue];
    
    GDataXMLElement *condition = [rootElement elementsForName:@"condition"][0];
    airTemperatureLabel.text = [[condition attributeForName:@"ycode"] stringValue];
    windLabel.text = [[condition attributeForName:@"wind"] stringValue];
    
    GDataXMLElement *forecasts = [rootElement elementsForName:@"forecasts"][0];
    GDataXMLElement *foreca = [forecasts elementsForName:@"foreca"][0];
    rainLabel.text = [[foreca attributeForName:@"text"] stringValue];
    
    NSString *imgCode = [[foreca attributeForName:@"code"] stringValue];
    if (!imgNameDic) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"plist"];
        imgNameDic = ((NSArray *)[[NSArray alloc] initWithContentsOfFile:plistPath])[0];
    }
    
    if (imgCode.intValue==0 || imgCode.intValue==1) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH"];
        int hour = [df stringFromDate:[NSDate date]].intValue;
        if (hour<5 && hour>19 ) {
            imgCode = [NSString stringWithFormat:@"%d", imgCode.intValue + 100];
        }
    }
    rainImageView.image = (imgNameDic[imgCode] ? [UIImage imageNamed:imgNameDic[imgCode]] :
                                                [UIImage imageNamed:@"weizhi"]);
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    NSLog(@"HttpRequest Error > ________%@\n\n______________url=%@\n\n______________%@\n", self, [request url] , [request error]);
    [self setWeatherHide:YES];
}

@end
