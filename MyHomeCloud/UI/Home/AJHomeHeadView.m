//
//  AJHomeHeadView.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeHeadView.h"

@implementation AJHomeHeadView

+ (instancetype)initWithSection:(NSInteger)section{
   
    AJHomeHeadView *headView = (AJHomeHeadView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (section==0) {
        headView.heatTitle.text = @"为您推荐二手房";
        
    }else if (section==1){
        headView.heatTitle.text = @"为您推荐出租房";
        
    }else{
        headView.heatTitle.text = @"为您推荐新房";
        
    }
    if (dWidth==320) {
        headView.heatTitle.font = [UIFont systemFontOfSize:18];
    }
    headView.headBtn.tag = section;
    return headView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
