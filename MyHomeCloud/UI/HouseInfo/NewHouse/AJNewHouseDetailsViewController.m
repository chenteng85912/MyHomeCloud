//
//  AJNewHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/8.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouseDetailsViewController.h"
#import "AJLocationViewController.h"
#import "AJNewReserverViewController.h"
#import "AJNewHouseCellModel.h"
#import "AJNewHouseTableViewCell.h"

NSInteger const MAX_NUMBER = 10;
CGFloat const INFO_NORMAL_HEITHT = 450;
CGFloat const INFO_MORE_HEITHT = 820;

#define AUTOLOOP_HEIGHT     dHeight/3

@interface AJNewHouseDetailsViewController ()<UIScrollViewDelegate,CTAutoLoopViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *moreInfoView;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (strong, nonatomic) UIView *tbViewHeadView;
// 滚动图片视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;
@property (strong, nonatomic) AJLocationViewController *mapVC;
@property (strong, nonatomic) AVObject *likeHouse;
@property (strong, nonatomic) AVObject *houseInfo;//当前房源信息
@property (strong, nonatomic) AJNewReserverViewController *userReserer;//新预约
@end

@implementation AJNewHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - AJTbViewProtocol
- (NSInteger)pageSize{
    return MAX_NUMBER;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}

- (NSString *)requestClassName{
    
    return N_HOUSE;
    
}

- (BOOL)firstShowAnimation{
    return YES;
}
- (NSString *)requestKeyName{
    //同一地区的楼盘
    return _searchKey;
}
- (NSString *)recordClassName{

    return N_RECORD;
    
}
- (NSString *)favoriteClassName{
    return N_FAVORITE;
    
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
        [UIAlertController alertWithTitle:@"温馨提示" message:@"很抱歉，该楼盘信息已失效，请查看其它楼盘" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                POPVC;
            }
        }];
        return;
    }
//    [self initHouseDetailsInfo];
    self.tableView.tableFooterView = nil;
    self.tableView.tableHeaderView = self.tbViewHeadView;
    [UIView animateWithDuration:0.3 animations:^{
        _footerView.alpha = 1.0;
        
    }];
    //移除本房源
    [self.dataArray removeObject:selfModal];
    [self.tableView reloadData];
    
}
- (NSString *)customeTbViewCellClassName{
   
    return  NSStringFromClass([AJNewHouseTableViewCell class]);
    
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJNewHouseCellModel class]);

}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJNewHouseDetailsViewController *details = [AJNewHouseDetailsViewController new];
    
    details.houseId = self.dataArray[indexPath.row].objectData.objectId;
    details.showModal = SearchHouseModal;
    details.searchKey = self.dataArray[indexPath.row].objectData[HOUSE_ESTATE_NAME];
    
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
- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag==0) {
        //相册
    }else if (sender.tag==1||sender.tag==7) {
        //地址
        //地图
        _mapVC =nil;
        APP_PUSH(self.mapVC);
    }else if (sender.tag==2) {
        //更多
        sender.selected = !sender.selected;
        _tbViewHeadView = nil;
        self.tableView.tableHeaderView = self.tbViewHeadView;
    }else if (sender.tag==3) {
        //收藏
    }else if (sender.tag==4) {
        //预约
    }else if (sender.tag==5){
        //咨询经纪人
    }else{
        POPVC;
    }
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
        _tbViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT+INFO_NORMAL_HEITHT)];
        if (_moreInfoBtn.selected) {
            _tbViewHeadView.frame = CGRectMake(0, 0, dWidth, AUTOLOOP_HEIGHT+INFO_MORE_HEITHT);
            _mapView.center = CGPointMake(dWidth/2, INFO_MORE_HEITHT-_mapView.frame.size.height/2);
            _mapView.hidden = NO;
            [_tbViewHeadView addSubview:_mapView];
            
            _moreInfoView.center = CGPointMake(dWidth/2, _moreInfoView.frame.size.height/2+AUTOLOOP_HEIGHT+_infoView.frame.size.height);
            _moreInfoView.hidden = NO;
            [_tbViewHeadView addSubview:_moreInfoView];
        }else{
            _mapView.center = CGPointMake(dWidth/2, INFO_NORMAL_HEITHT-_mapView.frame.size.height/2);
            _mapView.hidden = NO;
            [_tbViewHeadView addSubview:_mapView];
        }
        [_tbViewHeadView addSubview:self.autoLoopView.view];
        
        _infoView.center = CGPointMake(dWidth/2, _infoView.frame.size.height/2+AUTOLOOP_HEIGHT);
        _infoView.hidden = NO;
        [_tbViewHeadView addSubview:_infoView];
       
    }
    
    return _tbViewHeadView;
}
- (AJLocationViewController *)mapVC{
    if (_mapVC ==nil) {
        _mapVC = [AJLocationViewController new];
        _mapVC.houseObj = self.houseInfo;
    }
    return _mapVC;
}
- (AJNewReserverViewController *)userReserer{
    if (_userReserer ==nil) {
        _userReserer = [AJNewReserverViewController new];
        _userReserer.houseInfo = _houseInfo;
//        if (self.detailsModal==SecondModal) {
//            _userReserer.reserverModal = SecondReserverModal;
//        }else{
//            _userReserer.reserverModal = LetReserverModal;
//            
//        }
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
