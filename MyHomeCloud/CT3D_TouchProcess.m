//
//  TAJ3D-TouchProcess.m
//  taiji
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CT3D_TouchProcess.h"
#import "AJSearchViewController.h"
#import "AJSecondHouseViewController.h"
#import "AJLetHouseViewController.h"
#import "AJNewHouseViewController.h"

NSString *const searchKey = @"搜索";
NSString *const letHouse = @"租房";
NSString *const secondHouse = @"二手房";
NSString *const newHouse = @"新房";

@implementation CT3D_TouchProcess

+ (CT3D_TouchProcess *)instance {
    static CT3D_TouchProcess *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CT3D_TouchProcess alloc] init];
    });
    return instance;
}

+ (void)init3dTouch{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue<9.0) {
        return;
    }
    //图标
    UIApplicationShortcutIcon *searchIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"short_search"];
    UIApplicationShortcutIcon *letIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"short_letHouse"];
    UIApplicationShortcutIcon *secondIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"short_secondHouse"];
    UIApplicationShortcutIcon *newIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"short_newHouse"];

    //创建快捷选项
    UIApplicationShortcutItem *search = [[UIApplicationShortcutItem alloc]initWithType:[CTTool appName] localizedTitle:searchKey localizedSubtitle:nil icon:searchIcon userInfo:nil];
    UIApplicationShortcutItem *letHousse = [[UIApplicationShortcutItem alloc]initWithType:[CTTool appName] localizedTitle:letHouse localizedSubtitle:nil icon:letIcon userInfo:nil];
    UIApplicationShortcutItem *second = [[UIApplicationShortcutItem alloc]initWithType:[CTTool appName] localizedTitle:secondHouse localizedSubtitle:nil icon:secondIcon userInfo:nil];
    UIApplicationShortcutItem *House = [[UIApplicationShortcutItem alloc]initWithType:[CTTool appName] localizedTitle:newHouse localizedSubtitle:nil icon:newIcon userInfo:nil];

    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[search,letHousse,second,House];
}
+ (void)CTApplication:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
      completionHandler:(void (^)(BOOL))completionHandler{
    if (shortcutItem) {
        [self touchAction:shortcutItem];

    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}
+ (BOOL)respondTouchAction:(NSDictionary *)launchOptions{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue<9.0) {
        return true;
    }
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (!shortcutItem) {
        return true;
    }
    [self touchAction:shortcutItem];
    
    return NO;
    
}
+ (void)touchAction:(UIApplicationShortcutItem *)shortcutItem{
    if([shortcutItem.localizedTitle isEqualToString:searchKey]){
        if([TOPVC isKindOfClass:[AJSearchViewController class]]){
            return;
        }
        AJSearchViewController *search = [AJSearchViewController new];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [TOPVC presentViewController:nav animated:YES completion:nil];
    }else{
        UIViewController *vc;
        if ([shortcutItem.localizedTitle isEqualToString:secondHouse]) {
            if([TOPVC isKindOfClass:[AJSecondHouseViewController class]]){
                return;
            }
            AJSecondHouseViewController *second = [AJSecondHouseViewController new];
            second.showModal = AllHouseModal;
            second.className = SECOND_HAND_HOUSE;
            second.showFilter = YES;
            vc = second;
        }else if ([shortcutItem.localizedTitle isEqualToString:letHouse]){
            if([TOPVC isKindOfClass:[AJLetHouseViewController class]]){
                return;
            }
            AJLetHouseViewController *let = [AJLetHouseViewController new];
            let.showModal = AllHouseModal;
            let.className = LET_HOUSE;
            let.showFilter = YES;
            
            vc = let;
            
        }else{
            if([TOPVC isKindOfClass:[AJNewHouseViewController class]]){
                return;
            }
            AJNewHouseViewController *newHouse = [AJNewHouseViewController new];
            newHouse.showModal = AllHouseModal;
            newHouse.className = N_HOUSE;
            newHouse.showFilter = YES;
            
            vc = newHouse;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [TOPVC.navigationController pushViewController:vc animated:YES];
    }

}

@end
