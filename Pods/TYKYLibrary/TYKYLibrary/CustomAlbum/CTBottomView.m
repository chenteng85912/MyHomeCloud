//
//  CTBottomView.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/18.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import "CTBottomView.h"

@implementation CTBottomView

- (void)drawRect:(CGRect)rect{
    [self initSubViews];
}
- (void)initSubViews{
    
    [self addSubview:self.senderBtn];

    [self addSubview:self.originBtn];
}

- (UIButton *)originBtn{
    if (!_originBtn) {
        _originBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 60, 30)];
        [_originBtn setTitle:@"原图" forState:UIControlStateNormal];
        _originBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _originBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        [_originBtn setImage:[UIImage imageNamed:@"origin_unselect"] forState:UIControlStateNormal];
        [_originBtn setImage:[UIImage imageNamed:@"origin_selected"] forState:UIControlStateSelected];
    }
    return _originBtn;
}
- (UIButton *)senderBtn{
    if (!_senderBtn) {
        _senderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-70, 7, 60, 30)];
        _senderBtn.layer.masksToBounds = YES;
        _senderBtn.layer.cornerRadius = 3.0;
        [_senderBtn setTitle:@"发送" forState:UIControlStateDisabled];
        [_senderBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
        _senderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _senderBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:151/255.0 blue:216/255.0 alpha:1];
    }
    return _senderBtn;
}
@end
