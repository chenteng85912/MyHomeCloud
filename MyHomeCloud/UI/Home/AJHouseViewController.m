//
//  AJHonmeViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseViewController.h"
#import "AJSearchViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHouseDetailsViewController.h"
#import "AJHomeCellModel.h"

@interface AJHouseViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AJHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kHomeHouseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kNewHouseNotification object:nil];

//    self.navigationItem.titleView = self.searchBar;

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
- (BOOL)canDeleteCell{
    return self.isAdmin;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJHomeCellModel class]);
}
- (void)loadDataSuccess{
    [self.view removeHUD];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = model.objectData;
    details.hidesBottomBarWhenPushed = YES;
    APP_PUSH(details);
    [self addRecordData:model.objectData];

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
    
    self.baseQuery.className = RECORD_HOUSE;
    [self.baseQuery whereKey:HOUSE_ID equalTo:object.objectId];
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            return;
           
        }
        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                
            }
        }];
    }];

}
- (void)refreshHomeData{
    [self.view showHUD:nil];
    [self initStartData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
