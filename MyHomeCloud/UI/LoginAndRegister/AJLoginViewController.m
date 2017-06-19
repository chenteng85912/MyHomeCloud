

#import "AJLoginViewController.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AJLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIButton *headLogBtn;
@property (weak, nonatomic) IBOutlet UIButton *headRegBtn;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTextField;

@end

NSString *const LOGIN_SUCCESS = @"登录成功";
NSString *const LOGIN_FAIL = @"登录失败";
NSString *const USER_ONLINE = @"该用户已在别处登录";

@implementation AJLoginViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *resultStr = [textField.text stringByAppendingString:string];
    [self initUserPhoneShowModal:string];
    if (textField==self.userNameTF&&resultStr.length>13) {
        [textField resignFirstResponder];
        [self.view showTips:@"手机号码为11位数字" withState:TYKYHUDModeWarning complete:nil];
        return NO;
        
    }
    if ([string isEqualToString:@"\n"]) {
       
        [self loginAction:nil];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    _pswTF.text = nil;
    return YES;
}
#pragma mark - event response
//登陆
- (IBAction)loginAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (!self.userNameTF.hasText) {
       [self.view showTips:self.userNameTF.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (![CTTool isValidateMobile:[self.userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        [self.view showTips:@"请输入正确的手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.pswTF.hasText) {
       [self.view showTips:self.pswTF.placeholder  withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    
    if (_headRegBtn.selected) {
        if (!self.confirmPswTextField.hasText) {
            [self.view showTips:self.confirmPswTextField.placeholder  withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        if (![_confirmPswTextField.text isEqualToString:_pswTF.text]) {
            [self.view showTips:@"两次密码不一致，请确认您输入的密码"  withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [self goRegisterAction];
    }else{
        [self goLoginAction];
    }
    
}
-(void)goRegisterAction{
    [CTTool showKeyWindowHUD:@"正在注册..."];
    AVUser *user = [AVUser user];
    user.username = _userNameTF.text;
    user.password =  _pswTF.text;
    user.mobilePhoneNumber = _userNameTF.text;
    
    WeakSelf;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [CTTool removeKeyWindowHUD];

        if (succeeded) {
            [[UIApplication sharedApplication].keyWindow showTips:@"注册成功" withState:TYKYHUDModeSuccess complete:^{
                weakSelf.pswTF.text = nil;
                weakSelf.confirmPswTextField.text = nil;
                [weakSelf findPswAction:weakSelf.headLogBtn];
            }];
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            if (error.code==214) {
                [[UIApplication sharedApplication].keyWindow showTips:@"该用户已注册" withState:TYKYHUDModeFail complete:nil];
            }else{
                [[UIApplication sharedApplication].keyWindow showTips:@"注册失败" withState:TYKYHUDModeFail complete:nil];

            }
        }
    }];
}
- (void)goLoginAction{
    [CTTool showKeyWindowHUD:@"正在登录..."];

    [AVUser logInWithUsernameInBackground:[_userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] password:self.pswTF.text block:^(AVUser *user, NSError *error) {
        [CTTool removeKeyWindowHUD];
        [MyUserDefaults setObject:self.userNameTF.text forKey:USER_NAME];
        if (user) {
            //本地uuid
            NSString *luuid = [[NSUUID UUID] UUIDString];
            
            NSInteger state = [[AVUser currentUser][USER_LOGIN_STATE] integerValue];
            NSString *uuid = [AVUser currentUser][USER_UUID];
            
            //用户已经登录
            if (state>0&&![uuid isEqualToString:luuid]) {
                [AVUser logOut];
                [[UIApplication sharedApplication].keyWindow showTips:USER_ONLINE withState:TYKYHUDModeFail complete:nil];
                return;
            }
            //登录成功
            [[AVUser currentUser] setObject:@1 forKey:USER_LOGIN_STATE];
            [[AVUser currentUser] setObject:luuid forKey:USER_UUID];
            
            [[AVUser currentUser] saveInBackground];
            [[UIApplication sharedApplication].keyWindow showTips:LOGIN_SUCCESS withState:TYKYHUDModeSuccess complete:^{
                [self loginSuccess];
            }];
            return;
        }
        if (error.code==210) {
            [[UIApplication sharedApplication].keyWindow showTips:@"密码错误" withState:TYKYHUDModeFail complete:nil];
            return;
        }else if (error.code==211) {
            [[UIApplication sharedApplication].keyWindow showTips:@"该用户名不存在" withState:TYKYHUDModeFail complete:nil];
            return;
        }else if (error.code==1) {
            [[UIApplication sharedApplication].keyWindow showTips:@"登录失败次数超过限制，请稍候再试，或者通过忘记密码重设密码" withState:TYKYHUDModeFail complete:^{
                
            }];
        }else{
            [[UIApplication sharedApplication].keyWindow showTips:@"网络错误，请重试" withState:TYKYHUDModeFail complete:nil];
            
        }
    }];

}
- (void)loginSuccess{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_backBlock) {
            _backBlock();
        }
    }];
}
//找回密码
- (IBAction)findPswAction:(UIButton *)sender {
    if (sender.tag==2) {
       
    }else if (sender.tag==3) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (sender.selected) {
            return;
        }
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        sender.selected = YES;
        if (sender.tag==0) {
           
            _headRegBtn.selected = NO;
            _headRegBtn.titleLabel.font = [UIFont systemFontOfSize:16];

            [UIView animateWithDuration:0.3 animations:^{
                _logBtn.center = CGPointMake(dWidth/2, 302.5);
                [_logBtn setTitle:@"登录" forState:UIControlStateNormal];

            }];
        }else{
            _headLogBtn.selected = NO;
            _headLogBtn.titleLabel.font = [UIFont systemFontOfSize:16];

            [UIView animateWithDuration:0.3 animations:^{
                _logBtn.center = CGPointMake(dWidth/2, 362.5);
                [_logBtn setTitle:@"注册" forState:UIControlStateNormal];
                
            }];
          
            
        }
      
    }
    
}
//添加或者删除空格
- (void)initUserPhoneShowModal:(NSString *)inputStr{
    //后退
    if ([inputStr isEqualToString:@""]) {
        if (_userNameTF.text.length==5||_userNameTF.text.length==10) {
            _userNameTF.text = [_userNameTF.text substringToIndex:_userNameTF.text.length-1];
            
        }
    }else{
        if (_userNameTF.text.length==3||_userNameTF.text.length==8) {
            _userNameTF.text = [_userNameTF.text stringByAppendingString:@" "];

        }
    }
}
#pragma mark - private methods
- (void)initUI{
    
    self.title = @"登录";
    self.headImg.image = [CTTool iconImage];
    NSString *userName = [MyUserDefaults objectForKey:USER_NAME];
    if (userName) {
        self.userNameTF.text = userName;
    }
}

#pragma mark - getters and setters

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
