//
//  AJNewHouserViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJAddHouserViewController.h"
#import "AJHouseDesViewController.h"
#import "AJPickViewTextField.h"
#import "AJAllHouseListViewController.h"

@interface AJAddHouserViewController ()<AJAllHouseListViewControllerDelegate>

@property (strong, nonatomic) AVObject *houseData;
@property (strong, nonatomic) AVObject *houseInfoData;

@property (weak, nonatomic) IBOutlet UILabel *houseDesInfo;

@property (weak, nonatomic) IBOutlet UILabel *houseBaseInfo;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDescribe;

@property (weak, nonatomic) IBOutlet UITextField *houseName;
@property (weak, nonatomic) IBOutlet UITextField *houseAreaage;
@property (weak, nonatomic) IBOutlet UITextField *houseTotal;
@property (weak, nonatomic) IBOutlet UIView *letView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseRooms;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDirection;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseFloor;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDes;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseTotalFloor;
@property (weak, nonatomic) IBOutlet UITextField *letHousePrice;

@end

@implementation AJAddHouserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_addModal==SecondHouseModal) {
        self.title = @"添加二手房源";
        _letView.hidden = YES;
    }else if (_addModal==LetHouseModal){
        self.title = @"添加出租房源";
        _secondView.hidden = YES;
    }else{
        self.title = @"添加新楼盘";

    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"下一步" target:self sel:@selector(addHomeDes)]];
}

//保存房源
- (AVObject *)creatHouseInfo{

    AVObject *houseData;
    if (_addModal==SecondHouseModal) {
        houseData = [AVObject objectWithClassName:SECOND_HAND_HOUSE];
        //总价
        [houseData setObject:_houseTotal.text               forKey:HOUSE_TOTAL_PRICE];
        //房屋单价
        NSInteger unitPrice = _houseTotal.text.integerValue*10000/_houseAreaage.text.integerValue;
        [houseData setObject:[NSString stringWithFormat:@"%ld",(long)unitPrice]        forKey:HOUSE_UNIT_PRICE];

    }else if (_addModal==LetHouseModal){
        houseData = [AVObject objectWithClassName:LET_HOUSE];
        //租金
        [houseData setObject:_letHousePrice.text               forKey:LET_HOUSE_PRICE];

    }else{
        houseData = [AVObject objectWithClassName:NEW_HOUSE];
        [houseData setObject:@"14000"        forKey:HOUSE_UNIT_PRICE];

    }
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];
    
    [houseData setObject:_houseTotalFloor.text          forKey:HOUSE_TOTAL_FLOOR];
    [houseData setObject:_houseName.text                forKey:HOUSE_ESTATE_NAME];
    [houseData setObject:self.houseInfoData[HOUSE_DEVELOPER]              forKey:HOUSE_DEVELOPER];
    [houseData setObject:self.houseInfoData[HOUSE_AREA]                forKey:HOUSE_AREA];
    [houseData setObject:self.houseInfoData[HOUSE_YEARS]                forKey:HOUSE_YEARS];

    [houseData setObject:_houseFloor.text               forKey:HOUSE_FLOOR_NUM];
    [houseData setObject:_houseRooms.text               forKey:HOUSE_AMOUNT];
    [houseData setObject:_houseAreaage.text             forKey:HOUSE_AREAAGE];
    [houseData setObject:_houseDirection.text           forKey:HOUSE_DIRECTION];
    [houseData setObject:_houseDescribe.text            forKey:HOUSE_DESCRIBE];

    //发布者信息
    [houseData setObject:[AVUser currentUser].objectId      forKey:HOUSE_AUTHOR];
    [houseData setObject:[AVUser currentUser][HEAD_URL]     forKey:HEAD_URL];

    return houseData;
}
- (IBAction)completeHouseInfo:(UIButton *)sender {
    [self addHomeDes];
}

- (void)addHomeDes{
    [self.view endEditing:YES];
    if (!self.houseName.hasText) {
        [self.view showTips:self.houseName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.houseAreaage.hasText) {
        [self.view showTips:self.houseAreaage.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.houseRooms.hasText) {
        [self.view showTips:self.houseRooms.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.houseTotal.hasText) {
        [self.view showTips:self.houseTotal.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    AJHouseDesViewController *des = [AJHouseDesViewController new];
    des.houseObj = [self creatHouseInfo];
    
    APP_PUSH(des);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag==0) {
        [self.view endEditing:YES];

        AJAllHouseListViewController *houseList = [AJAllHouseListViewController new];
        houseList.delegate = self;
        APP_PUSH(houseList);
        return NO;
    }
    return YES;;
}

#pragma mark - AJAllHouseListViewControllerDelegate
- (void)chooseHouseInfo:(AVObject *)houseInfo{
    
    self.houseInfoData = houseInfo;
    _houseName.text = houseInfo[HOUSE_ESTATE_NAME];
    _houseBaseInfo.text = [NSString stringWithFormat:@"%@ %@ %@",houseInfo[HOUSE_AREA],houseInfo[HOUSE_DEVELOPER],houseInfo[HOUSE_YEARS]];
    
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
