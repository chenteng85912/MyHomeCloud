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

NSInteger const MAX_HOUSE_NUMBER = 10;
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

@property (strong, nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) UIView *tbViewHeadView;

// 滚动图片视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;

@property (strong, nonatomic) AVObject *likedObj;
@property (strong, nonatomic) AVObject *someUser;

@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_houseInfo[HOUSE_OBJECT]) {
        _houseInfo = _houseInfo[HOUSE_OBJECT];
    }
    [self initHouseDetailsInfo];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark - AJTbViewProtocol
- (NSInteger)pageSize{
    return MAX_HOUSE_NUMBER;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    
    if (_detailsModal==SecondHouseModal) {
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
    details.detailsModal = SecondHouseModal;
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
        self.rightBtn.selected = YES;

    }else if ([AVUser currentUser]) {
        
        [self checkLikeState];
        
    }
    self.title = [NSString stringWithFormat:@"%@ %@ %@万",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[HOUSE_TOTAL_PRICE]];
    _totalLabel.text = [NSString stringWithFormat:@"%@万",_houseInfo[HOUSE_TOTAL_PRICE]];
    _titleLabel.text = self.title;
    _houseRooms.text = _houseInfo[HOUSE_AMOUNT];
    _houseAreaage.text = [NSString stringWithFormat:@"%@平",_houseInfo[HOUSE_AREAAGE]];
    
    _unitPrice.text = [NSString stringWithFormat:@"%@元/平",_houseInfo[HOUSE_UNIT_PRICE]];
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
    
    [self.view showHUD:nil];
    if (_detailsModal== SecondHouseModal) {
        self.baseQuery.className = SECOND_FAVORITE;

    }else{
        self.baseQuery.className = LET_FAVORITE;

    }
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
//        [weakSelf fetchAuthorData];
    }];

}

//添加 取消收藏
- (void)addLikeHouse:(UIButton *)likeBtn{
    WeakSelf;
    if (![AVUser currentUser]) {
        [AJSB goLoginViewComplete:^{
            [weakSelf addLikeHouse:_rightBtn];
        }];
        return;
    }
    [self.view showHUD:nil];
    if (likeBtn.selected) {
       
        [self.likedObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [weakSelf.view removeHUD];
            if (succeeded) {
                likeBtn.selected = NO;
                weakSelf.likedObj = nil;

                [weakSelf refreshMyFavoriteList];
            }
        }];

    }else{
        AVObject *houseInfo;
        if (_detailsModal== SecondHouseModal) {
            houseInfo = [[AVObject alloc] initWithClassName:SECOND_FAVORITE];
        }else{
            houseInfo = [[AVObject alloc] initWithClassName:LET_FAVORITE];
        }
        [houseInfo setObject:self.houseInfo.objectId forKey:HOUSE_ID];
        [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
        
        [houseInfo setObject:[AVObject objectWithClassName:SECOND_HAND_HOUSE objectId:self.houseInfo.objectId] forKey:HOUSE_OBJECT];
        [houseInfo setObject:[AVUser currentUser].objectId  forKey:HOUSE_AUTHOR];
        [houseInfo setObject:[AVUser currentUser][HEAD_URL] forKey:HEAD_URL];

        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [weakSelf.view removeHUD];

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
   
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag==0) {
        POPVC;
    }else{
        [self addLikeHouse:self.rightBtn];
    }
}
- (IBAction)showMoreHouse:(UIButton *)sender {
    
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
        _tbViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT+350)];
        [_tbViewHeadView addSubview:self.autoLoopView.view];
        _houseInfoView.center = CGPointMake(dWidth/2, _tbViewHeadView.frame.size.height-175);
        [_tbViewHeadView addSubview:_houseInfoView];
    }
    
    return _tbViewHeadView;
}
- (UIButton *)rightBtn{
    if (_rightBtn ==nil) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_rightBtn setImage:LOADIMAGE(@"unFav") forState:UIControlStateNormal];
        [_rightBtn setImage:LOADIMAGE(@"fav") forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(addLikeHouse:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
