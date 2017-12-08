//
//  TYKYThemeScheme.m
//  webhall
//
//  Created by tjsoft on 2017/4/25.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "TYKYThemeScheme.h"

NSString *const ThemeColorKey = @"themeColorKey";

NSString *const ThemeUpdateNotification = @"ThemeUpdateNotification";

@implementation TYKYThemeScheme


+ (NSArray <NSString *>*)colorArray{
   
    return @[@"蓝色",@"橙色"];
}
+ (NSDictionary *)colorDic{
   
    return [NSDictionary dictionaryWithObjectsAndKeys:@"0x1478D6",@"蓝色",@"0xF49335",@"橙色", nil];
    
}
+ (NSString *)currentColorKey{
    NSString * key = [[NSUserDefaults standardUserDefaults] objectForKey:ThemeColorKey];
    if (!key) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[self colorArray][0] forKey:ThemeColorKey];
        
        return [self colorArray][0];

    }
    
    return key;
}
+ (NSString *)currentColorStr{
   
    return [self colorDic][[self currentColorKey]];
}


+ (void)saveCurrentThemeColor:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:ThemeColorKey];

}

+ (void)postChangeThemeNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeUpdateNotification object:nil];
}
@end
