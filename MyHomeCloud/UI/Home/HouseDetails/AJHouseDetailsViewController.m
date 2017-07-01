//
//  AJHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDetailsViewController.h"
#import "AJSecondHouseViewController.h"
#import "AJLetHouseViewController.h"
#import "AJSecondHouseTableViewCell.h"
#import "AJSecondHouseCellModel.h"
#import "AJLetHouseTableViewCell.h"
#import "AJLetHouseCellModel.h"
#import "AJHomeDataCenter.h"
#import "AJLocationViewController.h"
#import "AJLocation.h"
#import "AJEstateDetailsViewController.h"
#import "AJNewReserverViewController.h"

NSInteger const MAX_HOUSE_NUMBER = 10;
CGFloat const HOUSE_INFO_HEITHT = 610;

#define AUTOLOOP_HEIGHT     dHeight/3

@interface AJHouseDetailsViewController ()<UIScrollViewDelegate,CTAutoLoopViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *moreHouseBtn;
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseRooms;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaage;
@property (weak, nonatomic) IBOutlet UILabel *houseDes;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseDerese;
@property (weak, nonatomic) IBOutlet UILabel *houseShowTime;
@property (weak, nonatomic) IBOutlet UILabel *houseFloor;
@property (weak, nonatomic) IBOutlet UILabel *houseYear;
@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (strong, nonatomic) UIView *tbViewHeadView;
@property (weak, nonatomic) IBOutlet UIView *headBtnView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *footerBtnView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;


// 滚动图片视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;

//@property (strong, nonatomic) AVObject *someUser;
@property (strong, nonatomic) AJLocationViewController *mapView;
@property (strong, nonatomic) AVObject *likeHouse;
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息
@property (strong, nonatomic) AJNewReserverViewController *userReserer;//新预约


@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDetails = YES;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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

    }else{
        return LET_HOUSE;

    }
    
}

- (BOOL)firstShowAnimation{
    return YES;
}
- (NSString *)requestKeyName{
   //同一个小区的房源
    return _searchKey;
}
- (NSString *)recordClassName{
    if (_detailsModal==SecondModal) {
        return SECOND_RECORD;
        
    }else{
        return LET_RECORD;
        
    }
}
- (NSString *)favoriteClassName{
    if (_detailsModal==SecondModal) {
        return SECOND_FAVORITE;
        
    }else{
        return LET_FAVORITE;
        
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
    [self initHouseDetailsInfo];
    self.tableView.tableFooterView = nil;
    self.tableView.tableHeaderView = self.tbViewHeadView;
    [UIView animateWithDuration:0.3 animations:^{
        _footerBtnView.alpha = 1.0;
        
    }];
    //移除本房源
    [self.dataArray removeObject:selfModal];
    [self.tableView reloadData];
    if (self.dataArray.count>MAX_HOUSE_NUMBER) {
        self.moreHouseBtn.hidden = NO;
        self.tableView.tableFooterView = self.moreHouseBtn;
        
    }
    
}
- (NSString *)customeTbViewCellClassName{
    if (_detailsModal==SecondModal) {
        return  NSStringFromClass([AJSecondHouseTableViewCell class]);

    }else{
        return  NSStringFromClass([AJLetHouseTableViewCell class]);

    }
}
- (NSString *)customeTbViewCellModelClassName{
    if (_detailsModal==SecondModal) {
        return NSStringFromClass([AJSecondHouseCellModel class]);

    }else{
        return NSStringFromClass([AJLetHouseCellModel class]);

    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];

    details.houseId = self.dataArray[indexPath.row].objectData.objectId;
    details.detailsModal = self.detailsModal;
    details.showModal = SearchHouseModal;
    details.searchKey = self.dataArray[indexPath.row].objectData[HOUSE_ESTATE_NAME];

    //保存浏览记录
    AJTbViewCellModel *model = self.dataArray[indexPath.row];
    [[AJHomeDataCenter new] addRecordData:model.objectData recordClassName:[self recordClassName]];

    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)initHouseDetailsInfo{
   
    //添加地图
    self.mapView.view.frame = _mapBackView.bounds;
    [_mapBackView addSubview:self.mapView.view];
    self.mapView.locationBtn.hidden = YES;
    self.mapView.navBtn.hidden = YES;
    
    [_mapBackView bringSubviewToFront:_mapBtn];
    [self.view bringSubviewToFront:_headBtnView];
    
    if ([AVUser currentUser]) {
        
        [self checkLikeState];
        
    }
    if (self.detailsModal==SecondModal) {
        _titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@万",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[HOUSE_TOTAL_PRICE]];
        _totalLabel.text = [NSString stringWithFormat:@"%@万",_houseInfo[HOUSE_TOTAL_PRICE]];
        _titleLb.text =  _titleLabel.text;
        _unitPrice.text = [NSString stringWithFormat:@"%@元/平",_houseInfo[HOUSE_UNIT_PRICE]];

    }else{
        _priceLabel.text = @"租金";
        _unitPriceLabel.text = @"物业";
        _titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@元/月",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[LET_HOUSE_PRICE]];
        _totalLabel.text = [NSString stringWithFormat:@"%@元/月",_houseInfo[LET_HOUSE_PRICE]];
        _titleLb.text =  _titleLabel.text;
        if (_houseInfo[LET_ESTATE_PRICE]) {
            _unitPrice.text = [NSString stringWithFormat:@"%@元/平",_houseInfo[LET_ESTATE_PRICE]];

        }

    }
    
    //房屋标签
    NSArray *desArray = _houseInfo[HOUSE_TAGS];
    if (desArray&&desArray.count>0) {
        NSString *desStr = @"";
        for (NSString *str in desArray) {
            desStr = [NSString stringWithFormat:@"%@ %@",desStr,str];
        }
        _houseDes.text = [desStr substringFromIndex:1];

    }
    
    _houseRooms.text = _houseInfo[HOUSE_AMOUNT];
    _houseAreaage.text = [NSString stringWithFormat:@"%@平",_houseInfo[HOUSE_AREAAGE]];
    
    _directionLabel.text = _houseInfo[HOUSE_DIRECTION];
    
    _houseDerese.text = _houseInfo[HOUSE_DESCRIBE];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _houseShowTime.text = [formatter stringFromDate:_houseInfo.createdAt];
    
    _houseFloor.text = [NSString stringWithFormat:@"%@/%@",_houseInfo[HOUSE_FLOOR_NUM],_houseInfo[HOUSE_TOTAL_FLOOR]];
    
    _houseYear.text = _houseInfo[HOUSE_YEARS];
    
}
//检测关注状态
- (void)checkLikeState{
    
    if (_detailsModal== SecondModal) {
        self.baseQuery.className = SECOND_FAVORITE;

    }else{
        self.baseQuery.className = LET_FAVORITE;

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
//        [weakSelf fetchAuthorData];
    }];

}

//添加 取消收藏
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
                    weakSelf.tbView.isLoad = NO;
                    
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
        debugLog(@"预约看房");
        [self addChildViewController:self.userReserer];
        [UIView animateWithDuration:0.3 animations:^{
            self.userReserer.view.alpha = 1.0;
        }];
#endif
       
    }else{
        debugLog(@"咨询经纪人");
        [CTTool takePhoneNumber:self.houseInfo[AGENTER_PHONE]];

    }
   
   
}

- (IBAction)showMoreHouse:(UIButton *)sender {
    if (sender.tag==0) {
        //更多房源信息
        debugLog(@"更多房源信息");
        AJEstateDetailsViewController *estate = [AJEstateDetailsViewController new];
        estate.title = _houseInfo[HOUSE_ESTATE_NAME];
        estate.houseInfo = _houseInfo;
        estate.detailsModal = _detailsModal;
        
        APP_PUSH(estate);

    }else if (sender.tag==1){
        //地图
        _mapView =nil;
        APP_PUSH(self.mapView);

    }else {
        //更多房屋
        if (_detailsModal==SecondModal) {
            AJSecondHouseViewController *second = [AJSecondHouseViewController new];
            second.showModal = AllHouseModal;
            APP_PUSH(second);
        }else {
            AJLetHouseViewController *let = [AJLetHouseViewController new];
            let.showModal = AllHouseModal;
            APP_PUSH(let);
            
        }
        debugLog(@"更多房源");

    }
    
}

//获取作者信息
//- (void)fetchAuthorData{
//    self.baseQuery.className = USER_INFO;
//    WeakSelf;
//    [self.baseQuery getObjectInBackgroundWithId:_houseInfo[HOUSE_AUTHOR] block:^(AVObject * _Nullable object, NSError * _Nullable error) {
//        if (object) {
//            weakSelf.someUser = object;
//            //头像
//            [weakSelf.userHead sd_setImageWithURL:object[HEAD_URL] placeholderImage:[CTTool iconImage]];
//        }
//    }];
//}


#pragma mark CTAutoLoopViewDelegate
- (UIView *)CTAutoLoopViewController:(UICollectionViewCell *)collectionCell cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imgUrlStr = self.autoLoopDataArray[indexPath.row];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    return imgView;
}
- (void)CTAutoLoopViewController:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[CTImagePreviewViewController defaultShowPicture] showPictureWithUrlOrImages:self.autoLoopDataArray withCurrentPageNum:indexPath.row andRootViewController:self];
}

- (IBAction)shareAction:(UIButton *)sender{
    if (sender.tag==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        debugLog(@"分享");

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
//    debugLog(@"%f",offsetY);
    if(offsetY >0) {
        CGFloat ap = MIN(offsetY/120.0, 1.0);
      
        _titleLb.alpha = offsetY>AUTOLOOP_HEIGHT-64+45?1.0:0.0;
        
        _headBtnView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:51.0/255.0 alpha:ap>0?ap:0];
    }else{

        _headBtnView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:51.0/255.0 alpha:0];
        _titleLb.alpha = 0;
    }
}

- (CTAutoLoopViewController*)autoLoopView
{
    if (!_autoLoopView) {
        _autoLoopView = [[CTAutoLoopViewController alloc] initWithFrame:CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT) onceLoopTime:0 cellDisplayModal:CTLoopCellDisplayCustomView scollDiretion:CTLoopScollDirectionHorizontal];
        _autoLoopView.delegate = self;
        //头部广告滚动视图数据源
        [_autoLoopView addLocalModels:self.autoLoopDataArray];
    }
    return _autoLoopView;
}
- (NSMutableArray *)autoLoopDataArray{
    if (!_autoLoopDataArray) {
        _autoLoopDataArray = [NSMutableArray new];
        NSArray *imgArray = self.houseInfo[HOUSE_FILE_ID];
        
        [_autoLoopDataArray addObjectsFromArray:imgArray];
    }
   
    return _autoLoopDataArray;
}
- (UIView *)tbViewHeadView{
    if (_tbViewHeadView == nil) {
        _tbViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT+HOUSE_INFO_HEITHT)];
        [_tbViewHeadView addSubview:self.autoLoopView.view];
        _houseInfoView.center = CGPointMake(dWidth/2, _tbViewHeadView.frame.size.height-HOUSE_INFO_HEITHT/2);
        _houseInfoView.hidden = NO;
        [_tbViewHeadView addSubview:_houseInfoView];
    }
    
    return _tbViewHeadView;
}

- (AJLocationViewController *)mapView{
    if (_mapView ==nil) {
        _mapView = [AJLocationViewController new];
        _mapView.houseObj = self.houseInfo;
    }
    return _mapView;
}
- (AJNewReserverViewController *)userReserer{
    if (_userReserer ==nil) {
        _userReserer = [AJNewReserverViewController new];
        _userReserer.houseInfo = _houseInfo;
        if (self.detailsModal==SecondModal) {
            _userReserer.reserverModal = SecondReserverModal;
        }else{
            _userReserer.reserverModal = LetReserverModal;

        }
        _userReserer.view.alpha = 0;
        [self.view addSubview:_userReserer.view];
        _userReserer.view.frame = self.view.bounds;

    }

    return _userReserer;
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
