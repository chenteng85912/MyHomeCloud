//
//  AJFeedbackCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJFeedbackCellModel : AJTbViewCellModel
@property (strong, nonatomic) NSString *userName;//名称
@property (strong, nonatomic) NSString *title;//主题
@property (strong, nonatomic) NSString *content;//内容
@property (strong, nonatomic) NSString *time;//时间
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateStr;//状态 0待确认 1已确认 2已解决 3不属实 4问题重复
@property (strong, nonatomic) UIColor *stateColor;

@end
