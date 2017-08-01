//
//  AJFinseHouseViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFindHouseViewController.h"
#import "AJPickViewTextField.h"
#import "AJTagsViewController.h"
#import "AJUserInclinationViewController.h"

@interface AJFindHouseViewController ()<AJTagsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseArea;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *housePrice;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseAreaage;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *letPrice;
@property (weak, nonatomic) IBOutlet AJPickViewTextField *searchType;
@property (weak, nonatomic) IBOutlet UITextField *houseTags;
@property (weak, nonatomic) IBOutlet UILabel *typeName;

@property (weak, nonatomic) IBOutlet AJPickViewTextField *houseRooms;
@property (strong, nonatomic) AJTagsViewController *tagVC;//标签

@property (assign, nonatomic) NSInteger type;//0二手房 1租房 3新房

@end

@implementation AJFindHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.tagVC];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"提 交" target:self sel:@selector(saveAction)]];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag==0) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.tagVC.view.alpha = 1.0;
        }];

        return NO;
    }

    return YES;;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    NSInteger selectIndex;
    if ([_searchType.text isEqualToString:@"租房"]) {
        _typeName.text = @"租金";
        _letPrice.hidden = NO;
        _housePrice.hidden = YES;
        self.tagVC.addModal = LetHouseModal;
        selectIndex = 1;
    }else if ([_searchType.text isEqualToString:@"二手房"]){
        _typeName.text = @"售价";
        _letPrice.hidden = YES;
        _housePrice.hidden = NO;
        self.tagVC.addModal = SecondHouseModal;
        selectIndex = 0;

    }else{
        selectIndex = 2;

    }
    if (_type!=selectIndex) {
        _type = selectIndex;
        _houseTags.text = nil;
        [self.tagVC removeFromParentViewController];
        _tagVC = nil;
        [self addChildViewController:self.tagVC];
    }
    return YES;
}
- (void)confirmTags:(NSArray *)tagArray{
    NSString *desStr = @"";
    for (NSString *str in tagArray) {
        desStr = [NSString stringWithFormat:@"%@ %@",desStr,str];
    }
    _houseTags.text = [desStr substringFromIndex:1];
}
- (void)saveAction{
    [self.view endEditing:YES];

    AVObject *houseData = [AVObject objectWithClassName:UESR_INCLINATION];
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
    
    if (!_searchType.hasText) {
        [self.view showTips:_searchType.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    
    if (!_houseArea.hasText) {
        [self.view showTips:_houseArea.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [houseData setObject:_houseArea.text forKey:HOUSE_AREA];
    
    if (!_houseAreaage.hasText) {
        [self.view showTips:_houseAreaage.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
  
    [houseData setObject:_houseAreaage.text forKey:HOUSE_AREAAGE];
    
    if (_type==0) {
        [houseData setObject:SECOND_HAND_HOUSE forKey:ESTATE_TYPE];
        if (!_housePrice.hasText) {
            [self.view showTips:_housePrice.placeholder withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [houseData setObject:_housePrice.text forKey:HOUSE_TOTAL_PRICE];
    }else if (_type==1){
        [houseData setObject:LET_HOUSE forKey:ESTATE_TYPE];
        if (!_letPrice.hasText) {
            [self.view showTips:_letPrice.placeholder withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [houseData setObject:_letPrice.text forKey:HOUSE_TOTAL_PRICE];
    }else{
        [houseData setObject:N_HOUSE forKey:ESTATE_TYPE];
        
    }
  
    if (!_houseTags.hasText) {
        [self.view showTips:_houseTags.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [houseData setObject:_houseTags.text forKey:HOUSE_TAGS];
    
    if (!_houseRooms.hasText) {
        [self.view showTips:_houseRooms.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    [houseData setObject:_houseRooms.text forKey:HOUSE_AMOUNT];
    
    [KEYWINDOW showHUD:@"正在提交..."];
    [houseData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [KEYWINDOW removeHUD];
        if (!succeeded) {
            [KEYWINDOW showTips:@"提交意向失败" withState:TYKYHUDModeFail complete:nil];
            
            return ;
        }
        [KEYWINDOW showTips:@"提交意向成功" withState:TYKYHUDModeSuccess complete:^{
            _houseTags.text = nil;
            AJUserInclinationViewController *inclination = [AJUserInclinationViewController new];
            inclination.showModal = UserInclinationModal;
            inclination.isPreview = YES;
            if (_type==1) {
                inclination.inclinationModal =  LetInclinationModal;

            }else if (_type==0){
                inclination.inclinationModal =  SecondInclinationModal;

            }else{
                
            }
            inclination.hidesBottomBarWhenPushed = YES;
            
            APP_PUSH(inclination);
            
        }];
        
    }];

}
- (AJTagsViewController *)tagVC{
    if (_tagVC==nil) {
        _tagVC = [AJTagsViewController new];
        _tagVC.delegate = self;
        if (_type==0) {
            _tagVC.addModal = SecondHouseModal;
        }else if (_type==1){
            _tagVC.addModal = LetHouseModal;

        }else{
            
        }
        _tagVC.view.alpha = 0;
        _tagVC.view.frame = self.view.bounds;
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
