//
//  TJNetwork.m
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CTRequest.h"

#define debugLog(...) NSLog(__VA_ARGS__)
NSInteger const postTimeOut = 30.0;
NSInteger const getTimeOut = 30.0;

@interface CTRequest ()<NSURLSessionDelegate>

@end
@implementation CTRequest

//post请求
- (void)sendPostRequest:(NSString *)urlStr withParamas:(NSMutableDictionary *)paras complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingPrettyPrinted error:&error];
    
    request.HTTPBody = jsonData;
    //超时时间
    request.timeoutInterval = postTimeOut;
    
    [self sendRequest:request complete:^(NSError *error, NSDictionary *objectDic) {
        afterRequest(error,objectDic);
    }];
}

//get请求
- (void)sendGetRequestWithUrl:(NSString *)urlStr complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"GET";
    //超时时间
    request.timeoutInterval = getTimeOut;
    
   [self sendRequest:request complete:^(NSError *error, NSDictionary *objectDic) {
       afterRequest(error,objectDic);
   }];
}

- (void)sendRequest:(NSMutableURLRequest *)request complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest{
   
   
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[[NSOperationQueue alloc]init]];

    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                afterRequest(error,nil);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                debugLog(@"网络请求返回的数据:%@",dict);
                afterRequest(nil,dict);
            }
        });
       
    }];
    
    //发送请求
    [dataTask resume];
}
#pragma mark - NSURLSessionDelegate
/*
 // 只要访问的是HTTPS的路径就会调用
 // 该方法的作用就是处理服务器返回的证书, 需要在该方法中告诉系统是否需要安装服务器返回的证书
 // 1.从服务器返回的受保护空间中拿到证书的类型
 // 2.判断服务器返回的证书是否是服务器信任的
 // 3.根据服务器返回的受保护空间创建一个证书
 // 4.创建证书 安装证书
 //   completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
 */
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    //AFNetworking中的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:忽略证书 默认的做法
         NSURLSessionAuthChallengeUseCredential：使用指定的证书
         NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求,忽略证书
         NSURLSessionAuthChallengeRejectProtectionSpace 拒绝,忽略证书
         */
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
@end
