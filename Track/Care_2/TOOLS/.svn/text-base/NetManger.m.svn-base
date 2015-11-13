//
//  NetManger.m
//  Care_2
//
//  Created by baoyx on 14/11/18.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "NetManger.h"
#import "UserData.h"
#import "ASIHTTPRequest.h"

@interface NetManger()<ASIHTTPRequestDelegate,NSURLConnectionDataDelegate>

@end
@implementation NetManger
{
    TokenSuc tokenBlock_;
    UploadFileSuc uploadFileBlock_;
    
    NSURLConnection *connection_;
    NSMutableData *recvData;
}

-(void)uploadFile:(NSData *)fileData
{
    __block typeof(self) self_=self;
    [self getToken];
    [self setTokenSuc:^(NSString *token) {
        [self_ uploadFile:fileData withToken:token];
    }];

}


-(void)getToken
{
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_getuploadfiletoken forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    request.tag=100;
    request.delegate=self;
    [request startAsynchronous];
    
}



#define BOUNDARY @"ABC12345678"
-(void)uploadFile:(NSData *)fileData withToken:(NSString *)token
{
    
//    NSString *str=[NSString stringWithFormat:@"http://113.108.103.150:8095/upload/file.do?method=file.upload&filename=%@&token=%@",@"q2",token];
//    ASIFormDataRequest *requset=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
//    [requset setFile:file forKey:@"filename"];
//    requset.delegate=self;
//    requset.tag=101;
//    [requset startAsynchronous];

    

    
    NSString *str=[NSString stringWithFormat:@"http://upload.movnow.com/upload/file.do?method=file.upload&filename=%@&token=%@",@"q2.jpg",token];
    NSURL *url=[NSURL URLWithString:str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"action\"\r\n"];
    [bodyString appendString:@"\r\n"];
//    [bodyString appendString:@"\r\n"];
//    [bodyString appendFormat:@"--%@\r\n", BOUNDARY];
//    [bodyString appendString:@"Content-Disposition: form-data; name=\"headimage\"; filename=\"test.png\"\r\n"];
//    [bodyString appendString:@"Content-Type: image/png\r\n"];
//    [bodyString appendString:@"\r\n"];
    
    NSLog(@"bodyString is %@..",bodyString);
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSData *bodyStringData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    [bodyData appendData:bodyStringData];
    [bodyData appendData:fileData];
    NSString *endString = [NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY];
    NSData *endData = [endString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    
    NSString *len = [NSString stringWithFormat:@"%ld", [bodyData length]];
    // 计算bodyData的总长度  根据该长度写Content-Lenngth字段
    [request addValue:len forHTTPHeaderField:@"Content-Length"];
    [request addValue:[MD5 getUserAgent] forHTTPHeaderField:@"User-Agent"];
    // 设置请求体
    [request setHTTPBody:bodyData];
    
    connection_=[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    if(request.tag ==100)
    {
        
         NSLog(@"jsonDic :%@   tag  :%ld",jsonDic,request.tag);
        if([jsonDic[@"error"] intValue] == 0)
        {
            tokenBlock_(jsonDic[@"token"]);
        }
    }
    
    
}


-(void)setTokenSuc:(TokenSuc)suc
{
    tokenBlock_=[suc copy];
}

-(void)setUploadFileSuc:(UploadFileSuc)suc
{
    uploadFileBlock_=[suc copy];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (recvData == nil) {
        recvData = [[NSMutableData alloc] init];
    }
    recvData.length = 0;
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recvData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
     NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableContainers error:nil];
    if([jsonDic[@"error"] isEqualToString:@"Succeed"])
    {
        
        NSLog(@"fileId=%@",jsonDic[@"fileId"]);
        uploadFileBlock_(jsonDic[@"fileId"]);
    }
}


@end
