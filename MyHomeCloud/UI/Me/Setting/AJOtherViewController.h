//
//  AJOtherViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/20.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"
typedef NS_ENUM(NSInteger,CommonShowModal) {
    AboutUsShowModal,      //关于我们
    DeclareShowModal,      //隐私声明
};
@interface AJOtherViewController : CTBaseViewController

@property (assign, nonatomic) CommonShowModal showModal;

@end
