//
//  CT_TableViewCellModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJTbViewCellModelProtocol.h"

extern CGFloat const NAME_FONT;
extern CGFloat const SUB_FONT;
extern CGFloat const DES_FONT;
extern CGFloat const TOTAL_FONT;
extern CGFloat const UNIT_FONT;

extern CGFloat const cellX;
extern CGFloat const cellY;
extern CGFloat const subY;

extern CGFloat const IMG_WIDTH;
extern CGFloat const IMG_HEIGHT;

@interface AJTbViewCellModel : NSObject<AJTbViewCellModelProtocol>

@property (strong, nonatomic) AVObject *objectData;     //单元格原始数据

@property (assign, nonatomic) CGFloat cellHeight;

@end
