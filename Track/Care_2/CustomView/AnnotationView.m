//
//  AnnotationView.m
//  Care_2
//
//  Created by adear on 14/11/8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"03_map_start"]];
        _imageView.frame = CGRectMake(-15, -30, 32, 32);
        [self addSubview:_imageView];
    }
    return self;
}

@end
