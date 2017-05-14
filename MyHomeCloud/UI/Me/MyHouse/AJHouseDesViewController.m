//
//  AJHouseDesViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/14.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDesViewController.h"

@interface AJHouseDesViewController ()

@end

@implementation AJHouseDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加房屋描述";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保存" target:self sel:@selector(saveHouseData)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)saveHouseData{
    NSMutableDictionary *houseDes = [NSMutableDictionary new];
    [houseDes setObject:@"证满五年"      forKey:YEARS_DES];
    [houseDes setObject:@"随时看房"      forKey:WATCH_DES];
    [houseDes setObject:@"精装修"        forKey:DECORATE_DES];

    [self.view showHUD:@"正在保存..."];
    WeakSelf;
   
    [self.houseObj setObject:[CTTool dictionaryToJson:houseDes] forKey:HOUSE_DESCRIBE];
    [self.houseObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];

        if (!succeeded) {
            [weakSelf.view showTips:@"保存失败" withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [weakSelf.view showTips:@"保存成功" withState:TYKYHUDModeSuccess complete:^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
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
