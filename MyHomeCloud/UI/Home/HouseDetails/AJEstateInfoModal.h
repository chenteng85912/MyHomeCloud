//
//  AJEstateInfoModal.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/18.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJTbViewCellModel.h"

@interface AJEstateInfoModal : AJTbViewCellModel

@property (strong, nonatomic) NSDictionary *cellInfo;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *content;

@property (assign, nonatomic) CGFloat contentFone;
@property (assign, nonatomic) CGRect contentFrame;

- (instancetype)initValueWithDictionary:(NSDictionary *)dic;

@end
