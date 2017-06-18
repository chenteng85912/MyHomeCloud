//
//  AJEstateDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJEstateDetailsViewController.h"
#import "AJLocationViewController.h"
#import "AJNewHouseModel.h"
#import "AJEstateInfoModal.h"
#import "AJEstateTableViewCell.h"

@interface AJEstateDetailsViewController ()
@property (strong, nonatomic) AJNewHouseModel *houseMaodel;
@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@property (weak, nonatomic) IBOutlet UILabel *houseRooms;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaage;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) AJLocationViewController *mapView;
@property (strong, nonatomic) NSString *estateId;
@property (strong, nonatomic) NSMutableArray <AJEstateInfoModal *> *dataArray;

@end

@implementation AJEstateDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _houseRooms.text = _houseInfo[HOUSE_AMOUNT];
    _houseAreaage.text = _houseInfo[HOUSE_AREAAGE];
    _houseAreaage.text = [NSString stringWithFormat:@"%@m²",_houseInfo[HOUSE_AREAAGE]];

    _estateId = _houseInfo[ESTATE_ID];
    
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJEstateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJEstateTableViewCell class])];
    [self fetchHouseInfo];
}
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJEstateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJEstateTableViewCell class]) forIndexPath:indexPath];
    [cell processCellData:self.dataArray[indexPath.row]];
    return cell;
}
#pragma mark UITableViewDelegate UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray[indexPath.row].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}
- (void)fetchHouseInfo{
    [self.view showHUD:nil];
    
    self.baseQuery.className = ALL_HOUSE_INFO;
    WeakSelf;
    [self.baseQuery getObjectInBackgroundWithId:_estateId block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (!object) {
            [self.view showTips:@"数据加载失败" withState:TYKYHUDModeFail complete:nil];
            return ;
        }
        [weakSelf refreshView:object];
        
    }];
    
}
- (void)refreshView:(AVObject *)object{
   
    NSMutableArray *temp = [NSMutableArray new];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    if (_detailsModal == SecondModal) {
        [infoDic setObject:object[HOUSE_SALES_POINT] forKey:@"content"];
        [infoDic setObject:@"核心卖点" forKey:@"titleName"];
        [temp addObject:infoDic];
    }else{
        _mapBackView.hidden = NO;
        self.mapView.view.frame = _mapBackView.bounds;
        [_mapBackView addSubview:self.mapView.view];
        self.mapView.locationBtn.hidden = YES;
        self.mapView.navBtn.hidden = YES;
        [_mapBackView bringSubviewToFront:_mapBtn];
        self.tbView.tableFooterView = _mapBackView;
    }
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[ESTATE_INTR] forKey:@"content"];
    [infoDic setObject:@"小区介绍" forKey:@"titleName"];
    [temp addObject:infoDic];
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[TRAFFIC_INFO] forKey:@"content"];
    [infoDic setObject:@"交通出行" forKey:@"titleName"];
    [temp addObject:infoDic];
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[SUPPORT_MEASURES] forKey:@"content"];
    [infoDic setObject:@"周边配套" forKey:@"titleName"];
    [temp addObject:infoDic];
    
    for (NSDictionary *dic in temp) {
        AJEstateInfoModal *modal = [[AJEstateInfoModal alloc] initValueWithDictionary:dic];
        [modal calculateSizeConstrainedToSize];
        [self.dataArray addObject:modal];
    }
    self.tbView.tableHeaderView = _headView;
    [self.tbView reloadData];

}
- (IBAction)btnAction:(UIButton *)sender {
    _mapView =nil;
    APP_PUSH(self.mapView);
}
//房屋简介
//- (void)addHouseInfoView{
//    CGSize infoSize = [self.houseMaodel.houseInfo sizeWithMaxSize:CGSizeMake(dWidth-X*2, MAXFLOAT) fontSize:labelFont];
//    self.houseInfoLabel.frame = CGRectMake(X,LY, dWidth-X, infoSize.height);
//    self.houseInfoLabel.text = self.houseMaodel.houseInfo;
//    [self.view addSubview:self.houseInfoLabel];
//
//}

- (AJNewHouseModel *)houseMaodel{
    if (_houseMaodel ==nil) {
        _houseMaodel = [AJNewHouseModel new];
    }
    return _houseMaodel;
}

- (NSMutableArray <AJEstateInfoModal *> *)dataArray{
    if (_dataArray ==nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
