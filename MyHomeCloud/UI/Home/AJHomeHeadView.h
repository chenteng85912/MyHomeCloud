//
//  AJHomeHeadView.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJHomeHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *heatTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

+ (instancetype)initWithSection:(NSInteger)section;

@end
