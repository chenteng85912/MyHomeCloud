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
#import "AJMyhouseViewController.h"

NSInteger const MAX_HOUSE_NUMBER = 10;
#define AUTOLOOP_HEIGHT     dHeight*2/5

@interface AJHouseDetailsViewController ()<UIScrollViewDelegate,CTAutoLoopViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIButton *moreHouseBtn;
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
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

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_headView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

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
    details.isSubVC = YES;
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
        [self fetchAuthorData];

    }else{
        [self checkLikeState];
        
    }
    _titleText.text = [NSString stringWithFormat:@"%@ %@ %@万",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[HOUSE_TOTAL_PRICE]];
    _titleLabel.text = _titleText.text;
    _totalLabel.text = [NSString stringWithFormat:@"%@万",_houseInfo[HOUSE_TOTAL_PRICE]];
    
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
        [weakSelf fetchAuthorData];
    }];

}

//添加 取消收藏
- (void)addLikeHouse{
    WeakSelf;

    [self.view showHUD:nil];
    if (self.rightBtn.selected) {
       
        [self.likedObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [weakSelf.view removeHUD];
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
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AJMyhouseViewController class]]) {
            AJMyhouseViewController *house = (AJMyhouseViewController *)vc;
            house.isLoad = NO;
            break;
        }
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag==0) {
        POPVC;
    }else{
        [self addLikeHouse];
    }
}
- (IBAction)showMoreHouse:(UIButton *)sender {
    AJHouseViewController *more = [AJHouseViewController new];
    more.showModal = SearchHouseModal;
    more.searchKey = self.houseInfo[HOUSE_ESTATE_NAME];
    APP_PUSH(more);
  
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    debugLog(@"%f",offsetY);
    if (offsetY > 0) {
        _headView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:MIN(1, offsetY/150)];
        _titleText.alpha = MIN(1, offsetY/150);
    } else {
        _headView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0];
        _titleText.alpha = 0;

    }
}
//获取作者信息
- (void)fetchAuthorData{
    self.baseQuery.className = USER_INFO;
    WeakSelf;
    [self.baseQuery getObjectInBackgroundWithId:_houseInfo[HOUSE_AUTHOR] block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            weakSelf.someUser = object;
            //头像
            [weakSelf.userHead sd_setImageWithURL:object[HEAD_URL] placeholderImage:[CTTool iconImage]];
        }
    }];
}
//打开用户所有房源

- (IBAction)showAuthorHouses:(id)sender {
    if (!self.someUser) {
        return;
    }
    AJMyhouseViewController *userHouse = [AJMyhouseViewController new];
    userHouse.showModal = SomeoneHouseModal;
    userHouse.someoneUser = self.someUser;
    userHouse.title = self.someUser[USER_NICKNAME];
    APP_PUSH(userHouse);
}

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
