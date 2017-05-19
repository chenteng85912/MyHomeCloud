

#import "AJLoginViewController.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AJLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

//NSString *const USERNAME = @"USERNAME";
//NSString *const PASSWORD = @"PASSWORD";
//
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
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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

#pragma mark - event response
//登陆
- (IBAction)loginAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (!self.userNameTF.hasText) {
       [self.view showTips:@"请输入手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (![CTTool isValidateMobile:[self.userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        [self.view showTips:@"请输入正确的手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.pswTF.hasText) {
       [self.view showTips:@"请输入密码"  withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    
    [CTTool showKeyWindowHUD:@"正在登录..."];
    [AVUser logInWithUsernameInBackground:[_userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] password:self.pswTF.text block:^(AVUser *user, NSError *error) {
        [CTTool removeKeyWindowHUD];
        [MyUserDefaults setObject:self.userNameTF.text forKey:USER_NAME];
        if (user) {
            //用户已经登录
            if ([[AVUser currentUser][USER_LOGIN_STATE] integerValue]>0) {
                [self.view showTips:USER_ONLINE withState:TYKYHUDModeSuccess complete:nil];
                return;
            }
            //登录成功
            [[AVUser currentUser] setObject:@1 forKey:USER_LOGIN_STATE];
            [[AVUser currentUser] saveInBackground];
            [self.view showTips:LOGIN_SUCCESS withState:TYKYHUDModeSuccess complete:^{
                [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootVC];
            }];
            return;
        }
        if (error.code==210) {
            [self.view showTips:@"密码错误" withState:TYKYHUDModeFail complete:nil];
            return;
        }
        if (error.code==211) {
            [self.view showTips:@"该用户名不存在" withState:TYKYHUDModeFail complete:nil];
            return;
        }
        if (error.code==1) {
            [self.view showTips:@"登录失败次数超过限制，请稍候再试，或者通过忘记密码重设密码" withState:TYKYHUDModeFail complete:^{
                
            }];
        }else{
            [self.view showTips:@"网络错误，请重试" withState:TYKYHUDModeFail complete:nil];
            
        }
        
    }];
}

//找回密码
- (IBAction)findPswAction:(UIButton *)sender {
    
    
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
    self.headImg.image = [CTTool iconImage];
    NSString *userName = [MyUserDefaults objectForKey:USER_NAME];
    if (userName) {
        self.userNameTF.text = userName;
    }
}
- (void)backToPreVC{
    if (![AVUser currentUser]) {
        
        return;
    }
}
#pragma mark - getters and setters

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
