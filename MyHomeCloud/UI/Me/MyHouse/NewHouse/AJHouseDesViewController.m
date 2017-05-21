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
    self.title = @"房屋详情完善";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保存" target:self sel:@selector(saveHouseData)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)saveHouseData{
    NSMutableDictionary *houseDes = [NSMutableDictionary new];
    [houseDes setObject:@"证满五年"      forKey:YEARS_DES];
    [houseDes setObject:@"随时看房"      forKey:WATCH_DES];
    [houseDes setObject:@"精装修"        forKey:DECORATE_DES];
    [self.houseObj setObject:houseDes forKey:HOUSE_DESCRIBE];

    
    //缩略图
    //    if (imgFile) {
    //        [houseData setObject:imgFile.url                 forKey:HOUSE_THUMB];
    //        [houseData setObject:@[imgFile.objectId]         forKey:HOUSE_FILE_ID];
    //
    //    }
    
    //先上传图片
    //    [house setObject:@[@""]     forKey:HOUSE_PICTURE];
    //    [houseData setObject:@"一单元"           forKey:HOUSE_UNIT];
    //    [houseData setObject:@"1101"            forKey:HOUSE_NUMBER];
    
    [self.view showHUD:@"正在保存..."];
    WeakSelf;

    [self.houseObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];

        if (!succeeded) {
            [weakSelf.view showTips:@"保存失败" withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [weakSelf.view showTips:@"保存成功" withState:TYKYHUDModeSuccess complete:^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewHouseNotification object:nil];
                
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
