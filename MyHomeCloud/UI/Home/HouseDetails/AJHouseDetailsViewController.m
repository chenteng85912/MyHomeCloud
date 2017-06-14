//
//  AJHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDetailsViewController.h"
#import "AJSecondHouseTableViewCell.h"
#import "AJSecondHouseCellModel.h"
#import "AJHomeDataCenter.h"
#import "AJLocationViewController.h"
#import "AJLocation.h"

NSInteger const MAX_HOUSE_NUMBER = 10;
CGFloat const HOUSE_INFO_HEITHT = 650;

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

@property (strong, nonatomic) AVObject *likedObj;
@property (strong, nonatomic) AVObject *someUser;
@property (strong, nonatomic) AJLocationViewController *mapView;


@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDetails = YES;
    if (_houseInfo[HOUSE_OBJECT]) {
        _likedObj = _houseInfo;
        _houseInfo = _houseInfo[HOUSE_OBJECT];
    }
    [self initHouseDetailsInfo];
    
    //添加地图
    self.mapView.view.frame = _mapBackView.bounds;
    [_mapBackView addSubview:self.mapView.view];
    self.mapView.locationBtn.hidden = YES;
    self.mapView.navBtn.hidden = YES;

    [_mapBackView bringSubviewToFront:_mapBtn];
    [self.view bringSubviewToFront:_headBtnView];

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
    return self.houseInfo[HOUSE_ESTATE_NAME];
}
- (void)loadDataSuccess{
    self.tableView.tableFooterView = nil;
    self.tableView.tableHeaderView = self.tbViewHeadView;
    [UIView animateWithDuration:0.3 animations:^{
        _footerBtnView.alpha = 1.0;

    }];
    //移除本房源
    WeakSelf;
    [self.dataArray enumerateObjectsUsingBlock:^(AJTbViewCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.objectData.objectId isEqualToString:self.houseInfo.objectId]) {
            [weakSelf.dataArray removeObject:obj];
            [weakSelf.tableView reloadData];
            if (self.dataArray.count>MAX_HOUSE_NUMBER) {
                self.moreHouseBtn.hidden = NO;
                self.tableView.tableFooterView = self.moreHouseBtn;
                
            }
            *stop = YES;
        }
        
    }];
    
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJSecondHouseTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJSecondHouseCellModel class]);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJHouseDetailsViewController *details = [AJHouseDetailsViewController new];
    details.houseInfo = self.dataArray[indexPath.row].objectData;
    details.detailsModal = SecondModal;
    details.showModal = SearchHouseModal;
    //保存浏览记录
    AJTbViewCellModel *model = self.dataArray[indexPath.row];
    [[AJHomeDataCenter new] addRecordData:model.objectData objectClassName:SECOND_HAND_HOUSE recordClassName:SECOND_RECORD];

    APP_PUSH(details);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)initHouseDetailsInfo{
   
    if (self.isFromFav) {
        _likeBtn.selected = YES;
        _likeLabel.text = @"已关注";
    }else if ([AVUser currentUser]) {
        
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
//检测登录状态
- (void)checkLikeState{
    
    if (_detailsModal== SecondModal) {
        self.baseQuery.className = SECOND_FAVORITE;

    }else{
        self.baseQuery.className = LET_FAVORITE;

    }
    [self.baseQuery whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    [self.baseQuery whereKey:HOUSE_ID equalTo:self.houseInfo.objectId];

    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            _likedObj = objects[0];
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
            
            [self.likedObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                if (succeeded) {
                    likeBtn.selected = NO;
                    _likedObj = nil;
                    _likeLabel.text = @"关注";

                    if (weakSelf.isFromFav) {
                        weakSelf.tbView.isLoad = NO;
                    }
                }
            }];
            
        }else{
            AVObject *houseInfo;
            if (_detailsModal== SecondModal) {
                houseInfo = [[AVObject alloc] initWithClassName:SECOND_FAVORITE];
                [houseInfo setObject:[AVObject objectWithClassName:SECOND_HAND_HOUSE objectId:self.houseInfo.objectId] forKey:HOUSE_OBJECT];

            }else{
                houseInfo = [[AVObject alloc] initWithClassName:LET_FAVORITE];
                [houseInfo setObject:[AVObject objectWithClassName:LET_HOUSE objectId:self.houseInfo.objectId] forKey:HOUSE_OBJECT];

            }
            [houseInfo setObject:self.houseInfo.objectId forKey:HOUSE_ID];
            [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
            
            [houseInfo setObject:[AVUser currentUser].objectId  forKey:HOUSE_AUTHOR];
            [houseInfo setObject:[AVUser currentUser][HEAD_URL] forKey:HEAD_URL];
            
            [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weakSelf.view removeHUD];
                
                if (succeeded) {
                    _likedObj = houseInfo;
                    _likeBtn.selected = YES;
                    _likeLabel.text = @"已关注";

                }
                
            }];
        }
    }else if (likeBtn.tag==1){
        if (![AVUser currentUser]) {
            [AJSB goLoginViewComplete:^{
            }];
            return;
        }
        debugLog(@"预约看房");
    }else{
        debugLog(@"咨询经纪人");
        [CTTool takePhoneNumber:self.houseInfo[USER_PHONE]];

    }
   
   
}

- (IBAction)showMoreHouse:(UIButton *)sender {
    if (sender.tag==0) {
        //房屋简介
        debugLog(@"房源简介");

    }else if (sender.tag==1){
        //地图
        _mapView =nil;
        APP_PUSH(self.mapView);

    }else if (sender.tag==2){
        //更多房屋
        debugLog(@"更多房源");

    }else{
        //更多房源信息
        debugLog(@"更多房源信息");
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
    debugLog(@"%f",offsetY);
    if(offsetY >0) {
        CGFloat ap = MIN(offsetY/120.0, 1.0);
      
        _titleLb.alpha = offsetY>AUTOLOOP_HEIGHT-64+45?1.0:0.0;
        
        _headBtnView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:51.0/255.0 alpha:ap>0?ap:0];
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
