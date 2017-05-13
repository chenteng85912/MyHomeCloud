//
//  AJHonmeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHonmeViewController.h"
#import "AJSearchViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHouseDetailsViewController.h"

@interface AJHonmeViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AJHonmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(openSearch)];
//    self.navigationItem.rightBarButtonItem.tintColor = NavigationBarColor;
    self.navigationItem.titleView = self.searchBar;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return HOUSE_INFO;
}

- (NSString *)customeTableViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AJTbViewCellModel *model = self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = model.objectData;
    
    [self addRecordData:model.objectData];
    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)openSearch{
    AJSearchViewController *search = [AJSearchViewController new];
    search.title = @"搜索";
    search.hidesBottomBarWhenPushed = YES;
    APP_PUSH(search);
}

//保存浏览记录
- (void)addRecordData:(AVObject *)object{
    AVObject *houseInfo = [[AVObject alloc] initWithClassName:RECORD_HOUSE];
    
    [houseInfo setObject:object.objectId forKey:HOUSE_ID];
    [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
    
    [houseInfo setObject:[AVObject objectWithClassName:HOUSE_INFO objectId:object.objectId] forKey:HOUSE_OBJECT];
    
    [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
          
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
