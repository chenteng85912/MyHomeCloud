//
//  TJPageController.h
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScrollCallBackBlock)(NSInteger pageNum);

typedef NS_ENUM(NSInteger,SelectedLineStyle) {
    UnDisplayMode,      //不显示
    AboveShowMode,      //上面
    UnderShowMode       //下面
};

@interface CTPageController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;          //展示的视图
@property (nonatomic, assign) SelectedLineStyle lineShowMode;    //标题线显示模式
@property (nonatomic, strong) UIColor *selectedColor;            //选择标题颜色
@property (nonatomic, strong) UIColor *headBackColor;            //标题背景颜色
@property (nonatomic, assign) CGFloat lineHeight;                //标题线高度
@property (nonatomic, assign) NSInteger selectedIndex;           //初始化视图的编号
@property (nonatomic, strong) ScrollCallBackBlock scrollBlock;

@end
