//
//  CTDataSource.h
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/30.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CTTbViewCellBlock)(UITableViewCell *cell, id model, NSIndexPath * indexPath);

@interface CTDataSourceObj : NSObject<UITableViewDataSource>

/**
 列表代理对象

 @param identifier cell标识
 @param cellBlock cell绘制回调
 @return 返回列表代理对象
 */
+ (instancetype)createTableViewDataSourceWithIdentify:(NSString * _Nullable)identifier
                                   cellConfigureBlock:(CTTbViewCellBlock)cellBlock;


/**
 初始化数据

 @param models 数据源
 @param block 回调
 */
- (void)initDataSource:(NSArray * _Nullable)models
              complete:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
