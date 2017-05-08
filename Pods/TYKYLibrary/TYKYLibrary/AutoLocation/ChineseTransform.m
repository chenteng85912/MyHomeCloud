//
//  ChininesTransform.m
//
//  Created by Apple on 16/7/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChineseTransform.h"

@implementation ChineseTransform

+ (NSMutableArray *)readDataFormLocal{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    if (!plistPath) {
        return nil;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithContentsOfFile:plistPath];

    return temp;
}
//读取本地城市列表
+(NSMutableArray *)initCityDataFromLocal{
    if (![ChineseTransform readDataFormLocal]) {
        return nil;
    }
    NSMutableArray *cityArray = [ChineseTransform readDataFormLocal];
    
    //直辖市 经济特区 转变为城市
    NSArray *hotCity = @[@"北京",@"上海",@"天津",@"重庆",@"香港",@"澳门",@"国外"];

    NSMutableArray *resultCity = [NSMutableArray new];
    //反向遍历
    [cityArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *state = [obj valueForKey:@"state"];
        if ([hotCity containsObject:state]) {
            [cityArray removeObject:obj];
        }else{
            [resultCity addObjectsFromArray:[obj valueForKey:@"cities"]];

        }
        if (*stop) {
            [resultCity addObjectsFromArray:hotCity];
            [resultCity removeObject:@"国外"];
        }
        
    }];

    return resultCity;
}

//中文转拼音
+ (NSString *)chineseTransToPinyin:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSString *result = [pinyin.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];

    return result;
    
}

//拼音数组按首字母排序
+(NSArray *)arrangeWithPINYIN:(NSArray *)pinyinArray{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [pinyinArray sortedArrayUsingDescriptors:descriptors];
    return resultArray;
    
}

//按城市首字母 生产相应的城市数组 然后设置字典 key:字母  value:相应的数组
+ (NSMutableDictionary *)makeResultCityDictionary:(NSArray *)pinyinArray{

    //生成26个字母的数组
    NSMutableArray *letterArray = [NSMutableArray new];
    for (int i = 'A'; i <='Z'; i++) {
        [letterArray addObject:[NSString stringWithFormat:@"%c", i]];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (NSString *letter in letterArray) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",letter];
        
        NSArray *newArray = [pinyinArray filteredArrayUsingPredicate:predicate];
        if (newArray.count>0) {
            [dic setObject:newArray forKey:letter];
            
        }
    }
   
    return dic;
}

//检测是否为中文
+(BOOL)isChinese:(NSString *)str{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
@end
