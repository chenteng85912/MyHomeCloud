//
//  AJInclilnationModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJInclilnationModel.h"

@implementation AJInclilnationModel

- (void)calculateSizeConstrainedToSize{
    self.cellHeight = 230;
    
    if ([self.objectData[ESTATE_TYPE] isEqualToString:SECOND_HAND_HOUSE]) {
        _incinationType = @"二手房";
    }else if ([self.objectData[ESTATE_TYPE] isEqualToString:LET_HOUSE]){
        _incinationType = @"租房";

    }else{
        _incinationType = @"新房";

    }
    _incinationArea = self.objectData[HOUSE_AREA];
    _incinationAreaage = self.objectData[HOUSE_AREAAGE];
    _incinationPrice = self.objectData[HOUSE_TOTAL_PRICE];
    _incinationRooms = self.objectData[HOUSE_AMOUNT];
    _incinationTags = self.objectData[HOUSE_TAGS];
    _incinationPhone = self.objectData[USER_PHONE];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _creatTime = [formatter stringFromDate:self.objectData.createdAt];
}
@end
