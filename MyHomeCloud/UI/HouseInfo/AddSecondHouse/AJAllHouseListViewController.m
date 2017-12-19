//
//  AJAllHouseListViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJAllHouseListViewController.h"
#import "AJHouseInfoTableViewCell.h"
#import "AJNewHouseModel.h"
#import "ChineseTransform.h"

@interface AJAllHouseListViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (copy, nonatomic) NSMutableArray <AJTbViewCellModel *> *tempArray;

@end

@implementation AJAllHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"请选择小区";
    
    if (iOS11) {
        UIView *searchView = [[UIView alloc] initWithFrame:self.searchBar.frame];
        [searchView addSubview:self.searchBar];
        self.navigationItem.titleView = searchView;
        
    }else{
        self.navigationItem.titleView = self.searchBar;
        
    }

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, dWidth, dHeight-NAVBAR_HEIGHT);

}
#pragma mark - AJTbViewProtocol
//- (BOOL)makeMJRefresh{
//    return YES;
//}
- (NSInteger)pageSize{
    return 100;
}
- (BOOL)firstShowAnimation{
    return YES;
}

- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return ALL_HOUSE_INFO;
    
}
- (void)loadDataSuccess{
    _tempArray = [NSMutableArray new];
    [_tempArray addObjectsFromArray:self.dataArray];
}
- (BOOL)canDeleteCell{
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHouseInfoTableViewCell class]);
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
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.view bringSubviewToFront:_backView];
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 1;
    }];
    return YES;
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {

        [self endEditSearchBar:nil];
        return NO;
    }
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTex{
    
    [self.dataArray removeAllObjects];
    
    if ([searchTex isEqualToString:@""]) {
        [self.dataArray addObjectsFromArray:_tempArray];

    }else if ([ChineseTransform isChinese:searchTex]){
       
        //搜索中文
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"houseName contains [cd] %@ or devlopName contains [cd] %@ or areaName contains [cd] %@",searchTex,searchTex,searchTex];
        [self.dataArray addObjectsFromArray:[self.tempArray filteredArrayUsingPredicate:predicate]];
    }

    [self.tableView reloadData];

}
- (IBAction)endEditSearchBar:(UITapGestureRecognizer *)sender {
    [self.searchBar endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _backView.alpha = 0;
    }];
}

- (void)backToPreVC{
    [self endEditSearchBar:nil];
    POPVC;
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
