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
@property (strong, nonatomic) AJReserverDetailsViewController *details;
@end

@implementation AJMyReserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isNewReserver) {
        if (_reserverModal==SecondReserverModal) {
            self.title = @"我的预约(二手房)";

        }else{
            self.title = @"我的预约(租房)";

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
    return [AVUser currentUser].mobilePhoneNumber;
}

- (NSString *)reserverTypeName{
    if (self.reserverModal==SecondReserverModal) {
        return SECOND_HAND_HOUSE;
    }else{
        return LET_HOUSE;
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
    
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJReserverCellModel *model = (AJReserverCellModel *)self.dataArray[indexPath.row];
    
//    self.details.reserverModal = model;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)backToPreVC{
    POPVC;
}
- (AJReserverDetailsViewController *)details{
    if (_details ==nil) {
        _details = [AJReserverDetailsViewController new];
        [self addChildViewController:_details];
    }
    return _details;
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
