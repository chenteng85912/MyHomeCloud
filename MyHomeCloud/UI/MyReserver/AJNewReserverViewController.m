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
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *reserverTime;

@end

@implementation AJNewReserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约看房";
    
    _houseName.text = _houseInfo[HOUSE_ESTATE_NAME];
    _agenterName.text = _houseInfo[AGENTER_NAME];
    _agenterPhone.text = _houseInfo[AGENTER_PHONE];
  
    _userPhone.text = [AVUser currentUser].mobilePhoneNumber;

    if (self.reserverModal == NReserverModal) {
        _houseType.text = @"楼盘名称";
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *resultStr = [textField.text stringByAppendingString:string];
    if (textField==_userPhone&&resultStr.length>11) {
        [textField resignFirstResponder];
        [self.view showTips:@"手机号码为11位数字" withState:TYKYHUDModeWarning complete:nil];
        return NO;
        
    }
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    return NO;
    }
    return YES;
}

- (IBAction)confirmAction:(UIButton *)sender {
    [self.view endEditing:YES];


    if (!_userName.hasText) {
        [self.view showTips:_userName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!_userPhone.hasText) {
        [self.view showTips:_userPhone.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (_userPhone.text.length!=11) {
        [self.view showTips:@"请输入正确的手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!_reserverTime.hasText) {
        [self.view showTips:_reserverTime.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    
    AVObject *obj = [[AVObject alloc] initWithClassName:USER_RESERVER];
    
    [obj setObject:_houseInfo[HOUSE_AMOUNT]      forKey:HOUSE_AMOUNT];
    [obj setObject:_houseInfo[HOUSE_AREAAGE]     forKey:HOUSE_AREAAGE];
    [obj setObject:_houseInfo[ESTATE_ID]         forKey:ESTATE_ID];

    [obj setObject:_houseName.text      forKey:HOUSE_ESTATE_NAME];
    [obj setObject:_agenterName.text    forKey:AGENTER_NAME];
    [obj setObject:_agenterPhone.text   forKey:AGENTER_PHONE];
    [obj setObject:_userName.text       forKey:RESERVER_NAME];
    [obj setObject:_userPhone.text      forKey:RESERVER_PHONE];
    [obj setObject:_reserverTime.text   forKey:RESERVER_TIME];
    [obj setObject:[AVUser currentUser].mobilePhoneNumber   forKey:USER_PHONE];
    [obj setObject:@"0"                 forKey:RESERVER_STATE];

    if (_reserverModal == SecondReserverModal) {
        [obj setObject:SECOND_HAND_HOUSE    forKey:RESERVER_TYPE];
        [obj setObject:_houseInfo[HOUSE_TOTAL_PRICE]         forKey:HOUSE_TOTAL_PRICE];

    }else if (_reserverModal == LetReserverModal){
        [obj setObject:LET_HOUSE            forKey:RESERVER_TYPE];
        [obj setObject:_houseInfo[LET_HOUSE_PRICE]         forKey:LET_HOUSE_PRICE];

    }else{
        [obj setObject:N_HOUSE            forKey:RESERVER_TYPE];
        [obj setObject:_houseInfo[HOUSE_AREA]          forKey:HOUSE_AREA];
        [obj setObject:_houseInfo[HOUSE_UNIT_PRICE]         forKey:HOUSE_UNIT_PRICE];

    }
    [obj setObject:_houseInfo.objectId          forKey:HOUSE_ID];

    [KEYWINDOW showHUD:@"正在提交..."];
//    [SVProgressHUD showWithStatus:@"正在提交..."];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [KEYWINDOW removeHUD];
//        [SVProgressHUD dismiss];
        if (!succeeded) {
            [KEYWINDOW showTips:@"提交预约失败" withState:TYKYHUDModeFail complete:nil];

            return ;
        }
        [KEYWINDOW showTips:@"提交预约成功" withState:TYKYHUDModeSuccess complete:^{
           
            AJMyReserverViewController *myReserver = [AJMyReserverViewController new];
            myReserver.isPreview = YES;
            myReserver.reserverModal =  _reserverModal;
            myReserver.showModal = ReserverHouseModal;
            myReserver.isNewReserver = YES;
            APP_PUSH(myReserver);
            
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
