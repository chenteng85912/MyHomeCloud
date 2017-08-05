//
//  AJForgotPswViewController.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/8/5.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTBaseViewController.h"

typedef NS_ENUM(NSInteger,VerityModal) {
    ModityUserPswModal,     //修改密码
    VerityUserPhoneModal,    //验证手机号
    RegisterVerityUserPhoneModal    //注册成功后验证手机号

};

@interface AJForgotPswViewController : CTBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *userPhone;

@property (assign, nonatomic) VerityModal showModal;

@end
