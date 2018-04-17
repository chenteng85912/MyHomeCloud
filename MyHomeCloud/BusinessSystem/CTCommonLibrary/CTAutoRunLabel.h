//
//  AutoRunLabel.h
//  webhall
//
//  Created by Apple on 2016/10/24.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAutoRunLabel : UIView

/**
 *frame 位置
 *text 内容
 *fontSize 字体大小  （默认15）
 *textColor 字体颜色 （默认黑色）
 *speedNum 滚动速率，数字越大，滚动越慢（默认2）
 */

+ (instancetype)initWithFrame:(CGRect)frame
                    labelText:(NSString *)text
                         font:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
                        speed:(NSInteger)speedNum;
//停止滚动
- (void)stopRun;

@end
