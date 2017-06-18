//
//  AJNewReserverViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewReserverViewController.h"
#import "AJPickViewTextField.h"

@interface AJNewReserverViewController ()
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *agenterName;
@property (weak, nonatomic) IBOutlet UILabel *agenterPhone;
@property (weak, nonatomic) IBOutlet UIButton *confirmBut;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *reserverTime;

@end

@implementation AJNewReserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"预约看房";
    
    _houseName.text = _houseInfo[HOUSE_ESTATE_NAME];
    _agenterName.text = _houseInfo[AGENTER_NAME];
    _agenterPhone.text = _houseInfo[AGENTER_PHONE];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)confirmAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (sender.tag==1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromParentViewController];

        }];
    }else{
        if (!_userName.hasText) {
            [self.view showTips:_userName.placeholder withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        if (!_userPhone.hasText) {
            [self.view showTips:_userPhone.placeholder withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        if (!_reserverTime.hasText) {
            [self.view showTips:_reserverTime.placeholder withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        
        AVObject *obj = [[AVObject alloc] initWithClassName:USER_RESERVER];
        [obj setObject:_houseName.text      forKey:HOUSE_ESTATE_NAME];
        [obj setObject:_agenterName.text    forKey:AGENTER_NAME];
        [obj setObject:_agenterPhone.text   forKey:AGENTER_PHONE];
        [obj setObject:_userName.text       forKey:RESERVER_NAME];
        [obj setObject:_userPhone.text       forKey:RESERVER_PHONE];
        [obj setObject:_reserverTime.text   forKey:RESERVER_TIME];
        [obj setObject:_houseInfo[ESTATE_ID]   forKey:ESTATE_ID];
        [obj setObject:[AVUser currentUser].mobilePhoneNumber   forKey:USER_PHONE];

        [obj setObject:@"0"                 forKey:RESERVER_STATE];

        if (_reserverModal ==SecondReserverModal) {
            [obj setObject:SECOND_HAND_HOUSE    forKey:RESERVER_TYPE];

        }else{
            [obj setObject:LET_HOUSE            forKey:RESERVER_TYPE];

        }
        
        [self.view showHUD:@"正在提交..."];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.view removeHUD];
            if (!succeeded) {
                [self.view showTips:@"提交预约失败" withState:TYKYHUDModeFail complete:nil];

                return ;
            }
            [self.view showTips:@"提交预约成功" withState:TYKYHUDModeSuccess complete:^{
               
                AJMyReserverViewController *myReserver = [AJMyReserverViewController new];
                myReserver.reserverModal =  _reserverModal;
                myReserver.showModal = ReserverHouseModal;
                myReserver.isNewReserver = YES;
                APP_PUSH(myReserver);
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromParentViewController];
                    _userName.text = nil;
                    _userPhone.text = nil;
                    _reserverTime.text = nil;
                    
                }];
            }];
          
        }];
        
    }
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
