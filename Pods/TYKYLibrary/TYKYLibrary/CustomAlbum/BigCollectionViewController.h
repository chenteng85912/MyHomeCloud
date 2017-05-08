//
//  BigCollectionViewController.h
//
//  Created by Apple on 16/7/22.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BigCollectionViewControllerDelegate <NSObject>

- (void)comfirnChoose;

@end

@interface BigCollectionViewController : UIViewController

@property (strong,nonatomic) NSArray *dataArray;//图片数组
@property (strong,nonatomic) NSMutableDictionary *selectDic;//选中的图片
@property (assign,nonatomic) NSInteger index;//选中图片位置
@property (assign,nonatomic) NSInteger totalNum;//可选择照片总数量
@property (nonatomic,weak) id <BigCollectionViewControllerDelegate> delegate;

@end
