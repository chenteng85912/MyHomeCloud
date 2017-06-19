//
//  AJReserverDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJReserverDetailsViewController.h"
#import "AJEstateDetailsViewController.h"
#import "AJReserverCellModel.h"
#import "AJMyReserverViewController.h"

@interface AJReserverDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceType;
@property (weak, nonatomic) IBOutlet UILabel *housePrice;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaage;
@property (weak, nonatomic) IBOutlet UILabel *reserverTime;
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *agenterName;
@property (weak, nonatomic) IBOutlet UILabel *agenterPhone;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *reserverBtn;

@end

@implementation AJReserverDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)refreshView{
    _housePrice.text = _reserverModal.housePrice;
    _priceType.text = _reserverModal.houseType;
    _houseAreaage.text = _reserverModal.houseAreaage;
    _houseName.text = _reserverModal.houseName;
    _agenterName.text = _reserverModal.agenterName;
    _agenterPhone.text = _reserverModal.agenterPhone;
    _userName.text = _reserverModal.rUserName;
    _userPhone.text = _reserverModal.rUserPhone;
    _reserverTime.text = _reserverModal.rTime;
    _state.text = _reserverModal.stateStr;
    _state.backgroundColor = _reserverModal.stateColor;
    
    if (_reserverModal.state.integerValue>1) {
        _reserverBtn.enabled = NO;
        _reserverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }else{
        _reserverBtn.enabled = YES;
        _reserverBtn.backgroundColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:0 alpha:1];

    }
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag==0) {
        AJEstateDetailsViewController *estate = [AJEstateDetailsViewController new];
        estate.title = _houseName.text;
        if (_rModal==SecondReserverModal) {
            estate.detailsModal = SecondModal;
            
        }else{
            estate.detailsModal = LetModal;

        }
        estate.isFromReserver = YES;
        estate.houseInfo = _reserverModal.objectData;
        APP_PUSH(estate);
        [self hiddenView];

    }else if (sender.tag==1){
       
        WeakSelf;
        [UIAlertController alertWithTitle:@"温馨提示" message:@"确定取消该预约？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                //取消预约
                [weakSelf.reserverModal.objectData setObject:@"2" forKey:RESERVER_STATE];
                [weakSelf.reserverModal.objectData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!succeeded) {
                        [weakSelf.view showTips:@"取消预约失败" withState:TYKYHUDModeFail complete:nil];

                        return;
                    }
                    [weakSelf.view showTips:@"取消成功" withState:TYKYHUDModeSuccess complete:^{
                        
                        [self hiddenView];

                        [weakSelf.reserverModal calculateSizeConstrainedToSize];
                        AJMyReserverViewController *myReserver = (AJMyReserverViewController *)self.parentViewController;
                        [myReserver loadDataSuccess];
                    }];
                    
                }];
            }
        }];
        
    }else{
        [self hiddenView];
        
    }
}
- (void)hiddenView{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        
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
