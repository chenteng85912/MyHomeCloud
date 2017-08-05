//
//  AJForgotPswViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/8/5.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJForgotPswViewController.h"

@interface AJForgotPswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userEmail;

@end

@implementation AJForgotPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"重置密码";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!_userEmail.hasText) {
        [self.view showTips:_userEmail.placeholder withState:TYKYHUDModeWarning complete:nil];

        return;
    }
    if (![CTTool validateEmail:_userEmail.text]) {
        [self.view showTips:@"请输入正确的邮箱" withState:TYKYHUDModeWarning complete:nil];

        return;
    }
    [AVUser requestPasswordResetForEmailInBackground:_userEmail.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.view showTips:@"密码重置请求发送成功，请前往邮箱重置密码" withState:TYKYHUDModeSuccess complete:^{
                POPVC;
            }];

        } else {
            [self.view showTips:@"网络错误，请重试" withState:TYKYHUDModeFail complete:nil];

        }
    }];
}
- (IBAction)endingText:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
