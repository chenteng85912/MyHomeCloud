//
//  AppDelegate.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/8.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//房屋标签
@property (strong, nonatomic) NSMutableDictionary *desInfo;

//区域
@property (strong, nonatomic) NSArray *areaArray;

@end

