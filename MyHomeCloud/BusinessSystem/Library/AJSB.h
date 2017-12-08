//
//  AJSB.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJSB : NSObject
//打开登录界面
+ (void)goLoginViewComplete:(dispatch_block_t)callBack;

//根据文件ID删除文件
+ (void)deleteFile:(NSString *)fileId complete:(void(^)(BOOL success, NSError *error))completeHandle;

@end
