//
//  TAJ3D-TouchProcess.h
//  taiji
//
//  Created by tjsoft on 2017/12/4.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CT3D_TouchProcess : NSObject

+ (void)init3dTouch;

+ (void)CTApplication:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
      completionHandler:(void (^)(BOOL))completionHandler;

+ (BOOL)respondTouchAction:(NSDictionary *)launchOptions;

@end
