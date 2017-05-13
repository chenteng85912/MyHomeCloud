//
//  AJHomeCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeCellModel.h"

@implementation AJHomeCellModel
- (void)calculateSizeConstrainedToSize{
    
    if ([self.type isEqualToString:FAVORITE_HOUSE]||[self.type isEqualToString:RECORD_HOUSE]) {
        AVObject *object = self.objectData[HOUSE_OBJECT];
        return;
    }
}
@end
