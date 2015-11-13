//
//  NetManger.h
//  Care_2
//
//  Created by baoyx on 14/11/18.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TokenSuc)(NSString *token);
typedef void (^UploadFileSuc)(NSString *url);
@interface NetManger : NSObject

-(void)uploadFile:(NSData *)fileData;
-(void)setUploadFileSuc:(UploadFileSuc)suc;
@end
