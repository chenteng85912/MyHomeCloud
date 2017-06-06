//
//  CT_TableViewCellModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "AJTbViewCellModel.h"

CGFloat const NAME_FONT = 16.0;
CGFloat const SUB_FONT = 13.0;
CGFloat const DES_FONT = 13.0;
CGFloat const TOTAL_FONT = 15.0;
CGFloat const UNIT_FONT = 13.0;

@implementation AJTbViewCellModel
- (void)setObjectData:(AVObject *)objectData{
    _objectData = objectData;
    if (objectData[HOUSE_OBJECT]) {
        self.subObj = objectData[HOUSE_OBJECT];
    }
   
}


@end