//
//  AJSendFeecbackViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSendFeecbackViewController.h"

@interface AJSendFeecbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation AJSendFeecbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveBtn.backgroundColor = NavigationBarColor;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *resultStr = [textView.text stringByAppendingString:text];
    if (resultStr.length>0) {
        _tipLabel.hidden = YES;
    }else{
        _tipLabel.hidden = NO;
    }
   
    return YES;
}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}
- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (!_titleField.hasText) {
        [self.view showTips:_titleField.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!_content.hasText) {
        [self.view showTips:_tipLabel.text withState:TYKYHUDModeWarning complete:nil];
        return;
    }

    AVObject *obj = [[AVObject alloc] initWithClassName:USER_FEEDBACK];
    
    [obj setObject:_titleField.text     forKey:FEEDBACK_TITLE];
    [obj setObject:_content.text        forKey:FEEDBACK_CONTENT];
    [obj setObject:@0                   forKey:FEEDBACK_STATE];
    
    [obj setObject:[AVUser currentUser].mobilePhoneNumber   forKey:USER_PHONE];
    [obj setObject:[AVUser currentUser][USER_NICKNAME]      forKey:USER_NAME];

    [self.view showHUD:@"正在提交..."];
    WeakSelf;
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (!succeeded) {
            [weakSelf.view showTips:@"提交失败" withState:TYKYHUDModeFail complete:nil];
            
            return ;
        }
        [weakSelf.view showTips:@"提交成功" withState:TYKYHUDModeSuccess complete:^{
            POPVC;
        }];
        
    }];
        
    
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
