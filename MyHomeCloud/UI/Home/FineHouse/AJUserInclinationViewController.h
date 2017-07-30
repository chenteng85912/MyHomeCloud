//
//  AJUserInclinationViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJBaseTbViewController.h"

typedef NS_ENUM(NSInteger,UserInclinationType) {
    SecondInclinationModal,  //二手房意愿
    LetInclinationModal,     //租房意愿
    NInclinationModal        //新房意愿
};
@interface AJUserInclinationViewController : AJBaseTbViewController

@property (assign, nonatomic) UserInclinationType inclinationModal;

@end
