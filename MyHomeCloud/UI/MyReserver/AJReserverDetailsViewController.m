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
#import "AJHouseInfoViewController.h"

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
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *houseType;

@end

@implementation AJReserverDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    
#if AJCLOUDADMIN
    _reserverBtn.hidden = NO;
    _cancelBtn.hidden = NO;
    
#endif
    [self refreshView];
}
- (void)refreshView{
    _housePrice.text = _reserverModal.housePrice;
    _priceType.text = _reserverModal.pricType;
    _houseAreaage.text = _reserverModal.houseAreaage;
    _houseName.text = _reserverModal.houseName;
    _agenterName.text = _reserverModal.agenterName;
    _agenterPhone.text = _reserverModal.agenterPhone;
    _userName.text = _reserverModal.rUserName;
    _userPhone.text = _reserverModal.rUserPhone;
    _reserverTime.text = _reserverModal.rTime;
    _state.text = _reserverModal.stateStr;
    _state.backgroundColor = _reserverModal.stateColor;
    if (self.rModal==NReserverModal) {
        _houseType.text = @"楼盘名称";
        _houseAreaage.text = @"-";
        
    }
    if (_reserverModal.state.integerValue==0) {
        _reserverBtn.enabled = YES;
        _reserverBtn.backgroundColor = [UIColor colorWithRed:0 green:128.0/255.0 blue:0 alpha:1];
        _cancelBtn.enabled = YES;
        _cancelBtn.backgroundColor = [UIColor darkGrayColor];
       
    }else if (_reserverModal.state.integerValue==1) {
        _cancelBtn.enabled = YES;
        _cancelBtn.backgroundColor = [UIColor darkGrayColor];

        _reserverBtn.enabled = NO;
        _reserverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }else{
        _cancelBtn.enabled = NO;
        _cancelBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _reserverBtn.enabled = NO;
        _reserverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag==0) {
       
        if (_rModal!=NReserverModal) {
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
        }else{
            //楼盘 跳转到楼盘详情
            AJHouseInfoViewController *details = [AJHouseInfoViewController new];
            details.detailsModal = NModal;
            details.showModal = SearchHouseModal;
            details.searchKey = _reserverModal.objectData[HOUSE_AREA];
            details.houseId = _reserverModal.objectData[HOUSE_ID];
            
            APP_PUSH(details);
        }
       

    }else if (sender.tag==1){
        //确认预约
        [self changeReserverStateAction:@"1"];

        
    }else if (sender.tag==2){
        [self changeReserverStateAction:@"2"];
    }else{
        [CTTool takePhoneNumber:_agenterPhone.text];
    }
}

- (void)changeReserverStateAction:(NSString *)state{
    WeakSelf;
    NSString *msg;
    if (state.integerValue==1) {
        msg = @"确定确认该预约？";
    }else{
        msg = @"确定取消该预约？";

    }
    [UIAlertController alertWithTitle:@"温馨提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            //取消预约
            [weakSelf.reserverModal.objectData setObject:state forKey:RESERVER_STATE];
            [weakSelf.view showHUD:nil];
            [weakSelf.reserverModal.objectData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                if (!succeeded) {
                    [weakSelf.view showTips:@"操作失败,请重试" withState:TYKYHUDModeFail complete:nil];
                    
                    return;
                }
                [weakSelf.view showTips:@"操作成功" withState:TYKYHUDModeSuccess complete:^{
                    
                    [weakSelf.reserverModal calculateSizeConstrainedToSize];
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
                
            }];
        }
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
