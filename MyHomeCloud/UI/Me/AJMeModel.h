//
//  AJMeModel.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJMeModel : NSObject

@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *iconName;//图标名称
@property (strong, nonatomic) NSString *className;//类名
@property (assign, nonatomic) BOOL checkLogin;//是否需要登录

@end
