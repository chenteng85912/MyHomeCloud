//
//  TYKYLocalDataCenter.m
//  webhall
//
//  Created by tjsoft on 2017/4/6.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJLocalDataCenter.h"

NSString *const TIME_KEY = @"time_key";
NSString *const ALLKEYS_KEY = @"ajCloudAllKeys";

NSString *const SECOND_HOUSE_KEY = @"second_search_key";
NSString *const LET_HOUSE_KEY = @"let_search_key";
NSString *const N_HOUSE_KEY = @"n_house_key";

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
//读取本地房屋数据
+ (NSArray *)readLocalHouseInfo:(NSString *)houseId{
    if (!houseId) {
        return nil;
    }
    NSString *houseStr = [MyUserDefaults objectForKey:houseId];
    if (!houseStr) {
        debugLog(@"本地房屋数据为空");
        return nil;
    }
    NSData *JSONData = [houseStr dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if (responseJSON.count>0) {
        debugLog(@"读取房屋数据成功");

        return responseJSON;
    }
    return nil;
    
}
//保存本地房屋数据
+ (void)saveLocalHouseInfo:(NSArray *)houseInfo withHouseId:(NSString *)houseId{
    if (!houseId||!houseInfo) {
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:houseInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fileString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    [MyUserDefaults setObject:fileString forKey:houseId];
    [MyUserDefaults synchronize];
    [self saveLocalKey:houseId];

}
//保存所有KEY
+ (void)saveLocalKey:(NSString *)localKey{
    NSMutableArray *temp = [NSMutableArray new];
    NSArray *keyArray = [[NSUserDefaults standardUserDefaults] objectForKey:ALLKEYS_KEY];
    if (keyArray.count>0) {
        [temp addObjectsFromArray:keyArray];
    }
    [temp addObject:localKey];
    [MyUserDefaults setObject:temp forKey:ALLKEYS_KEY];
    [MyUserDefaults synchronize];

}
//清理缓存
+ (void)clearLocalData{
    
    //情况数据缓存
    NSArray *keyArray = [MyUserDefaults objectForKey:ALLKEYS_KEY];
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

//读取搜索关键词
+ (NSMutableArray *)readLocalSearchData:(SearchModal)searchModal{
   
    NSMutableArray *temp = [NSMutableArray new];
    
    NSString *fileString = [MyUserDefaults objectForKey:[self userSearchKey:searchModal]];
    if (!fileString) {
        debugLog(@"本地搜索为空");
        return temp;
    }
    
    NSData *JSONData = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if (responseJSON.count>0) {
        [temp addObjectsFromArray:responseJSON];
    }
    debugLog(@"读取搜索数据成功");
    return temp;

}
+ (NSString *)userSearchKey:(SearchModal)searchModal{
    NSString *searchKey;
    if (searchModal==SHouseModal) {
        searchKey = [NSString stringWithFormat:@"%@_%@",[AVUser currentUser].mobilePhoneNumber,SECOND_HOUSE_KEY];
    }else if (searchModal==LHouseModal){
        searchKey = [NSString stringWithFormat:@"%@_%@",[AVUser currentUser].mobilePhoneNumber,LET_HOUSE_KEY];
        
    }else{
        searchKey = [NSString stringWithFormat:@"%@_%@",[AVUser currentUser].mobilePhoneNumber,N_HOUSE_KEY];
        
    }
    return searchKey;
}
//保存搜索关键词
+ (void)saveLocalSearchKey:(NSMutableArray *)searchArray searchModal:(SearchModal)searchModal{

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:searchArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fileString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [MyUserDefaults setObject:fileString forKey:[self userSearchKey:searchModal]];
    [MyUserDefaults synchronize];

}

//清空搜索关键词
+ (void)clearLocalSearchKeys:(SearchModal)searchModal{
    [MyUserDefaults removeObjectForKey:[self userSearchKey:searchModal]];
}

//删除某条搜索关键词
+ (void)deleteSearchKey:(NSMutableArray *)searchArray searchModal:(SearchModal)searchModal{
    
    if (searchArray.count==0) {
        [MyUserDefaults removeObjectForKey:[self userSearchKey:searchModal]];
        debugLog(@"搜索数据被清空");
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:searchArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fileString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [MyUserDefaults setObject:fileString forKey:[self userSearchKey:searchModal]];
    [MyUserDefaults synchronize];

}
@end
