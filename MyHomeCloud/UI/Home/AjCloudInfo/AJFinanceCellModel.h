//
//  AJFinanceCellModel.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/8/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

extern CGFloat const CONTENT_FONT;

@interface AJFinanceCellModel : AJTbViewCellModel

@property (strong, nonatomic) NSString *picUrl;//图片地址
@property (strong, nonatomic) NSMutableAttributedString *content;//文字内容

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGRect imgFrame;

@end
