//
//  AJHouseInfoViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseInfoViewController.h"
#import "AJSecondHouseViewController.h"
#import "AJLetHouseViewController.h"
#import "AJNewHouseViewController.h"
#import "AJSecondHouseTableViewCell.h"
#import "AJSecondHouseCellModel.h"
#import "AJLetHouseTableViewCell.h"
#import "AJLetHouseCellModel.h"
#import "AJNewHouseTableViewCell.h"
#import "AJNewHouseCellModel.h"

#import "AJHouseInfoEditViewController.h"
#import "AJNewReserverViewController.h"
#import "AJHomeDataCenter.h"

NSInteger const MAX_HOUSE_NUMBER = 10;

CGFloat const NEW_NORMAL_HEITHT = 210;
CGFloat const NEW_MORE_HEITHT = 580;

@interface AJHouseInfoViewController ()<UIScrollViewDelegate,AJHouseInfoEditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UIView *footerView;//底部视图
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;//关注
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;//关注按钮
@property (weak, nonatomic) IBOutlet UIView *headView;//头部视图
@property (weak, nonatomic) IBOutlet UILabel *houseTitle;//标题

@property (strong, nonatomic) AVObject *likeHouse;//收藏对象
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息
@property (strong, nonatomic) AJNewReserverViewController *userReserer;//新预约
@property (strong, nonatomic) AJHouseDetailsViewController *houseDetails;//详情对象

@end

@implementation AJHouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDetails = YES;

#if AJCLOUDADMIN
    self.editBtn.hidden = NO;
#endif
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_houseDetails&&_isChange) {
        _houseDetails = nil;
        [self.houseDetails initHouseDetailsInfo];
    }
}
#pragma mark - AJTbViewProtocol
- (NSInteger)pageSize{
    return MAX_HOUSE_NUMBER;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}

- (NSString *)requestClassName{
    
    if (_detailsModal==SecondModal) {
        return SECOND_HAND_HOUSE;
        
    }else if (_detailsModal==LetModal) {
        return LET_HOUSE;
        
    }else{
        return N_HOUSE;
        
    }
    
}

- (BOOL)firstShowAnimation{
    return YES;
}
- (NSString *)requestKeyName{
    //同一个小区的房源 同一地区的楼盘
    return _searchKey;
}
- (NSString *)recordClassName{
    if (_detailsModal==SecondModal) {
        return SECOND_RECORD;
        
    }else if (_detailsModal==LetModal) {
        return LET_RECORD;
        
    }else{
        return N_RECORD;
        
    }
}
- (NSString *)favoriteClassName{
    if (_detailsModal==SecondModal) {
        return SECOND_FAVORITE;
        
    }else if (_detailsModal==LetModal) {
        return LET_FAVORITE;
        
    }else{
        return N_FAVORITE;
        
    }
}
- (void)loadDataSuccess{
    
    BOOL suc = false;
    AJTbViewCellModel *selfModal;
    
    for (AJTbViewCellModel *modal in self.dataArray) {
        if ([modal.objectData.objectId isEqualToString:_houseId]) {
            selfModal = modal;
            _houseInfo = modal.objectData;
            suc = YES;
            break;
        }
    }
    if (!suc) {
        self.tableView.hidden = YES;
        //本房源已经失效
        [UIAlertController alertWithTitle:@"温馨提示" message:@"很抱歉，该房源已失效，请查看其它房源" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                POPVC;
            }
        }];
        return;
    }
    self.tableView.tableFooterView = nil;
    self.tableView.tableHeaderView = self.houseDetails.view;
    [self.houseDetails initHouseDetailsInfo];

    [self.view bringSubviewToFront:_headView];
    [UIView animateWithDuration:0.3 animations:^{
        _footerView.alpha = 1.0;
        
    }];
    //移除本房源
    [self.dataArray removeObject:selfModal];
    [self.tableView reloadData];
    
    [self checkLikeState];
    if (self.detailsModal==LetModal) {
    
        _houseTitle.text = [NSString stringWithFormat:@"%@ %@ %@元/月",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[LET_HOUSE_PRICE]];
      
    }else if (self.detailsModal==SecondModal){
        _houseTitle.text = [NSString stringWithFormat:@"%@ %@ %@万",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[HOUSE_TOTAL_PRICE]];
       
    }else{
        _houseTitle.text = self.houseInfo[HOUSE_ESTATE_NAME];
    }
    
}
- (NSString *)customeTbViewCellClassName{
    if (_detailsModal==SecondModal) {
        return  NSStringFromClass([AJSecondHouseTableViewCell class]);
        
    }else if (_detailsModal==LetModal){
        return  NSStringFromClass([AJLetHouseTableViewCell class]);
        
    }else{
        return  NSStringFromClass([AJNewHouseTableViewCell class]);

    }
}
- (NSString *)customeTbViewCellModelClassName{
    if (_detailsModal==SecondModal) {
        return NSStringFromClass([AJSecondHouseCellModel class]);
        
    }else if (_detailsModal==LetModal){
        return NSStringFromClass([AJLetHouseCellModel class]);
        
    }else{
        return NSStringFromClass([AJNewHouseCellModel class]);

    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHouseInfoViewController *details = [AJHouseInfoViewController new];
    
    details.houseId = self.dataArray[indexPath.row].objectData.objectId;
    details.detailsModal = self.detailsModal;
    details.showModal = SearchHouseModal;
    if (_detailsModal==NModal) {
        details.searchKey = self.dataArray[indexPath.row].objectData[HOUSE_AREA];

    }else{
        details.searchKey = self.dataArray[indexPath.row].objectData[HOUSE_ESTATE_NAME];

    }
    
    //保存浏览记录
//    AJTbViewCellModel *model = self.dataArray[indexPath.row];
//    [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:[self recordClassName]];
    
    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark AJHouseInfoEditViewControllerDelegate
- (void)refreshHouseInfo{
    self.tableView.tableHeaderView = self.houseDetails.view;
}
- (IBAction)headBtnAction:(UIButton *)sender {
    if (sender.tag==0) {
        POPVC;
    }else{
     //编辑界面
        AJHouseInfoEditViewController *edit = [AJHouseInfoEditViewController new];
        edit.detailsModal = self.detailsModal;
        edit.title = _houseTitle.text;
        edit.houseInfo = _houseInfo;
        edit.delegate = self;
        APP_PUSH(edit);
    }
}
//添加 取消收藏 预约 咨询经纪人
- (IBAction)bottomAction:(UIButton *)likeBtn{
    
    WeakSelf;
    //收藏
    if (likeBtn.tag==0) {
        if (![AVUser currentUser]) {
            [AJSB goLoginViewComplete:^{
                [weakSelf checkLikeState];
            }];
            return;
        }
        
        [self.view showHUD:nil];
        if (likeBtn.selected) {
            
            [_likeHouse deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                if (succeeded) {
                    likeBtn.selected = NO;
                    _likeLabel.text = @"关注";
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNewHouseNotification object:nil];
                    
                }
            }];
            
        }else{
            [[AJHomeDataCenter new] addFavoriteData:_houseInfo favClassName:[self favoriteClassName] complete:^(BOOL success, NSArray *returnValue) {
                [weakSelf.view removeHUD];
                if (success) {
                    _likeBtn.selected = YES;
                    _likeLabel.text = @"已关注";
                    
                }else{
                    [self.view showTips:@"关注失败" withState:TYKYHUDModeFail complete:nil];
                }
                
            }];
            
        }
    }else if (likeBtn.tag==1){
#if AJCLOUD
        if (![AVUser currentUser]) {
            [AJSB goLoginViewComplete:^{
            }];
            return;
        }
        _userReserer = nil;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.userReserer];
        APP_PRESENT(nav);
        
#else
        [self.view showTips:@"企业版禁止预约" withState:TYKYHUDModeWarning complete:nil];
        
#endif
        
    }else{
        debugLog(@"咨询经纪人");
        [CTTool takePhoneNumber:self.houseInfo[AGENTER_PHONE]];
        
    }
    
    
}
//展开更多
- (void)showMoreHouseInfo{
    self.tableView.tableHeaderView = self.houseDetails.view;
    [self.houseDetails initHouseDetailsInfo];
}
//检测关注状态
- (void)checkLikeState{
    
    if (_detailsModal== SecondModal) {
        self.baseQuery.className = SECOND_FAVORITE;
        
    }else if (_detailsModal== SecondModal) {
        self.baseQuery.className = SECOND_FAVORITE;
        
    }
    else{
        self.baseQuery.className = N_FAVORITE;
        
    }
    [self.baseQuery whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    [self.baseQuery whereKey:HOUSE_ID   equalTo:_houseId];
    
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            _likeHouse = objects[0];
            _likeBtn.selected = YES;
            _likeLabel.text = @"已关注";
            
        }else{
            _likeBtn.selected = NO;
            _likeLabel.text = @"关注";
            
        }
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //    debugLog(@"%f",offsetY);
    if(offsetY >0) {
        CGFloat ap = MIN(offsetY/120.0, 1.0);
        
        _houseTitle.alpha = offsetY>AUTOLOOP_HEIGHT-64+45?1.0:0.0;
        
        _headView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:51.0/255.0 alpha:ap>0?ap:0];
    }else{
        
        _headView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:51.0/255.0 alpha:0];
        _houseTitle.alpha = 0;
    }
}
- (AJNewReserverViewController *)userReserer{
    if (_userReserer ==nil) {
        _userReserer = [AJNewReserverViewController new];
        _userReserer.houseInfo = _houseInfo;
        if (self.detailsModal==SecondModal) {
            _userReserer.reserverModal = SecondReserverModal;
        }else if (_detailsModal==LetModal){
            _userReserer.reserverModal = LetReserverModal;

        }else{
            _userReserer.reserverModal = NReserverModal;
            
        }
    }
    
    return _userReserer;
}
- (AJHouseDetailsViewController *)houseDetails{
    if (_houseDetails==nil) {
        _houseDetails = [AJHouseDetailsViewController new];
        _houseDetails.detailsModal  = self.detailsModal;
        _houseDetails.houseInfo = self.houseInfo;
        
        [self addChildViewController:_houseDetails];
    }
    if (_detailsModal==SecondModal||_detailsModal==LetModal) {
        _houseDetails.view.frame = CGRectMake(0, 0, dWidth, INFO_NORMAL_HEITHT+AUTOLOOP_HEIGHT+MAP_HEIGHT);
        
    }else{
        if (_houseDetails.moreInfoBtn.selected) {
            _houseDetails.view.frame = CGRectMake(0, 0, dWidth, NEW_MORE_HEITHT+AUTOLOOP_HEIGHT+MAP_HEIGHT);

        }else{
            _houseDetails.view.frame = CGRectMake(0, 0, dWidth, NEW_NORMAL_HEITHT+AUTOLOOP_HEIGHT+MAP_HEIGHT);

        }
        
    }
    return _houseDetails;
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
