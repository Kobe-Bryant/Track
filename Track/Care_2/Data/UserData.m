//
//  UserData.m
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "UserData.h"

@implementation UserData

static UserData *_instance = nil;

+(UserData *)Instance
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[UserData alloc] init];
        }
        return _instance;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_child_88"]);
        _deviceDic = [NSMutableDictionary dictionary];
        _avatarUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatarUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_uid forKey:@"uid"];
    [encoder encodeObject:_sessionId forKey:@"sessionId"];
    [encoder encodeObject:_account forKey:@"account"];
    [encoder encodeObject:_nickName forKey:@"nickName"];
    [encoder encodeObject:_avatarData forKey:@"avatarData"];
    [encoder encodeObject:[NSNumber numberWithInt:_sex] forKey:@"sex"];
    [encoder encodeObject:_deviceDic forKey:@"deviceDic"];
    [encoder encodeObject:_likeDevIMEI forKey:@"likeDevIMEI"];
    [encoder encodeObject:_location forKey:@"location"];
    [encoder encodeObject:_avatarUrl forKey:@"avatarUrl"];
    
    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _uid = [decoder decodeObjectForKey:@"uid"];
        _sessionId = [decoder decodeObjectForKey:@"sessionId"];
        _account = [decoder decodeObjectForKey:@"account"];
        _nickName = [decoder decodeObjectForKey:@"nickName"];
        _avatarData = [decoder decodeObjectForKey:@"avatarData"];
        if ([UIImage imageWithData:_avatarData] == nil) {
            _avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_child_88"]);
        }
        
        _sex = [[decoder decodeObjectForKey:@"sex"] intValue];
        _deviceDic = [decoder decodeObjectForKey:@"deviceDic"];
        if (_deviceDic == nil) {
            _deviceDic = [NSMutableDictionary dictionary];
        }
        _likeDevIMEI = [decoder decodeObjectForKey:@"likeDevIMEI"];
        _location = [decoder decodeObjectForKey:@"location"];
        _avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        
    }
    return  self;
}


-(BOOL)isLogin
{
    if (self.account == Nil || [self.account length] == 0) {
        return NO;
    }
    return YES;
}


-(BOOL)autoLoginWithUid:(NSString *)uid type:(int)_type {
    
    NSString *key = [NSString stringWithFormat:@"%@_UserData", uid];
    UserData *tempUserData = [self loadCustomObjectWithKey:key];
    if (tempUserData == nil) {
        return NO;
    }
    _uid = uid;
    _account = tempUserData.account;
    _avatarData = tempUserData.avatarData;
    _avatarUrl = tempUserData.avatarUrl;
    if ([UIImage imageWithData:_avatarData] == nil) {
        _avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"2_avatar_child_88"]);
    }
    _deviceDic = tempUserData.deviceDic;
    _likeDevIMEI = tempUserData.likeDevIMEI;
    _location = tempUserData.location;
    
    if (_type) {
        if (![_uid isEqualToString:tempUserData.uid] || ![_sessionId isEqualToString:tempUserData.sessionId]) {
            [self saveCustomObject:_instance];
        }
    } else {
        _sex = tempUserData.sex;
        _nickName = tempUserData.nickName;
        _sessionId = tempUserData.sessionId;
    }
    return YES;
}
- (UserData *)loadCustomObjectWithKey:(NSString *)key
{
    NSLog(@"read key =%@", key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    UserData *obj = (UserData *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    return obj;
}
- (void)saveCustomObject:(UserData *)obj
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *key = [NSString stringWithFormat:@"%@_UserData", obj.uid];
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"save key =%@", key);
}

- (void)save
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setObject:_avatarUrl forKey:@"avatarUrl"];
    [nd synchronize];
}

-(void)logoff {
    [self saveCustomObject:self];
    _uid = @"";
    _sessionId = @"";
    _account = @"";
    
    _nickName = @"";
    _avatarData = nil;
    _sex = 0;
    
    [_deviceDic removeAllObjects];;
    
    //退出请求列队
    [[OperationQueue Instance] logoff];
    //断开socket
    [[SocketClient Instance] disconnect];
}

@end
