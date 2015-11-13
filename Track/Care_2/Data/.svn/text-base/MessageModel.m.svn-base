//
//  MessageModel.m
//  Q2_local
//
//  Created by Vecklink on 14-7-26.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_content forKey:@"content"];
    [encoder encodeObject:_createDate forKey:@"createDate"];
    [encoder encodeObject:[NSNumber numberWithBool:_isRead] forKey:@"isRead"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _content = [decoder decodeObjectForKey:@"content"];
        _createDate = [decoder decodeObjectForKey:@"createDate"];
        _isRead = [[decoder decodeObjectForKey:@"isRead"] boolValue];
    }
    return  self;
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        _createDate = [NSDate date];
        _isRead = NO;
    }
    return self;
}
@end
