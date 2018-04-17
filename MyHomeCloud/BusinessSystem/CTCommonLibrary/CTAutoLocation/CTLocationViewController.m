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
#import "UIAlertController+CTAlertBlock.h"
#import "CTLocationNavController.h"

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

static NSString *identify = @"locationCell";

//需要遵守CLLocationManagerDelegate协议
@interface CTLocationViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *autoLocationBtn;//自动定位按钮
@property (weak, nonatomic) IBOutlet UIView *headView;//头部视图
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;//回到顶部按钮
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) CLLocationManager *manager;//定位控制
@property (strong, nonatomic) NSArray <NSString *>*sectionArray;//索引数组
@property (strong, nonatomic) NSDictionary <NSString *,NSArray *>*allDataDic;//所有城市字典，字母对应数组
@property (strong, nonatomic) NSMutableDictionary <NSString *, NSString *>*chinesePinyin;//拼音对应中文，城市字典

@property (weak, nonatomic) id<CTLocationViewControllerDelegate>delegate;

@end

@implementation CTLocationViewController

+ (void)showLocationVC_WithDelegate:(id <CTLocationViewControllerDelegate>)rootVC{
    
    CTLocationViewController *location = [CTLocationViewController new];
    location.delegate = rootVC;
    CTLocationNavController *nav = [[CTLocationNavController alloc] initWithRootViewController:location];
    
    UIViewController *keywindow = [self p_currentViewController];
    if (keywindow) {
        [keywindow presentViewController:nav animated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择城市";
    
    self.autoLocationBtn.layer.masksToBounds = YES;
    self.autoLocationBtn.layer.cornerRadius = 5.0;
    self.autoLocationBtn.layer.borderWidth = 0.5;
    self.autoLocationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ct_close_location"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPre)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //索引颜色，背景
    self.tbView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tbView.sectionIndexColor = [UIColor colorWithRed:24.0/255.0 green:152.0/255 blue:1 alpha:1];
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:identify];
    self.tbView.estimatedSectionHeaderHeight=0;
    self.tbView.estimatedSectionFooterHeight=0;
    
    [self initHotCity];
    [self checkLocation];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchAllCityData];

}
#pragma mark 初始化本地城市列表
- (void)fetchAllCityData{
    [self.view bringSubviewToFront:self.indicator];
    [self.indicator startAnimating];

    NSArray *resultCity =  [ChineseTransform initCityDataFromLocal];
    if (!resultCity) {
        [self.indicator stopAnimating];
        return;
    }
    self.chinesePinyin = [NSMutableDictionary new];
    NSMutableArray *pinyinArray = [NSMutableArray new];
    for (NSString *chinese in resultCity) {
        NSString *pinyin = [ChineseTransform chineseTransToPinyin:chinese];
        [self.chinesePinyin setObject:chinese forKey:pinyin];
        [pinyinArray addObject:pinyin];
    }
    self.allDataDic = [ChineseTransform makeResultCityDictionary:pinyinArray];

    self.sectionArray = [ChineseTransform arrangeWithPINYIN:self.allDataDic.allKeys];

    [self.indicator stopAnimating];
    [self.tbView reloadData];
    
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
- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)showAlertView{
    
    [UIAlertController alertWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" cancelButtonTitle:@"暂不" otherButtonTitles:@[@"去设置"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
            NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }
    }];
 

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
        
        but.titleLabel.font = [UIFont systemFontOfSize:Device_width==320?13:15];
        [but setTitle:hotCity[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        but.backgroundColor = [UIColor whiteColor];
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 5.0;
        but.layer.borderColor = [UIColor lightGrayColor].CGColor;
        but.layer.borderWidth = 0.5;
        
        [self.headView addSubview:but];
        
    }
    self.tbView.tableHeaderView = self.headView;
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
    [self backToPre];
  
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.sectionArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *cityArray = self.allDataDic[self.sectionArray[section]];
    return cityArray.count;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 25;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.01;
    
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

    NSString *title = self.sectionArray[indexPath.section];
    NSArray *pinyinArray = self.allDataDic[title];
    
    mycell.textLabel.text = self.chinesePinyin[pinyinArray[indexPath.row]];

    return mycell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *mycell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(sendCityName:)]) {
        [self.delegate sendCityName:mycell.textLabel.text];
    }
    [self backToPre];

}

#pragma mark 添加索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return  self.sectionArray;
   
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    return index;
}

#pragma mark 索引名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    return self.sectionArray[section];
    
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
//获取最顶部控制器
+ (UIViewController *)p_currentViewController {
    
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        }else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }else if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [CLLocationManager new];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];//第一次启动时弹出使用位置的提示框
        
    }
    return _manager;
}

@end
