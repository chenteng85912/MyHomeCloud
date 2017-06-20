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
#import "AJLocalDataCenter.h"

NSString *const TITLE_KEY = @"titleName";
NSString *const CONTENT_KEY = @"content";


@interface AJEstateDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UILabel *houseRooms;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaage;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) AJLocationViewController *mapView;
@property (strong, nonatomic) NSMutableArray <AJEstateInfoModal *> *dataArray;

@end

@implementation AJEstateDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _houseRooms.text = _houseInfo[HOUSE_AMOUNT];
    _houseAreaage.text = _houseInfo[HOUSE_AREAAGE];
    _houseAreaage.text = [NSString stringWithFormat:@"%@m²",_houseInfo[HOUSE_AREAAGE]];

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
//获取数据
- (void)fetchHouseInfo{
    if (!_isFromReserver) {
        NSArray *houseInfo = [AJLocalDataCenter readLocalHouseInfo:_houseInfo[ESTATE_ID]];
        if (houseInfo) {
            [self refreshView:houseInfo];
            return;
        }
    }
   
    [self.view showHUD:nil];
    self.baseQuery.className = ALL_HOUSE_INFO;
    WeakSelf;
    [self.baseQuery getObjectInBackgroundWithId:_houseInfo[ESTATE_ID] block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (!object) {
            [self.view showTips:@"数据加载失败" withState:TYKYHUDModeFail complete:nil];
            return ;
        }
        self.mapView.houseObj = object;

        [weakSelf creatHouseInfo:object];
        
    }];
    
}
//刷新界面
- (void)refreshView:(NSArray *)houseInfo{
   
    for (NSDictionary *dic in houseInfo) {
        if ([dic[TITLE_KEY] isEqualToString:@"核心卖点"]&&_detailsModal == LetModal) {
            continue;
        }
        AJEstateInfoModal *modal = [[AJEstateInfoModal alloc] initValueWithDictionary:dic];
        [modal calculateSizeConstrainedToSize];
        [self.dataArray addObject:modal];
    }
    
    if (_isFromReserver) {
        _mapBackView.hidden = NO;
        self.mapView.view.frame = CGRectMake(0, 40, dWidth, 200);
        [_mapBackView addSubview:self.mapView.view];
        self.mapView.locationBtn.hidden = YES;
        self.mapView.navBtn.hidden = YES;
        [_mapBackView bringSubviewToFront:_mapBtn];
        self.tbView.tableFooterView = _mapBackView;
        
    }
    self.tbView.tableHeaderView = _headView;
    [self.tbView reloadData];

}
//生成数据
- (void)creatHouseInfo:(AVObject *)object{
   
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    if (_detailsModal == SecondModal) {
        [infoDic setObject:object[HOUSE_SALES_POINT] forKey:CONTENT_KEY];
        [infoDic setObject:@"核心卖点" forKey:TITLE_KEY];
        [temp addObject:infoDic];
    }
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[ESTATE_INTR] forKey:CONTENT_KEY];
    [infoDic setObject:@"小区介绍" forKey:TITLE_KEY];
    [temp addObject:infoDic];
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[TRAFFIC_INFO] forKey:CONTENT_KEY];
    [infoDic setObject:@"交通出行" forKey:TITLE_KEY];
    [temp addObject:infoDic];
    
    infoDic = [NSMutableDictionary new];
    [infoDic setObject:object[SUPPORT_MEASURES] forKey:CONTENT_KEY];
    [infoDic setObject:@"周边配套" forKey:TITLE_KEY];
    [temp addObject:infoDic];
    
    [AJLocalDataCenter saveLocalHouseInfo:temp withHouseId:object.objectId];
    [self refreshView:temp];
}

- (IBAction)btnAction:(UIButton *)sender {
    _mapView =nil;
    APP_PUSH(self.mapView);
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
