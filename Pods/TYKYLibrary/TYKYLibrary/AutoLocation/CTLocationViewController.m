//
//  LocationViewController.m
//
//  Created by Chenteng on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CTLocationViewController.h"
#import "ChineseTransform.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width
static NSString *identify = @"location";

//需要遵守CLLocationManagerDelegate协议
@interface CTLocationViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *autoLocationBtn;//自动定位按钮
@property (weak, nonatomic) IBOutlet UIView *headView;//头部视图，单元格重用，需要强引用
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;//回到顶部按钮
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UISearchDisplayController *searchDisplay;//搜索控制器
@property (strong, nonatomic) CLLocationManager *manager;//定位控制
@property (strong, nonatomic) NSArray *resultArray;//搜索结果
@property (strong, nonatomic) NSMutableArray *sectionArray;//索引数组
@property (strong, nonatomic) NSMutableDictionary *allDataDic;//所有城市字典，字母对应数组
@property (strong, nonatomic) NSMutableDictionary *chinesePinyin;//拼音对应中文，城市字典


@end

@implementation CTLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    self.autoLocationBtn.layer.masksToBounds = YES;
    self.autoLocationBtn.layer.cornerRadius = 5.0;
    self.autoLocationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.autoLocationBtn.layer.borderWidth = 0.5;
    
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_location"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 2, 2, 6);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //索引颜色，背景
    self.tbView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tbView.sectionIndexColor = [UIColor colorWithRed:24.0/255.0 green:152.0/255 blue:1 alpha:1];
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:identify];
    
    //搜索控制里面的tableView 注册单元格
    [self.searchDisplay.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identify];
    
    [self initHotCity];
    [self fetchAllCityData];
    
}

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [CLLocationManager new];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];//第一次启动时弹出使用位置的提示框

    }
    return _manager;
}
#pragma mark 初始化本地城市列表
- (void)fetchAllCityData{
    [self.indicator startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *resultCity =  [ChineseTransform initCityDataFromLocal];
        if (!resultCity) {
            [self.indicator stopAnimating];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.chinesePinyin = [NSMutableDictionary new];
            NSMutableArray *pinyinArray = [NSMutableArray new];
            for (NSString *chinese in resultCity) {
                NSString *pinyin = [ChineseTransform chineseTransToPinyin:chinese];
                [self.chinesePinyin setObject:chinese forKey:pinyin];
                [pinyinArray addObject:pinyin];
            }
            self.allDataDic = [[ChineseTransform makeResultCityDictionary:pinyinArray] mutableCopy];
            
            self.sectionArray = [[ChineseTransform arrangeWithPINYIN:self.allDataDic.allKeys] mutableCopy];
            [self.sectionArray insertObject:@"#" atIndex:0];
            [self.indicator stopAnimating];
            [self.tbView reloadData];
            [self checkLocation];
        });
    });
    
}
#pragma mark 开启定位
- (void)checkLocation{
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]){
        //每隔多少米定位一次（这里的设置为任何的移动）
        //self.manager.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电
        //self.manager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        [self changeAutoLocationAction:YES];
        
    }else{
        self.activity.hidden = YES;
        self.autoLocationBtn.selected = YES;
        [self showAlertView];
    }

}
- (void)back{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertView{
    UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
    
    [notiAlert show];

}
#pragma mark 初始化热门城市列表
- (void)initHotCity{
    
    NSArray *hotCity = @[@"北京市",@"上海市",@"广州市",@"深圳市",@"杭州市",@"武汉市",@"天津市",@"重庆市",@"成都市"];
    for (int i = 0;i <hotCity.count;i ++) {
        NSInteger rootY = 120;
        NSInteger row = i/3;
        NSInteger col = i%3;
        NSInteger width = (Device_width-70)/3;
        
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(15 +(15 +width)*col, rootY +(10+40)*row, width, 40)];
        [but addTarget:self action:@selector(sendCityNameToRootVC:) forControlEvents:UIControlEventTouchUpInside];
        
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [but setTitle:hotCity[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        but.backgroundColor = [UIColor whiteColor];
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 5.0;
        but.layer.borderColor = [UIColor lightGrayColor].CGColor;
        but.layer.borderWidth = 0.5;
        
        [self.headView addSubview:but];
        
    }

}
#pragma mark 定位失败
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeAutoLocationAction:NO];
        [self showAlertView];

    });
   
//    NSLog(@"Error: %@",[error localizedDescription]);
//    NSString *errorString;
//    switch([error code]) {
//        case kCLErrorDenied:
//            errorString = @"Access to Location Services denied by user";
//            break;
//        case kCLErrorLocationUnknown:
//            errorString = @"Location data unavailable";
//            break;
//        default:
//            errorString = @"An unknown error has occurred";
//            break;
//    }
}
/**
    53  *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
    54  */
#pragma mark 定位成功回调数据
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
 {

     CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
     CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
     [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self changeAutoLocationAction:NO];
             if (error||placemarks.count==0) {
                 self.autoLocationBtn.selected = YES;
                 self.autoLocationBtn.frame = CGRectMake(15, 40, 160, 40);
                 return;
             }
            
             CLPlacemark *placeMark = placemarks[0];
             
             if (!placeMark.locality) {
                 self.autoLocationBtn.selected = YES;
                 self.autoLocationBtn.frame = CGRectMake(15, 40, 160, 40);
                 
                 return;
             }
             self.autoLocationBtn.selected = NO;
             NSLog(@"定位城市信息:%@",placeMark.addressDictionary);
             self.autoLocationBtn.frame = CGRectMake(15, 40, (Device_width-70)/3, 40);
             //定位到的城市名称 placeMark.locality
             [self.autoLocationBtn setTitle:placeMark.locality forState:UIControlStateNormal];

         });
    }];

 }

#pragma mark 设置变更后返回程序 定位设置变更
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self changeAutoLocationAction:YES];
            break;
        default:
            break;
    }
}
#pragma mark 点击自动定位按钮
- (IBAction)sendLocationOrGoSettingAction:(UIButton *)sender {
    if (sender.selected) {
        if ([CLLocationManager locationServicesEnabled]){
            [self changeAutoLocationAction:YES];
            return;
        }
        [self showAlertView];
        
    }else{
        [self sendCityNameToRootVC:self.autoLocationBtn];
    }
}

#pragma mark  发送城市名称
- (void)sendCityNameToRootVC:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(sendCityName:)]) {
        [self.delegate sendCityName:btn.currentTitle];
    }
    [self back];
}
#pragma mark 打开设置
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tbView) {
        return self.sectionArray.count;

    }
    return 1;
}

#pragma mark UISearchDisplayControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString{
    // 谓词搜索
    NSPredicate *predicate = nil;
    //搜索中文
    if ([ChineseTransform isChinese:searchString]) {
        predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchString];
        self.resultArray =  [[NSArray alloc] initWithArray:[self.chinesePinyin.allValues filteredArrayUsingPredicate:predicate]];
        
    }else{
        //搜索拼音
        predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",searchString];
        self.resultArray =  [[NSArray alloc] initWithArray:[self.chinesePinyin.allKeys filteredArrayUsingPredicate:predicate]];
        
    }

    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tbView) {
        if (section==0) {
            return 1;
        }
        NSArray *cityArray = self.allDataDic[self.sectionArray[section]];
        return cityArray.count;
    }
    
    return self.resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tbView&&indexPath.section==0) {
        return self.headView.frame.size.height;

    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tbView) {
        if (section==0) {
            return 0.01;

        }
        return 20;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (tableView == self.tbView) {
        return 0.01;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    if (!mycell) {
        mycell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    [mycell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    mycell.textLabel.font = [UIFont systemFontOfSize:15];
    mycell.textLabel.text = nil;
    if (tableView == self.tbView) {
        if (indexPath.section==0) {
            self.headView.hidden = NO;
            [mycell.contentView addSubview:self.headView];
            mycell.selectionStyle = UITableViewCellSelectionStyleNone;

        }else{
            NSArray *cityArray = self.allDataDic[self.sectionArray[indexPath.section]];
            NSString *key = cityArray[indexPath.row];
            mycell.textLabel.text = self.chinesePinyin[key];
        }
       
    }else{
        NSString *key = self.resultArray[indexPath.row];
        if ([self.chinesePinyin.allKeys containsObject:key]) {
            mycell.textLabel.text = self.chinesePinyin[key];

        }else{
            mycell.textLabel.text = key;

        }
    }
    return mycell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tbView&&indexPath.section==0) {
        return;
    }
    UITableViewCell *mycell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(sendCityName:)]) {
        [self.delegate sendCityName:mycell.textLabel.text];
    }
    [self back];
}

#pragma mark 添加索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView==self.tbView) {
        return  self.sectionArray;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark 索引名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tbView&&section>0) {
        return self.sectionArray[section];
    }
    return nil;
}

#pragma mark 定位状态
- (void)changeAutoLocationAction:(BOOL)state{
    self.autoLocationBtn.selected = !state;
    self.autoLocationBtn.enabled = !state;
    if (state) {
        [self.manager startUpdatingLocation];
        self.activity.hidden = NO;
        [self.activity startAnimating];
    }else{
    
        [self.manager stopUpdatingLocation];
        [self.activity stopAnimating];
    }
   
}

#pragma mark 滚动到顶部
- (IBAction)scrollToTop:(id)sender {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tbView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        
        if (scrollView.contentOffset.y>self.headView.frame.size.height) {
            self.topBtn.alpha = 1.0;
        }else{
            self.topBtn.alpha = 0.0;
        }
    }];
  
}

//下拉返回
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-164) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
