//
//  CTPhotosConfiguration.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/12.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface CTPhotosConfiguration : NSObject

+ (NSString *)collectionSubTypeStr:(NSInteger)subType;

//照片类型
+ (NSArray *)groupNamesConfig;

//输出照片压缩比 默认0.6
+ (CGFloat)outputphotosScale;

//最大数量 默认9
+ (NSInteger)maxNum;

@end
