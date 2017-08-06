//
//  AJMyReserverViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJMyReserverViewController.h"
#import "AJReserverCellModel.h"
#import "AJReserverTableViewCell.h"
#import "AJReserverDetailsViewController.h"

@interface AJMyReserverViewController ()

@end

@implementation AJMyReserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isNewReserver) {
        if (_reserverModal==SecondReserverModal) {
            self.title = @"我的预约(二手房)";

        }else  if (_reserverModal==LetReserverModal){
            self.title = @"我的预约(租房)";

        }else{
            self.title = @"我的预约(新房)";

        }

        UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [left setImage:LOADIMAGE(@"back") forState:UIControlStateNormal];
        left.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
        [left addTarget:self action:@selector(backToPreVC) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.tableView reloadData];
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
        return USER_RESERVER;
    
}
- (NSString *)requestKeyName{
#if AJCLOUDADMIN
    return nil;
    
#else
    return [AVUser currentUser].mobilePhoneNumber;
    
#endif
}

- (NSString *)reserverTypeName{
    if (self.reserverModal==SecondReserverModal) {
        return SECOND_HAND_HOUSE;
    }else if (self.reserverModal==LetReserverModal){
        return LET_HOUSE;
    }else{
        return N_HOUSE;
    }
}
- (BOOL)canDeleteCell{
    
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJReserverTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJReserverCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
    [self.tableView reloadData];
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AJReserverCellModel *model = (AJReserverCellModel *)self.dataArray[indexPath.row];
    
    AJReserverDetailsViewController *details = [AJReserverDetailsViewController new];
    details.rModal = self.reserverModal;
    details.reserverModal = model;
    details.isFlip = YES;
    
    [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
    [self.navigationController pushViewController:details animated:NO];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)backToPreVC{
    if (_isNewReserver) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        POPVC;

    }
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
