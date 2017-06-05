//
//  AJAllHouseListViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJAllHouseListViewController.h"
#import "AJNewHouseTableViewCell.h"
#import "AJNewHouseModel.h"

@interface AJAllHouseListViewController ()

@end

@implementation AJAllHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择小区";
    
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return ALL_HOUSE_INFO;
    
}

- (BOOL)canDeleteCell{
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJNewHouseTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJNewHouseModel class]);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if ([self.delegate respondsToSelector:@selector(chooseHouseInfo:)]) {
        [self.delegate chooseHouseInfo:self.dataArray[indexPath.row].objectData];
    }
    POPVC;

}
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
