//
//  AJHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDetailsViewController.h"
#import "AJMyhouseViewController.h"
#import "AJHomeTableViewCell.h"
#import "AJHomeCellModel.h"
#import "AJHouseViewController.h"

NSInteger const MAX_HOUSE_NUMBER = 10;

@interface AJHouseDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *moreHouseBtn;

@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) AVObject *likedObj;

@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ %@ %@万",self.houseInfo[HOUSE_ESTATE_NAME],self.houseInfo[HOUSE_AMOUNT],self.houseInfo[HOUSE_TOTAL_PRICE]];
    
    [self initNavRightButton];
}
#pragma mark - AJTbViewProtocol
- (NSInteger)pageSize{
    return MAX_HOUSE_NUMBER;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return HOUSE_INFO;
    
}
- (NSString *)requestKeyName{
   //同一个小区的房源
    return self.houseInfo[HOUSE_ESTATE_NAME];
}
- (void)loadDataSuccess{
    
    self.tableView.tableFooterView = nil;

    //移除本房源
    WeakSelf;
    [self.dataArray enumerateObjectsUsingBlock:^(AJTbViewCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.objectData.objectId isEqualToString:self.houseInfo.objectId]) {
            [weakSelf.dataArray removeObject:obj];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView showViewWithAnimation];
            if (self.dataArray.count==MAX_HOUSE_NUMBER) {
                self.moreHouseBtn.hidden = NO;
                self.tableView.tableFooterView = self.moreHouseBtn;
                
            }
            *stop = YES;
        }
        
    }];
    
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJHomeTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJHomeCellModel class]);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHomeCellModel *model = (AJHomeCellModel *)self.dataArray[indexPath.row];
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    
    details.houseInfo = model.objectData;
    
    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void) initNavRightButton{
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [self.rightBtn setImage:LOADIMAGE(@"unlike") forState:UIControlStateNormal];
    [self.rightBtn setImage:LOADIMAGE(@"liked") forState:UIControlStateSelected];
    
    [self.rightBtn addTarget:self action:@selector(addLikeHouse) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    if (self.isFromFav) {
        self.rightBtn.selected = YES;
    }else{
        [self checkLikeState];
        
    }
}
- (void)checkLikeState{
    
    [self.view showHUD:nil];
    self.baseQuery.className = FAVORITE_HOUSE;
    [self.baseQuery whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    [self.baseQuery whereKey:HOUSE_ID equalTo:self.houseInfo.objectId];
    WeakSelf;
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (objects.count>0) {
            weakSelf.likedObj = objects[0];
            weakSelf.rightBtn.selected = YES;
        }else{
            weakSelf.rightBtn.selected = NO;

        }
    }];

}
//添加 取消收藏
- (void)addLikeHouse{
    WeakSelf;

    if (self.rightBtn.selected) {
       
        [self.likedObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                weakSelf.rightBtn.selected = NO;
                weakSelf.likedObj = nil;

                [weakSelf refreshMyFavoriteList];
            }
        }];

    }else{
        AVObject *houseInfo = [[AVObject alloc] initWithClassName:FAVORITE_HOUSE];

        [houseInfo setObject:self.houseInfo.objectId forKey:HOUSE_ID];
        [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
        
        [houseInfo setObject:[AVObject objectWithClassName:HOUSE_INFO objectId:self.houseInfo.objectId] forKey:HOUSE_OBJECT];
        
        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                weakSelf.likedObj = houseInfo;
                weakSelf.rightBtn.selected = YES;

            }

        }];
    }
   
}
//取消收藏后 刷新收藏列表
- (void)refreshMyFavoriteList{
    if (!self.isFromFav) {
        return;
    }
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AJMyhouseViewController class]]) {
            AJMyhouseViewController *house = (AJMyhouseViewController *)vc;
            house.isLoad = NO;
            break;
        }
    }
}
- (IBAction)showMoreHouse:(UIButton *)sender {
    AJHouseViewController *more = [AJHouseViewController new];
    more.showModal = SearchHouseModal;
    more.searchKey = self.houseInfo[HOUSE_ESTATE_NAME];
    APP_PUSH(more);
  
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
