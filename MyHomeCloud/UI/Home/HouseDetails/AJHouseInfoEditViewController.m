//
//  AJHouseInfoEditViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseInfoEditViewController.h"

@interface AJHouseInfoEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *unitText;

@end

@implementation AJHouseInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.detailsModal==SecondModal) {
        _typeName.text = @"总价";
        _unitText.text = @"万元";
        _priceText.placeholder = @"请输入房源总价";
        _priceText.text = self.houseInfo[HOUSE_TOTAL_PRICE];
    }else if (self.detailsModal==LetModal){
        _typeName.text = @"租金";
        _unitText.text = @"元/月";
        _priceText.placeholder = @"请输入房源租金";
        _priceText.text = self.houseInfo[LET_HOUSE_PRICE];

    }else{
        _typeName.text = @"均价";
        _unitText.text = @"元/平";
        _priceText.placeholder = @"请输入楼盘均价";

    }
}
- (IBAction)saveAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!_priceText.hasText) {
        [self.view showTips:_priceText.placeholder withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    AVObject *tempHouse = [self.houseInfo mutableCopy];

    if (self.detailsModal==SecondModal) {
        [tempHouse setObject:_priceText.text forKey:HOUSE_TOTAL_PRICE];
    }else if (self.detailsModal==LetModal){
        [tempHouse setObject:_priceText.text forKey:LET_HOUSE_PRICE];

    }else{

    }
    
    WeakSelf;
    [tempHouse saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            [self.view showTips:@"操作失败，请重试" withState:TYKYHUDModeFail complete:nil];

            return;
        }
        if (self.detailsModal==SecondModal) {
            [weakSelf.houseInfo setObject:_priceText.text forKey:HOUSE_TOTAL_PRICE];
        }else if (self.detailsModal==LetModal){
            [weakSelf.houseInfo setObject:_priceText.text forKey:LET_HOUSE_PRICE];
            
        }else{
            
        }
        [self.view showTips:@"修改成功" withState:TYKYHUDModeSuccess complete:^{
            if ([self.delegate respondsToSelector:@selector(refreshHouseInfo)]) {
                [self.delegate refreshHouseInfo];
            }
            POPVC;
        }];

    }];

}

- (void)updateRecordAndFavoriteData{
    if (self.detailsModal==SecondModal) {
        
        [self updateHouseInfo:SECOND_RECORD houseKey:HOUSE_TOTAL_PRICE];
        [self updateHouseInfo:SECOND_FAVORITE houseKey:HOUSE_TOTAL_PRICE];
        
    }else if (self.detailsModal==LetModal){
        [self updateHouseInfo:LET_RECORD houseKey:HOUSE_TOTAL_PRICE];
        [self updateHouseInfo:LET_FAVORITE houseKey:HOUSE_TOTAL_PRICE];
        
    }else{
        
    }

}
- (void)updateHouseInfo:(NSString *)className houseKey:(NSString *)houseKey{
    
    self.baseQuery.className = className;
    [self.baseQuery whereKey:HOUSE_ID equalTo:self.houseInfo.objectId];
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            AVObject *obj = objects[0];
            [obj setObject:_priceText.text forKey:houseKey];
            [obj saveInBackground];
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
