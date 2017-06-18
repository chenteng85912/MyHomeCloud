//
//  AJNewHouseModel.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouseModel.h"

@implementation AJNewHouseModel

- (void)calculateSizeConstrainedToSize{
    
    _houseName  = self.objectData[HOUSE_ESTATE_NAME];
    _devlopName = self.objectData[HOUSE_DEVELOPER];
    _areaName = self.objectData[HOUSE_AREA];
    _houseYear = self.objectData[HOUSE_YEARS];

    self.cellHeight = 80;
}
@end
