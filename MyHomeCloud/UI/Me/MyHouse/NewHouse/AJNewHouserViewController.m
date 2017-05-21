//
//  AJNewHouserViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouserViewController.h"
#import "AJHouseDesViewController.h"
#import "AJPickViewTextField.h"

@interface AJNewHouserViewController ()

@property (strong, nonatomic) AVObject *houseData;
@property (strong, nonatomic) NSArray *houseNameArray;

@property (weak, nonatomic) IBOutlet UILabel *developName;
@property (weak, nonatomic) IBOutlet UILabel *houseYear;
@property (weak, nonatomic) IBOutlet UILabel *houseArea;

@property (weak, nonatomic) IBOutlet UITextField *houseName;
@property (weak, nonatomic) IBOutlet UITextField *houseAreaage;
@property (weak, nonatomic) IBOutlet UITextField *houseTotal;

@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseRooms;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDirection;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseFloor;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDes;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseTotalFloor;


@end

@implementation AJNewHouserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加房源";
    self.houseNameArray = @[@"鼎峰品筑",@"鼎峰尚镜",@"鼎峰卡布斯",@"鼎峰金椅豪园"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"下一步" target:self sel:@selector(addHomeDes)]];
}

//保存房源
- (AVObject *)creatHouseInfo{

    AVObject *houseData = [AVObject objectWithClassName:HOUSE_INFO];
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];

    [houseData setObject:_houseTotalFloor.text          forKey:HOUSE_TOTAL_FLOOR];
    [houseData setObject:_houseName.text      forKey:HOUSE_ESTATE_NAME];
    [houseData setObject:_developName.text      forKey:HOUSE_DEVELOPER];
    [houseData setObject:_houseTotalFloor.text          forKey:HOUSE_BUILD_NUMBER];
    [houseData setObject:_houseFloor.text              forKey:HOUSE_FLOOR_NUM];
    [houseData setObject:_houseRooms.text           forKey:HOUSE_AMOUNT];

    [houseData setObject:_houseArea.text          forKey:HOUSE_AREA];
    [houseData setObject:_houseAreaage.text             forKey:HOUSE_AREAAGE];
    [houseData setObject:_houseTotal.text           forKey:HOUSE_TOTAL_PRICE];
    
    //房屋单价
    NSInteger unitPrice = _houseTotal.text.integerValue/_houseAreaage.text.integerValue;
    [houseData setObject:[NSString stringWithFormat:@"%ld",(long)unitPrice]        forKey:HOUSE_UNIT_PRICE];

    return houseData;
}

- (void)addHomeDes{
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
        return NO;
    }
    return YES;;
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