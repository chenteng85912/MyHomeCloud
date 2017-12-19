//
//  AutoRunLabel.m
//  webhall
//
//  Created by Apple on 2016/10/24.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "CTAutoRunLabel.h"

@interface CTAutoRunLabel ()
@property (strong, nonatomic) CADisplayLink *displayLink;//定时器
@property (strong, nonatomic) UILabel *contentLabel;//内容
@end

@implementation CTAutoRunLabel

+ (instancetype)initWithFrame:(CGRect)frame
                    labelText:(NSString *)text
                         font:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
                        speed:(NSInteger)speedNum{
    return [[self alloc] initWithFrame:frame
                             labelText:text
                                  font:fontSize
                             textColor:textColor
                         textAlignment:textAlignment
                                 speed:speedNum];
}
- (instancetype)initWithFrame:(CGRect)frame
                    labelText:(NSString *)text
                         font:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
                        speed:(NSInteger)speedNum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.frame = frame;
        self.contentLabel.text = text;
        self.contentLabel.font = [UIFont systemFontOfSize:fontSize?fontSize:15];
        self.contentLabel.textColor = textColor?textColor:[UIColor blackColor];
        self.contentLabel.textAlignment = textAlignment?textAlignment:NSTextAlignmentCenter;
        self.displayLink.frameInterval = speedNum?speedNum:2;
        if (text) {
            [self calucateLabelLenght];
           
        }
    }
    return self;
}

//计算长度 判断是否滚动
- (void)calucateLabelLenght{
   
    CGSize maxSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;

    if (maxSize.width<=self.frame.size.width) {
        return;
    }
    self.contentLabel.frame = CGRectMake(20, 0, maxSize.width, self.frame.size.height);

    CACurrentMediaTime();
    self.displayLink.paused = NO;

}

//开始滚动
- (void)autoRun{
    CGFloat centerX = self.contentLabel.center.x-1;
    if (centerX<-self.contentLabel.frame.size.width/2) {
        centerX = self.contentLabel.frame.size.width/2+self.frame.size.width;
    }
    self.contentLabel.center = CGPointMake(centerX, self.contentLabel.center.y);

}
//停止滚动
- (void)stopRun{
    self.displayLink.paused = YES;
    self.displayLink = nil;
}
#pragma mark - getter and setter
- (CADisplayLink *)displayLink{
    if (_displayLink == nil) {
        _displayLink =[CADisplayLink displayLinkWithTarget:self selector:@selector(autoRun)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return _displayLink;
}
- (UILabel *)contentLabel{
    if (_contentLabel==nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (void)dealloc{
    self.displayLink.paused = YES;
    self.displayLink = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
