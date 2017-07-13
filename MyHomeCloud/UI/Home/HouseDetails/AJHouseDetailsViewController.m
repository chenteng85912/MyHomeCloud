//
//  AJHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDetailsViewController.h"
#import "AJLocationViewController.h"
#import "AJEstateDetailsViewController.h"

CGFloat const MAP_HEIGHT = 240;
CGFloat const INFO_NORMAL_HEITHT = 370;
CGFloat const BASE_VIEW_HEIGHT = 210;
CGFloat const MORE_VIEW_HEIGHT = 370;

@interface AJHouseDetailsViewController ()<CTAutoLoopViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *houseInfoView;//租房 二手房详情
@property (weak, nonatomic) IBOutlet UIView *mapBackView;//地图
@property (weak, nonatomic) IBOutlet UIView *moreInfoView;//新房更多信息
@property (weak, nonatomic) IBOutlet UIView *baseInfoView;//新房基本信息

//租房 二手房
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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;

//新房
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *estatePrice;
@property (weak, nonatomic) IBOutlet UILabel *estateTags;
@property (weak, nonatomic) IBOutlet UILabel *estateAddress;
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet UILabel *acceptTime;
@property (weak, nonatomic) IBOutlet UILabel *estateType;
@property (weak, nonatomic) IBOutlet UILabel *describeInfo;
@property (weak, nonatomic) IBOutlet UILabel *developerName;
@property (weak, nonatomic) IBOutlet UILabel *saleLicence;
@property (weak, nonatomic) IBOutlet UILabel *estateYears;
@property (weak, nonatomic) IBOutlet UILabel *estateName;
@property (weak, nonatomic) IBOutlet UILabel *buildingType;
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalHouseNumber;
@property (weak, nonatomic) IBOutlet UILabel *plotRatio;
@property (weak, nonatomic) IBOutlet UILabel *greenBelt;

@property (weak, nonatomic) IBOutlet UILabel *sameLabel;//相似房源 相似楼盘

// 滚动图片视图
@property (strong, nonatomic) CTAutoLoopViewController * autoLoopView;
@property (strong, nonatomic) NSMutableArray *autoLoopDataArray;

@property (strong, nonatomic) AJLocationViewController *mapView;

@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)initHouseDetailsInfo{
    
    //头部滚动图片
    [self.view addSubview:self.autoLoopView.view];

    //添加地图
    self.mapView.view.frame = _mapBView.bounds;
    self.mapView.view.userInteractionEnabled = NO;
    [_mapBView addSubview:self.mapView.view];
    self.mapView.locationBtn.hidden = YES;
    self.mapView.navBtn.hidden = YES;
    
    if (self.detailsModal==NModal) {
        
        //基本
        _baseInfoView.frame = CGRectMake(0, AUTOLOOP_HEIGHT, dWidth, BASE_VIEW_HEIGHT);
        _baseInfoView.hidden = NO;
        //更多
        _moreInfoView.frame = CGRectMake(0, AUTOLOOP_HEIGHT+BASE_VIEW_HEIGHT, dWidth, MORE_VIEW_HEIGHT);
        
        _moreInfoView.hidden = !_moreInfoBtn.selected;
        [self initNHouseInfo];
    }else{
        _houseInfoView.frame =  CGRectMake(0, AUTOLOOP_HEIGHT, dWidth, INFO_NORMAL_HEITHT);
        _houseInfoView.hidden = NO;

        [self initSecondOrLetHouse];
    }
    _mapBackView.frame = CGRectMake(0, self.view.frame.size.height-MAP_HEIGHT, dWidth, MAP_HEIGHT);

}
//新房基本信息
- (void)initNHouseInfo{
    _sameLabel.text = @"相似楼盘";
    
}

//二手房 租房基本信息
- (void)initSecondOrLetHouse{
    _sameLabel.text = @"相似房源";
    if (self.detailsModal==LetModal) {
        _priceLabel.text = @"租金";
        _unitPriceLabel.text = @"物业";
        _titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@元/月",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[LET_HOUSE_PRICE]];
        _totalLabel.text = [NSString stringWithFormat:@"%@元/月",_houseInfo[LET_HOUSE_PRICE]];
        if (_houseInfo[LET_ESTATE_PRICE]) {
            _unitPrice.text = [NSString stringWithFormat:@"%@元/平",_houseInfo[LET_ESTATE_PRICE]];
            
        }
        
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@万",_houseInfo[HOUSE_ESTATE_NAME],_houseInfo[HOUSE_AMOUNT],_houseInfo[HOUSE_TOTAL_PRICE]];
        _totalLabel.text = [NSString stringWithFormat:@"%@万",_houseInfo[HOUSE_TOTAL_PRICE]];
        _unitPrice.text = [NSString stringWithFormat:@"%@元/平",_houseInfo[HOUSE_UNIT_PRICE]];
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
    _houseShowTime.text = [formatter stringFromDate:_houseInfo.updatedAt];
    
    _houseFloor.text = [NSString stringWithFormat:@"%@/%@",_houseInfo[HOUSE_FLOOR_NUM],_houseInfo[HOUSE_TOTAL_FLOOR]];
    
    _houseYear.text = _houseInfo[HOUSE_YEARS];
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
        //楼盘相册

    }else {
        _mapView = nil;
        APP_PUSH(self.mapView);

    }
    
}
//打开地图
- (IBAction)openMapView:(UITapGestureRecognizer *)sender {
    _mapView = nil;
    APP_PUSH(self.mapView);
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
        [self addChildViewController:_autoLoopView];
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
