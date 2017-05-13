//
//  CT_TableViewCellModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJTbViewCellModelProtocol.h"

@interface AJTbViewCellModel : NSObject<AJTbViewCellModelProtocol>

@property (strong, nonatomic) AVObject *objectData;   //单元格原始数据
@property (strong, nonatomic) NSString *type;         //类型
@property (assign, nonatomic) CGFloat cellHeight;

@end
