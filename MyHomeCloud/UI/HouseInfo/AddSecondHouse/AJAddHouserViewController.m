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
#import "AJTagsViewController.h"

@interface AJAddHouserViewController ()<AJAllHouseListViewControllerDelegate,AJTagsViewControllerDelegate>

@property (strong, nonatomic) AVObject *houseData;//新房源信息
@property (strong, nonatomic)AJTagsViewController *tagVC;

@property (weak, nonatomic) IBOutlet UIView *letView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *houseBaseInfo;

@property (weak, nonatomic) IBOutlet UITextField *houseDesInfo;
@property (weak, nonatomic) IBOutlet UITextField *agenterPhone;
@property (weak, nonatomic) IBOutlet UITextField *houseName;
@property (weak, nonatomic) IBOutlet UITextField *houseAreaage;
@property (weak, nonatomic) IBOutlet UITextField *houseTotal;
@property (weak, nonatomic) IBOutlet UITextField *agenterName;
@property (weak, nonatomic) IBOutlet UITextField *letHousePrice;

@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseRooms;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDirection;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseFloor;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseTotalFloor;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseDescribe;


@end

@implementation AJAddHouserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_addModal==SecondHouseModal) {
        self.title = @"添加二手房源";
        _letView.hidden = YES;
    }else{
        self.title = @"添加出租房源";
        _secondView.hidden = YES;
    }
    _agenterName.text = [AVUser currentUser][USER_NICKNAME];
    _agenterPhone.text = [AVUser currentUser].mobilePhoneNumber;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"下一步" target:self sel:@selector(addHomeDes)]];
}

//保存房源
- (AVObject *)creatHouseInfo{

    if (_addModal==SecondHouseModal) {
        //总价
        [self.houseData setObject:_houseTotal.text               forKey:HOUSE_TOTAL_PRICE];
        //房屋单价
        NSInteger unitPrice = _houseTotal.text.integerValue*10000/_houseAreaage.text.integerValue;
        [self.houseData setObject:[NSString stringWithFormat:@"%ld",(long)unitPrice]        forKey:HOUSE_UNIT_PRICE];

    }else if (_addModal==LetHouseModal){
        //租金
        [self.houseData setObject:_letHousePrice.text               forKey:LET_HOUSE_PRICE];

    }else{
        [self.houseData setObject:@"14000"        forKey:HOUSE_UNIT_PRICE];

    }
    
    [self.houseData setObject:_houseTotalFloor.text          forKey:HOUSE_TOTAL_FLOOR];
    [self.houseData setObject:_houseName.text                forKey:HOUSE_ESTATE_NAME];
    [self.houseData setObject:_agenterName.text              forKey:AGENTER_NAME];
    [self.houseData setObject:_agenterPhone.text             forKey:AGENTER_PHONE];

    [self.houseData setObject:_houseFloor.text               forKey:HOUSE_FLOOR_NUM];
    [self.houseData setObject:_houseRooms.text               forKey:HOUSE_AMOUNT];
    [self.houseData setObject:_houseAreaage.text             forKey:HOUSE_AREAAGE];
    [self.houseData setObject:_houseDirection.text           forKey:HOUSE_DIRECTION];

    //发布者信息
    [self.houseData setObject:[AVUser currentUser].objectId      forKey:HOUSE_AUTHOR];
    [self.houseData setObject:[AVUser currentUser][HEAD_URL]     forKey:HEAD_URL];

    return self.houseData;
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
    if (!_houseDesInfo.hasText) {
        [self.view showTips:_houseDesInfo.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!_agenterName.hasText) {
        [self.view showTips:_agenterName.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!_agenterPhone.hasText) {
        [self.view showTips:_agenterPhone.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (_agenterPhone.text.length!=11) {
        [self.view showTips:@"请输入正确的手机号" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    if (!self.letHousePrice.hasText&&_addModal==LetHouseModal) {
        [self.view showTips:self.letHousePrice.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
   
    AJHouseDesViewController *des = [AJHouseDesViewController new];
    des.houseObj = [self creatHouseInfo];
    
    APP_PUSH(des);
}
#pragma mark -life UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *resultStr = [textField.text stringByAppendingString:string];
    if (textField==_agenterPhone&&resultStr.length>11) {
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag==0) {
        [self.view endEditing:YES];

        AJAllHouseListViewController *houseList = [AJAllHouseListViewController new];
        houseList.delegate = self;
        APP_PUSH(houseList);
        return NO;
    }
    if (textField.tag==8) {
        [self.view endEditing:YES];
        self.tagVC.view.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.tagVC.view.alpha = 1.0;
        }];
      
        return NO;
    }
    return YES;;
}

#pragma mark - AJAllHouseListViewControllerDelegate
- (void)chooseHouseInfo:(AVObject *)houseInfo{
    
    //房源基本信息
    [self.houseData setObject:houseInfo[HOUSE_DEVELOPER]           forKey:HOUSE_DEVELOPER];
    [self.houseData setObject:houseInfo[HOUSE_AREA]                forKey:HOUSE_AREA];
    [self.houseData setObject:houseInfo[HOUSE_YEARS]               forKey:HOUSE_YEARS];
    //小区id
    [self.houseData setObject:houseInfo.objectId               forKey:ESTATE_ID];
    
    //物业费
    [self.houseData setObject:houseInfo[LET_ESTATE_PRICE]                forKey:LET_ESTATE_PRICE];
    
    //经度纬度
    [self.houseData setObject:houseInfo[HOUSE_LATITUDE]                forKey:HOUSE_LATITUDE];
    [self.houseData setObject:houseInfo[HOUSE_LONGITUDE]                forKey:HOUSE_LONGITUDE];

    _houseName.text = houseInfo[HOUSE_ESTATE_NAME];
    _houseBaseInfo.text = [NSString stringWithFormat:@"%@ %@ %@",houseInfo[HOUSE_AREA],houseInfo[HOUSE_DEVELOPER],houseInfo[HOUSE_YEARS]];
    
}
#pragma mark - AJTagsViewControllerDelegate
- (void)confirmTags:(NSArray *)tagArray{
    [self.houseData setObject:tagArray   forKey:HOUSE_TAGS];
    NSString *desStr = @"";
    for (NSString *str in tagArray) {
        desStr = [NSString stringWithFormat:@"%@ %@",desStr,str];
    }
    _houseDesInfo.text = [desStr substringFromIndex:1];

}
- (AVObject *)houseData{
    if (_houseData ==nil) {
        if (_addModal==SecondHouseModal) {
            _houseData = [AVObject objectWithClassName:SECOND_HAND_HOUSE];
        }else{
            _houseData = [AVObject objectWithClassName:SECOND_HAND_HOUSE];
        }
        [_houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];

    }
    return _houseData;
}
- (AJTagsViewController *)tagVC{
    if (_tagVC==nil) {
        _tagVC = [AJTagsViewController new];
        _tagVC.delegate = self;
        _tagVC.addModal = self.addModal;
        _tagVC.view.frame = self.view.bounds;
        [self addChildViewController:_tagVC];
        [self.view addSubview:_tagVC.view];
    }
    return _tagVC;
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
