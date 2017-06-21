//
//  TYKYAutoPositionScrollview.m
//  webhall
//
//  Created by tjsoft on 2017/6/20.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJAutoPositionScrollview.h"

@interface AJAutoPositionScrollview ()<UIScrollViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (assign, nonatomic) CGFloat originHeight;
@property (strong, nonatomic) UIView *orignSuperView;

@end
@implementation AJAutoPositionScrollview

- (void)drawRect:(CGRect)rect{
    [self setup];

}
-(void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setup {
//    [self addSubview:self.orignSuperView];

    _originHeight = self.frame.size.height;
    [self addGestureRecognizer:self.tapGesture];
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
        self.contentSize = self.bounds.size;
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageBunldeViewFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageBunldeViewFrame:) name:UIKeyboardWillHideNotification object:nil];
    self.delegate = self;
}
//键盘监听
- (void)chageBunldeViewFrame:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self addSubview:self.orignSuperView];
    
    CGFloat sHeight = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        CGFloat keyboardHeight = sHeight-keyBoardEndY;
        CGFloat selfHeight = keyBoardEndY<sHeight?_originHeight-keyboardHeight:_originHeight;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, selfHeight);

    }];
}
//- (UIView *)orignSuperView{
//    if (_orignSuperView ==nil) {
//        _orignSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _orignSuperView.backgroundColor = self.backgroundColor;
//        for (UIView * view in self.subviews) {
//            [self.orignSuperView addSubview:view];
//        }
//    }
//    return _orignSuperView;
//}
- (UITapGestureRecognizer *)tapGesture{
    if (_tapGesture==nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    }
    return _tapGesture;
}
- (void)hiddenKeyboard{
    [self endEditing:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
