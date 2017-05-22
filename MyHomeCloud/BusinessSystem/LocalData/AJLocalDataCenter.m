//
//  TYKYLocalDataCenter.m
//  webhall
//
//  Created by tjsoft on 2017/4/6.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJLocalDataCenter.h"

NSString *const TIME_KEY = @"time_key";
NSString *const ALLKEYS_KEY = @"allKeys";
NSInteger const AUTOCLEAR_TIME = 5;//分钟

@implementation AJLocalDataCenter
//沙盒根目录地址
+ (NSString*)documentPath
{
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];

    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:executableFile];
    
    BOOL isDir = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir];
    if(!isExist || !isDir)
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return cachePath;
}

//图片存储地址
+ (NSString *)imagePathWithImageName:(NSString *)imageName{
    
    NSString *imagePath = [[self documentPath] stringByAppendingPathComponent:imageName];
    
    return imagePath;
}
//文件存储地址
+ (NSString *)filePathWithURLstring:(NSString *)fileUrl{
    NSString *fileName = [fileUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *imgPath = [[self documentPath] stringByAppendingPathComponent:fileName];
    
    return imgPath;
}


//检测本地数据时效性
+ (BOOL)checkLocalData:(NSString *)localKey{
    
    NSString *timeKey = [TIME_KEY stringByAppendingString:localKey];
    
    NSInteger oldTime = [[NSUserDefaults standardUserDefaults] integerForKey:timeKey];
    NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
    
    //每天刷新一次
    if ((nowTime-oldTime)>=AUTOCLEAR_TIME*60) {
        [MyUserDefaults setInteger:nowTime forKey:timeKey];

        return NO;
    }
    
    return YES;
    
}
//清理缓存
+ (void)clearLocalData{
    
    //情况数据缓存
    NSArray *keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ALLKEYS_KEY];
    for (NSString *key in keyArray) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        
    }
    
    //清楚图片缓存1
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    //清除图片缓存2
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];

    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:executableFile];
    
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
}

//计算缓存大小
+ (NSString *)calcuteLocalDataSize{
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    //图片大小1
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:executableFile];
    NSArray *fileArray = [fileMan contentsOfDirectoryAtPath:cachePath error:nil];
    long long allSize= 0.0;
    for (NSString *fileName in fileArray) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        if([fileMan fileExistsAtPath:filePath])
        {
            long long size = [fileMan attributesOfItemAtPath:filePath error:nil].fileSize;
            allSize +=  size;
            
        }
    }
    
    //图片大小2
    long long sdSize= [[SDImageCache sharedImageCache] getSize];
    
    //本地数据大小
    NSArray *keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ALLKEYS_KEY];
    long long localSize = 0.0;
    for (NSString *key in keyArray) {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (value) {
            NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
            localSize += valueData.length;
        }
        
    }
    return [self makeSizeString:allSize+sdSize+localSize];
    
}

+ (NSString *)makeSizeString:(float)filesize{
    NSString *fileSizeString = @"0 M";
    
    if(filesize/1024>=1024)
    {
        filesize = filesize/1024/1024;
        fileSizeString = [NSString stringWithFormat:@"%.f M",filesize];
    }
    
    return fileSizeString;
}
@end
