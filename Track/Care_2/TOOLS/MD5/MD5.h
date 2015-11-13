//
//  MD5.h
//  md5_Project
//
//  Created by BJ on 2011/4/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MD5 : NSObject {

}
// MD5加密
+ (NSString *) md5:(NSString *)str;
// 文件MD5效验
+(BOOL)fileEffectWithMd5:(NSString *)md5 filePath:(NSString *)filePath;

// url编码
+ (NSString *) urlencode: (NSString *) url;

// base64编码
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

// SHA1加密
+ (NSString *) sha1:(NSString *)str;

// 数字签名
+(NSString *)createSignWithDictionary:(NSMutableDictionary *)signInfo;
// 创建Url
+(NSString *)createUrlWithDictionary:(NSDictionary *)signInfo Sign:(NSString *)sign;

//判断邮箱格式的正则表达式
+(BOOL) validateEmail:(NSString *)email;
//判断密码的正则表达式
+ (BOOL) validatePassword:(NSString *)passWord;
//判断密码强度
+(int)judgePasswordStrength:(NSString*)password;

//判断手机号码的正则表达式
+(BOOL)checkPhoneNumInput:(NSString *)phone;

//获取星期几
+(NSString *)getWeekStringWithDate:(NSDate *)date;

// 获取userAgent
+(NSString *)getUserAgent;
// 判断是否纯数字
+(BOOL)isPureInt:(NSString *)string withNum:(int) num;

+(BOOL)isInChina;

//中文环境
+ (BOOL)isChina;
@end
