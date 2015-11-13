//
//  DeviceModel.m
//  Q2_local
//
//  Created by Vecklink on 14-7-15.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_nickName forKey:@"nickName"];
    [encoder encodeObject:_avatar forKey:@"avatar"];
   // [encoder encodeObject:_avatarUrl forKey:@"avatarUrl"];
    [encoder encodeObject:[NSNumber numberWithInt:_electricity] forKey:@"electricity"];
    [encoder encodeObject:[NSNumber numberWithInteger:_careInterval] forKey:@"careInterval"];
    [encoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:_bindIMEI forKey:@"bindIMEI"];
    [encoder encodeObject:_musicItem forKey:@"musicItem"];
    
    [encoder encodeObject:[NSNumber numberWithDouble:_la] forKey:@"la"];
    [encoder encodeObject:[NSNumber numberWithDouble:_lo] forKey:@"lo"];
    [encoder encodeObject:@(_positioningType) forKey:@"positioningType"];
    
    [encoder encodeObject:_remoteCare forKey:@"remoteCare"];
    [encoder encodeObject:_messageArr forKey:@"messageArr"];
    
    [encoder encodeObject:@(_online) forKey:@"online"];
    //Care
    [encoder encodeObject:[NSNumber numberWithInteger:_careDist] forKey:@"careDist"];
    [encoder encodeObject:_nowDist forKey:@"nowDist"];
    [encoder encodeObject:[NSNumber numberWithInt:_careType] forKey:@"careType"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _nickName = [decoder decodeObjectForKey:@"nickName"];
        _avatar = [decoder decodeObjectForKey:@"avatar"];
       // _avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        _electricity = [[decoder decodeObjectForKey:@"electricity"] intValue];
        _careInterval = [[decoder decodeObjectForKey:@"careInterval"] integerValue];
        _phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        _bindIMEI = [decoder decodeObjectForKey:@"bindIMEI"];
        _musicItem = [decoder decodeObjectForKey:@"musicItem"];
        if (_musicItem) {
            if ([_musicItem isKindOfClass:[NSDictionary class]]) {
                NSString *mp3Title = ((NSDictionary *)_musicItem)[@"title"];
                NSString *mp3Path = [[NSBundle mainBundle] pathForResource:mp3Title ofType:@"mp3"];
                _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:mp3Title, @"title", mp3Path, @"mp3Path", nil];
            }
        } else {
            NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"];
            _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:@"music1", @"title", mp3Path, @"mp3Path", nil];
        }
        
        _la = [[decoder decodeObjectForKey:@"la"] doubleValue];
        _lo = [[decoder decodeObjectForKey:@"lo"] doubleValue];
        _positioningType = [[decoder decodeObjectForKey:@"positioningType"] boolValue];
        
        _remoteCare = [decoder decodeObjectForKey:@"remoteCare"];
        _messageArr = [decoder decodeObjectForKey:@"messageArr"];
        
        _online = [[decoder decodeObjectForKey:@"online"] boolValue];
        
        //Care
        _careDist = [[decoder decodeObjectForKey:@"careDist"] intValue];
        _nowDist = [decoder decodeObjectForKey:@"nowDist"];
        _careType = [[decoder decodeObjectForKey:@"careType"] intValue];
        
        if (![[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
//        [_messageArr removeAllObjects];
        if (!_messageArr.count) {
//            for (int i=0; i<5; i++) {
                MessageModel *msg = [[MessageModel alloc] initWithContent:@"欢迎使用关爱APP，时刻关爱您的宠物"];
                [_messageArr addObject:msg];
//            }
        }
    }
    return  self;
}

-(instancetype)initWithName:(NSString *)name phone:(NSString *)phone imei:(NSString *)imei withUrl:(NSString *)url{
    self = [super init];
    if (self) {
        
        //默认设置
        _nickName = name;
        _phoneNumber = phone;
        
        _bindIMEI = imei;
        
        NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"];
        _musicItem = [NSDictionary dictionaryWithObjectsAndKeys:@"music1", @"title", mp3Path, @"mp3Path", nil];
        if([NSData dataWithContentsOfURL:[NSURL URLWithString:url]])
        {
            _avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        } else {
            _avatar=UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_pet_88"]);
        }
        
        _avatarUrl=url;
        
        _online = NO;      //在线状态
        
        _electricity = 0;   //电量
        _careInterval = 15; //关爱间隔
        _careDist = 100;    //关爱距离
        
        _la = -1;
        _lo = -1;
        
        _remoteCare = [NSMutableArray array];
        _messageArr = [NSMutableArray array];
        MessageModel *msg = [[MessageModel alloc] initWithContent:@"欢迎使用关爱APP，时刻关爱您的宠物"];
        [_messageArr addObject:msg];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@-nowDist", _bindIMEI]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

-(void)setCareWithCareDist:(NSInteger)careDist type:(int)type {
    _careDist = (int)careDist;
    _careType = type;
}

-(void)addRemoteCare:(NSString *)str date:(NSDate *)date {
    [_remoteCare addObject:[NSDictionary dictionaryWithObjectsAndKeys:str, @"location", date, @"date", nil]];
}
-(void)addMessage:(NSString *)str date:(NSDate *)date {
    
}

@end
