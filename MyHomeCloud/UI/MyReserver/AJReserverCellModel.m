//
//  AJReserverCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJReserverCellModel.h"


@implementation AJReserverCellModel

- (void)calculateSizeConstrainedToSize{
    _houseName = self.objectData[HOUSE_ESTATE_NAME];
    _agenterName = self.objectData[AGENTER_NAME];
    _agenterPhone = self.objectData[AGENTER_PHONE];
    
    _rUserName = self.objectData[RESERVER_NAME];
    _rUserPhone = self.objectData[RESERVER_PHONE];

    _state = self.objectData[RESERVER_STATE];
    if (_state.integerValue==0) {
        _stateStr = @"待确认";
        _stateColor = [UIColor darkGrayColor];

    }else if(_state.integerValue==1){
        _stateStr = @"已确认";

        _stateColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:0 alpha:1];
    }else{
        _stateStr = @"已撤销";

        _stateColor = [UIColor redColor];
    }
    _estateId = self.objectData[ESTATE_ID];
    
    _rTime = self.objectData[RESERVER_TIME];
    
    //房源面积 新楼盘为空
    if (self.objectData[HOUSE_AREAAGE]){
        _houseAreaage = [NSString stringWithFormat:@"%@m²",self.objectData[HOUSE_AREAAGE]];
        NSString *type = self.objectData[RESERVER_TYPE];
        if ([type isEqualToString:SECOND_HAND_HOUSE]) {
            _pricType = @"房屋总价";
            _housePrice = [NSString stringWithFormat:@"%@万",self.objectData[HOUSE_TOTAL_PRICE]];
            
        }else{
            _pricType = @"房屋租金";
            _housePrice = [NSString stringWithFormat:@"%@元/月",self.objectData[LET_HOUSE_PRICE]];
            
        }
    }else{
        _pricType = @"楼盘均价";
        _housePrice = [NSString stringWithFormat:@"约%@元/平",self.objectData[HOUSE_UNIT_PRICE]];
    }
   
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _creatTime = [formatter stringFromDate:self.objectData.createdAt];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *lookTime = [formatter dateFromString:_rTime];
    NSInteger creatIn = [lookTime timeIntervalSinceNow];
    if (creatIn<0) {
        _stateStr = @"已过期";
        _stateColor = [UIColor lightGrayColor];

    }
    self.cellHeight  = 255;

}
@end
