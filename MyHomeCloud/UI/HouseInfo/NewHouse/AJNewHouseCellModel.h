//
//  AJNewHouseCellModel.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTbViewCellModel.h"

@interface AJNewHouseCellModel : AJTbViewCellModel
@property (strong, nonatomic) NSString *estateName;//名称
@property (strong, nonatomic) NSString *address;//地址
@property (strong, nonatomic) NSString *unitPrice;//均价
@property (strong, nonatomic) NSString *estateTags;//标签

@property (assign, nonatomic) CGRect imgFrame;
@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect addressFrame;
@property (assign, nonatomic) CGRect tagsFrame;
@property (assign, nonatomic) CGRect priceFrame;

@end
