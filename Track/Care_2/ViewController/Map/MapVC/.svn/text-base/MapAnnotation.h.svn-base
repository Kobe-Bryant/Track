//
//  MapAnnotation.h
//  Q2_local
//
//  Created by HelloWorld on 14-7-16.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D _coordinate2D;
}
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title Coordinate2D:(CLLocationCoordinate2D)tempCoordinate2D;
@end


@interface MKAnnotationView (Bubble)
-(void)setAvatar:(UIImage *)avatar;
-(void)setContent:(NSString *)content;
-(void)setContentHide:(BOOL)hide;

@end
