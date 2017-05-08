//
//  AutoRunLabel.m
//  webhall
//
//  Created by Apple on 2016/10/24.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "AutoRunLabel.h"


@implementation AutoRunLabel
#define DEVICE_WIDTH    [[UIScreen mainScreen] bounds].size.width

- (void)autoRunText{
    if (!self.text) {
        return;
    }
    self.textAlignment = NSTextAlignmentCenter;
    
    debugLog(@"位置：%@",NSStringFromCGRect(self.superview.frame));
    
    CGSize maxSize = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    if (maxSize.width<=self.frame.size.width) {
        return;
    }
    self.frame = CGRectMake(0, 0, maxSize.width, self.frame.size.height);
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.5];
}
- (void)startAnimation{
    NSInteger scale = self.frame.size.width/DEVICE_WIDTH*2;
    if (scale==0) {
        scale = 1;
    }
    [UIView animateWithDuration:20.0*scale delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.superview.frame.size.height);

    } completion:^(BOOL finished) {
        self.frame = CGRectMake(self.superview.frame.size.width, 0, self.frame.size.width, self.superview.frame.size.height);
        [self startAnimation];
        
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
