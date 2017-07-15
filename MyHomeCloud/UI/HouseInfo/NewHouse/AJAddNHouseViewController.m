//
//  AJAddNHouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJAddNHouseViewController.h"
#import "AJPickViewTextField.h"
#import "AJAddPicturesViewController.h"
#import "CTAutoPositionScrollview.h"

@interface AJAddNHouseViewController ()
@property (weak, nonatomic) IBOutlet CTAutoPositionScrollview *scrView;
@property (weak, nonatomic) IBOutlet UITextField *estateName;
@property (weak, nonatomic) IBOutlet UITextField *estatePrice;
@property (weak, nonatomic) IBOutlet UITextField *estateAddress;
@property (weak, nonatomic) IBOutlet UITextField *developName;
@property (weak, nonatomic) IBOutlet UITextField *saleLicense;
@property (weak, nonatomic) IBOutlet UITextField *estateServiceName;
@property (weak, nonatomic) IBOutlet UITextField *plotRatio;
@property (weak, nonatomic) IBOutlet UITextField *greenRatio;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *openTime;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *estateType;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *estateDiscribe;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *estateYears;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *buildingType;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *handTime;
@property (weak, nonatomic) IBOutlet UITextField *parking_HouseNum;

@property (weak, nonatomic) IBOutlet UITextField *parking_CarNum;
@property (weak, nonatomic) IBOutlet UITextField *totalHouseNum;

@property (strong, nonatomic) AVObject *houseData;//新楼盘信息

@end

@implementation AJAddNHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"添加新楼盘";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"下一步" target:self sel:@selector(nextAction)]];

}
- (void)nextAction{
    [self.view endEditing:YES];
    if (!_estateName.hasText) {
        [self.view showTips:_estateName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:HOUSE_ESTATE_NAME];
    
    if (!_estatePrice.hasText) {
        [self.view showTips:_estatePrice.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:HOUSE_UNIT_PRICE];

    if (!_estateAddress.hasText) {
        [self.view showTips:_estateAddress.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_ADDRESS];

    if (!_openTime.hasText) {
        [self.view showTips:_openTime.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_OPENTIME];

    if (!_handTime.hasText) {
        [self.view showTips:_handTime.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_HANDTIME];

    if (!_estateType.hasText) {
        [self.view showTips:_estateType.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_TYPE];

    if (!_estateDiscribe.hasText) {
        [self.view showTips:_estateDiscribe.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:HOUSE_DISCRIBE];

    if (!_developName.hasText) {
        [self.view showTips:_developName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:HOUSE_DEVELOPER];

    if (!_saleLicense.hasText) {
        [self.view showTips:_saleLicense.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_SALE_LICENCE];

    if (!_estateYears.hasText) {
        [self.view showTips:_estateYears.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_YEARS];

    if (!_estateServiceName.hasText) {
        [self.view showTips:_estateServiceName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_SERVICE_NAME];

    if (!_buildingType.hasText) {
        [self.view showTips:_buildingType.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:BUIDING_TYPE];

    if (!_parking_HouseNum.hasText||!_parking_CarNum.hasText) {
        [self.view showTips:@"请输入车位配比" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    NSString *parkRatio = [NSString stringWithFormat:@"%@:%@",_parking_HouseNum.text,_parking_CarNum.text];
    [self.houseData setObject:parkRatio forKey:PARKINGNUMBER];

    if (!_totalHouseNum.hasText) {
        [self.view showTips:_totalHouseNum.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_TOTALHOUSE];
    
    if (!_plotRatio.hasText) {
        [self.view showTips:_plotRatio.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_PLOTRATIO];

    if (!_greenRatio.hasText) {
        [self.view showTips:_greenRatio.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [self.houseData setObject:_estateName.text forKey:ESTATE_GREENBELT];

    AJAddPicturesViewController *add = [AJAddPicturesViewController new];
    add.houseInfo  = self.houseData;
    add.isEditModal = YES;
    APP_PUSH(add);
}

- (AVObject *)houseData{
    if (_houseData ==nil) {
        _houseData = [AVObject objectWithClassName:N_HOUSE];
        
        [_houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];
        
    }
    return _houseData;
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
