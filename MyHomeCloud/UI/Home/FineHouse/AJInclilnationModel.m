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
    self.cellHeight = 205;
    
    _incinationType = self.objectData[ESTATE_TYPE];
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
