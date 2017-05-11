

#import "AJLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AJLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end

//NSString *const USERNAME = @"USERNAME";
//NSString *const PASSWORD = @"PASSWORD";
//
//NSString *const LOGIN_SUCCESS = @"登录成功";
//NSString *const LOGIN_FAIL = @"登录失败";

@implementation AJLoginViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    NSString *userName = self.userNameTF.text;
    NSString *psw = self.pswTF.text;
    if ([@"" isEqualToString:[userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
       [self.view showTips:@"请输入手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if ([@"" isEqualToString:[psw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
       [self.view showTips:@"请输入密码"  withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    
//    [CTTool showKeyWindowHUD:@"正在登录..."];
   
}

//找回密码
- (IBAction)findPswAction:(UIButton *)sender {
    
    
}

#pragma mark - private methods
- (void)initUI{
    self.headImg.image = [CTTool iconImage];
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
