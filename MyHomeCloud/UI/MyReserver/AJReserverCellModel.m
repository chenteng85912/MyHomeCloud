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
    
    _rUserName = self.objectData[USER_NAME];
    _rUserPhone = self.objectData[USER_PHONE];

    _state = self.objectData[RESERVER_STATE];
    if (_state.integerValue==0) {
        _stateColor = [UIColor lightGrayColor];

    }else if(_state.integerValue==1){
        _stateColor = [UIColor greenColor];
    }else{
        _stateColor = [UIColor redColor];
    }
    _estateId = self.objectData[ESTATE_ID];
    
    _rTime = self.objectData[RESERVER_TIME];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _creatTime = [formatter stringFromDate:self.objectData.createdAt];
    
    self.cellHeight  =200;

}
@end
