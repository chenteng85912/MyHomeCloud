//
//  AJUserInclinationViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUserInclinationViewController.h"
#import "AJInclilnationModel.h"
#import "AJInclinationTableViewCell.h"

@interface AJUserInclinationViewController ()

@end

@implementation AJUserInclinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.inclinationModal==SecondInclinationModal) {
        self.title = @"我的意向(二手房)";
    }else if (self.inclinationModal==LetInclinationModal){
        self.title = @"我的意向(租房)";
    }else{
        self.title = @"我的意向(新房)";

    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    
    return YES;
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return UESR_INCLINATION;
    
}
- (NSString *)requestKeyName{
#if AJCLOUDADMIN
    return nil;
    
#else
    return [AVUser currentUser].mobilePhoneNumber;
    
#endif
}

- (NSString *)inclinationTypeName{
    if (self.inclinationModal==SecondInclinationModal) {
        return SECOND_HAND_HOUSE;
    }else if (self.inclinationModal==LetInclinationModal){
        return LET_HOUSE;
    }else{
        return N_HOUSE;
    }
}
- (BOOL)canDeleteCell{
    
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJInclinationTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJInclilnationModel class]);
}
//- (void)loadDataSuccess{
//    [self.view removeHUD];
//    
//}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
