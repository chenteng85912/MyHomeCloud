//
//  CTPhotosConfig.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef CTPhotosConfig_h
#define CTPhotosConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CTSavePhotos.h"
#import "CTPhotosConfiguration.h"
#import "CTPHAssetModel.h"
#import "UIButton+CTButtonManager.h"

#define WEAKSELF    __weak typeof(self) weakSelf = self

//导航栏高度
#define NAVBAR_HEIGHT     ([[UIApplication sharedApplication] statusBarFrame].size.height+44)
#define IPhoneX  ([UIScreen mainScreen].bounds.size.height == 812 && [UIScreen mainScreen].bounds.size.width == 375)

#endif /* CTPhotosConfig_h */
