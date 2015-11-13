//
//  InsetsTextField.m
//  iWalk
//
//  Created by Jason on 14-1-6.
//  Copyright (c) 2014年 Jason. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.tag > 100) {
        return CGRectMake(35, 0, bounds.size.width-50, bounds.size.height);
    }
    return CGRectMake(10, 0, bounds.size.width-25, bounds.size.height);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.tag > 100) {
        return CGRectMake(35, 0, bounds.size.width-50, bounds.size.height);
    }
    return CGRectMake(10, 0, bounds.size.width-25, bounds.size.height);
}

@end
