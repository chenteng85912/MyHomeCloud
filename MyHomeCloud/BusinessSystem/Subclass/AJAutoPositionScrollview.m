//
//  TYKYAutoPositionScrollview.m
//  webhall
//
//  Created by tjsoft on 2017/6/20.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJAutoPositionScrollview.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface AJAutoPositionScrollview ()<UIScrollViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end
@implementation AJAutoPositionScrollview

- (void)drawRect:(CGRect)rect{
    [self setup];
    
}
-(void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setup {
    
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
    CGRect keyRece = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        if (keyBoardEndY<dHeight) {
            self.contentInset = UIEdgeInsetsMake(0, 0, keyRece.size.height, 0);
        }else{
            self.contentInset = UIEdgeInsetsZero;
            
        }
        
    }];
}
- (void)hiddenKeyboard{
    
    [self endEditing:YES];
    
}

- (UITapGestureRecognizer *)tapGesture{
    if (_tapGesture==nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    }
    return _tapGesture;
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
