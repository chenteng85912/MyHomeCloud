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
        _stateColor = [UIColor lightGrayColor];

    }else if(_state.integerValue==1){
        _stateStr = @"已确认";

        _stateColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:0 alpha:1];
    }else{
        _stateStr = @"已撤销";

        _stateColor = [UIColor redColor];
    }
    _estateId = self.objectData[ESTATE_ID];
    
    _rTime = self.objectData[RESERVER_TIME];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _creatTime = [formatter stringFromDate:self.objectData.createdAt];
    
    self.cellHeight  = 180;

}
@end