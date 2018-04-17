//
//  CTLoopViewController.h
//
//  Created by 腾 on 16/9/3.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CTLoopScollDirection) {
    CTLoopScollDirectionHorizontal, //水平滚动
    CTLoopScollDirectionVertical,   //竖向滚动
    
};

typedef NS_ENUM(NSInteger,CTLoopCellDisplayModal) {
    CTLoopCellDisplayImage,     //图片单元格
    CTLoopCellDisplayCustomView,//自定义视图单元格
    
} ;

@protocol CTAutoLoopViewDelegate <NSObject>

@optional;
/**
 *  自定义单元格代理
 */
- (UIView *)CTAutoLoopViewController:(UICollectionViewCell *)collectionCell cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  点击单元格动作
 */
- (void)CTAutoLoopViewController:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CTAutoLoopViewController : UIViewController

@property (weak,nonatomic) id<CTAutoLoopViewDelegate>delegate;

/**
 *  创建无线循环滚动实例
 *  传入滚动时间间隔
 *  选择滚动单元格显示模式
 *  选择滚动方向
 *  @return 返回实例对象
 */
+ (instancetype)initWithFrame:(CGRect)frame
                onceLoopTime:(float)onceLoopTime
            cellDisplayModal:(CTLoopCellDisplayModal)cellDisplayModal
               scollDiretion:(CTLoopScollDirection)loopScollDirection;
/**
 *  添加数据，如果选择图片模式，请传入图片数组
 */
- (void)addLocalModels:(NSArray *)array;

@end
