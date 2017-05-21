//
//  TJCircleView.h
//  LHCircleView
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJCircleView : UIView

@property (nonatomic,assign) CGFloat progressValue;//进度


- (instancetype)initWithFrame:(CGRect)frame progessColor:(UIColor *)pColor progressTrackColor:(UIColor *)tColor progressStrokeWidth:(CGFloat)sWidth;
@end
