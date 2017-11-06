//
//  TJNetwork.h
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTRequest : NSObject
/**
 *  post请求
 */
+ (void)sendPostRequest:(NSString *)urlStr
            withParamas:(NSMutableDictionary *)paras
               complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest;
/**
 *  get请求
 */
+ (void)sendGetRequestWithUrl:(NSString *)urlStr
                     complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest;
@end
