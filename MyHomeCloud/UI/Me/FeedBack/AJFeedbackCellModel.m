//
//  AJFeedbackCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFeedbackCellModel.h"

@implementation AJFeedbackCellModel

- (void)calculateSizeConstrainedToSize{
    _title = self.objectData[FEEDBACK_TITLE];
    _content = self.objectData[FEEDBACK_CONTENT];
    
    _userName = self.objectData[USER_NAME];
    
    //状态 0待确认 1已确认 2已解决 3不属实 4问题重复
    _state = self.objectData[FEEDBACK_STATE];
    if (_state.integerValue==0) {
        _stateStr = @"待确认";
        _stateColor = [UIColor lightGrayColor];
        
    }else if(_state.integerValue==1){
        _stateStr = @"已确认";
        
        _stateColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:0 alpha:1];
    }else if(_state.integerValue==1){
        _stateStr = @"已解决";
        
        _stateColor = NavigationBarColor;
    }else if(_state.integerValue==1){
        _stateStr = @"不属实";
        
        _stateColor = [UIColor groupTableViewBackgroundColor];
    }
    else{
        _stateStr = @"问题重复";
        
        _stateColor = [UIColor redColor];
    }
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _time = [formatter stringFromDate:self.objectData.createdAt];
    self.cellHeight = 180;
}
@end
