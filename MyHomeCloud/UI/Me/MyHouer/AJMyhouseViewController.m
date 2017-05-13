//
//  AJMyhouseViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJMyhouseViewController.h"
#import "AJNewHouserViewController.h"
#import "AJMyHomeTableViewCell.h"

NSString *const USER_PHONE =  @"userPhone";

@interface AJMyhouseViewController ()

@end

@implementation AJMyhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHouse)];
    self.navigationItem.rightBarButtonItem.tintColor = NavigationBarColor;

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return HOUSER_DATA;
}
- (NSString *)requestKeyName{
    return USER_PHONE;
}

- (BOOL)canDeleteCell{
    return YES;
}
- (NSString *)customeTableViewCellClassName{
    return  NSStringFromClass([AJMyHomeTableViewCell class]);
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    
    AJMyHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJMyHomeTableViewCell class])];
    
    [cell processCellData:model];
    
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)addNewHouse{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[AJNewHouserViewController new]];
    APP_PRESENT(nav);
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
