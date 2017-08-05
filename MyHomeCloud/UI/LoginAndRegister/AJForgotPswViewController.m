//
//  AJForgotPswViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/8/5.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJForgotPswViewController.h"

@interface AJForgotPswViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emsCode;
@property (weak, nonatomic) IBOutlet UITextField *nPsw;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *verityView;

@property (strong, nonatomic) CADisplayLink *displayLink;//定时器

@end

@implementation AJForgotPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.showModal==ModityUserPswModal) {
        self.title  = @"重置密码";

    }else{
        self.title  = @"验证手机号";
        _verityView.hidden = NO;
        if (self.userPhone.hasText) {
            _userPhone.enabled = NO;
            _emsCode.enabled = NO;
        }
    }

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    if (self.navigationController.viewControllers.count==0) {
        return NO;
    }else{
        if (self.showModal == RegisterVerityUserPhoneModal){
            return NO;
        }
        return YES;
    }
}
- (IBAction)btnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag==0) {
        if (!_userPhone.hasText) {
            [self.view showTips:_userPhone.placeholder withState:TYKYHUDModeWarning complete:nil];
            
            return;
        }
        if (![CTTool isValidateMobile:_userPhone.text]) {
            [self.view showTips:@"请输入正确的手机号码" withState:TYKYHUDModeWarning complete:nil];
            
            return;
        }
//        kCountDown = 60;
//        self.codeBtn.enabled = NO;
//        
//        CACurrentMediaTime();
//        self.displayLink.paused = NO;
//        debugLog(@"定时器开始了");

        if (self.showModal == ModityUserPswModal) {
            [self fetchResetPswEmsCode];

        }else{
            [self fetchVerityEmsCode];

        }
        return;
    }
    if (sender.tag==2) {
        [self showVerityUserPhoneAction];
        return;
    }
    if (sender.tag==3) {
        [self verityUserPhone];
      
        return;
    }
   
    [self modityUserPsw];
}
- (IBAction)hiddenView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _verityView.alpha = 0.0;
    }];
}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        if (textField == _nPsw) {
            [self modityUserPsw];
        }
        return NO;
    }
    
    NSString *resultStr = [textField.text stringByAppendingString:string];
    if (textField==self.userPhone&&resultStr.length>11) {
        [textField resignFirstResponder];
        [self.view showTips:@"手机号应当为11位数字" withState:TYKYHUDModeWarning complete:nil];
        return NO;
        
    }
    if (textField==self.emsCode&&resultStr.length>6) {
        [textField resignFirstResponder];
        [self.view showTips:@"验证码应当为6位数字" withState:TYKYHUDModeWarning complete:nil];
        return NO;

    }
   
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取修改密码验证码
- (void)fetchResetPswEmsCode{
    [self.view showHUD:nil];
    WeakSelf;
    [AVUser requestPasswordResetWithPhoneNumber:_userPhone.text block:^(BOOL succeeded, NSError *error) {
        [weakSelf.view removeHUD];
        
        if (!succeeded) {
            
            weakSelf.codeBtn.enabled = YES;
            if (error.code==215) {
                [UIAlertController alertWithTitle:@"温馨提示" message:@"您的手机号未验证,请先验证" cancelButtonTitle:@"暂不" otherButtonTitles:@[@"去验证"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        [weakSelf showVerityUserPhoneAction];
                    }
                }];
                
                return;
            }
            [weakSelf showError:error];
            
        }
    }];
}
//跳转验证手机号界面
- (void)showVerityUserPhoneAction{
    
    AJForgotPswViewController *verity = [AJForgotPswViewController new];
    verity.showModal = VerityUserPhoneModal;
    APP_PUSH(verity);
    
}
//获取验证手机号验证码
- (void)fetchVerityEmsCode{
    WeakSelf;
    [self.view showHUD:nil];
    [AVUser requestMobilePhoneVerify:_userPhone.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        
        if (!succeeded) {
            weakSelf.codeBtn.enabled = YES;
//            weakSelf.displayLink.paused = YES;
//            [weakSelf.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            [weakSelf showError:error];
        }

    }];
}
- (void)showError:(NSError *)error{
    if (error.code==213) {
        
        [self.view showTips:@"该手机号暂未注册" withState:TYKYHUDModeFail complete:nil];
        return ;
    }
    if (error.code==601) {
        
        [self.view showTips:error.userInfo[@"error"] withState:TYKYHUDModeFail complete:nil];
        return ;
    }
    [self.view showTips:@"获取验证码失败,请重试" withState:TYKYHUDModeFail complete:nil];
}
//手机号验证
- (void)verityUserPhone{
    WeakSelf;
    [self.view showHUD:@"正在验证..."];

    [AVUser verifyMobilePhone:_emsCode.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];

        if (!succeeded) {
            
            [weakSelf.view showTips:@"验证失败,请重试" withState:TYKYHUDModeFail complete:nil];
            return;
        }
        [weakSelf.view showTips:@"验证成功" withState:TYKYHUDModeSuccess complete:^{
            [weakSelf backToPreVC];
        }];

    }];
}
//修改密码
- (void)modityUserPsw{
    if (!_userPhone.hasText) {
        [self.view showTips:_userPhone.placeholder withState:TYKYHUDModeWarning complete:nil];
        
        return;
    }
    if (![CTTool isValidateMobile:_userPhone.text]) {
        [self.view showTips:@"请输入正确的手机号码" withState:TYKYHUDModeWarning complete:nil];
        
        return;
    }
    if (!_emsCode.hasText) {
        [self.view showTips:_emsCode.placeholder withState:TYKYHUDModeWarning complete:nil];
        
        return;
    }
    if (!_nPsw.hasText) {
        [self.view showTips:_nPsw.placeholder withState:TYKYHUDModeWarning complete:nil];
        
        return;
    }
    [self.view showHUD:@"正在修改..."];
    WeakSelf;
    [AVUser resetPasswordWithSmsCode:_emsCode.text newPassword:_nPsw.text block:^(BOOL succeeded, NSError *error) {
        [weakSelf.view removeHUD];
        if (succeeded) {
            [weakSelf.view showTips:@"密码修改成功" withState:TYKYHUDModeSuccess complete:^{
                [weakSelf backToPreVC];
            }];
            
        } else {
            if (error.code==603) {
                
                [self.view showTips:@"验证码错误" withState:TYKYHUDModeFail complete:nil];
                return ;
            }
            [weakSelf.view showTips:@"密码修改失败" withState:TYKYHUDModeFail complete:nil];
            
        }
    }];

}
- (void)backToPreVC{
    if (self.showModal == RegisterVerityUserPhoneModal) {
        [UIAlertController alertWithTitle:@"温馨提示" message:@"您未完成手机号验证，确定退出?" cancelButtonTitle:@"继续验证" otherButtonTitles:@[@"退出"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                POPVC;
            }
        }];
        return;
    }
    POPVC;
}

//计时功能
//-(void)refreshBtn {
//    
//    if (kCountDown > 1) {
//        self.codeBtn.enabled = NO;
//        kCountDown--;
//        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)kCountDown] forState:UIControlStateNormal];
//        return;
//    }
//    
//    [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//    self.codeBtn.enabled = YES;
//    
//    self.displayLink.paused = YES;
//    [self.displayLink invalidate];
//    self.displayLink = nil;
//    debugLog(@"定时器停止了");
//    kCountDown = 60;
//    
//}
//- (CADisplayLink *)displayLink{
//    if (_displayLink == nil) {
//        _displayLink =[CADisplayLink displayLinkWithTarget:self selector:@selector(refreshBtn)];
//        _displayLink.paused = YES;
//        _displayLink.preferredFramesPerSecond = 60;
//        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        
//    }
//    return _displayLink;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
