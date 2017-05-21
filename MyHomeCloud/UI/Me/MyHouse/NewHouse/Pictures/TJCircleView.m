//
//  TJCircleView.m
//  LHCircleView
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "TJCircleView.h"

@interface TJCircleView ()
{
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;//用来填充的图层
    UIBezierPath *backGroundBezierPath;//背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;//用来填充的贝赛尔曲线
    CGPoint center;//中心点
}
@property (nonatomic,assign) CGFloat progressStrokeWidth;//宽度

@end
@implementation TJCircleView

- (instancetype)initWithFrame:(CGRect)frame progessColor:(UIColor *)pColor progressTrackColor:(UIColor *)tColor progressStrokeWidth:(CGFloat)sWidth
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.progressStrokeWidth = sWidth;
        //创建背景图层
        backGroundLayer = [CAShapeLayer layer];
        backGroundLayer.fillColor = nil;
        backGroundLayer.frame = self.bounds;
        
        //创建填充图层
        frontFillLayer = [CAShapeLayer layer];
        frontFillLayer.fillColor = nil;
        frontFillLayer.frame = self.bounds;
        
        frontFillLayer.strokeColor = pColor.CGColor;
        backGroundLayer.strokeColor = tColor.CGColor;
        
        center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-sWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        backGroundLayer.path = backGroundBezierPath.CGPath;
        
        frontFillLayer.lineWidth = sWidth;
        backGroundLayer.lineWidth = sWidth;
        
        [self.layer addSublayer:backGroundLayer];
        [self.layer addSublayer:frontFillLayer];
    }
    
    return self;
}
- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*progressValue-M_PI_2 clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
