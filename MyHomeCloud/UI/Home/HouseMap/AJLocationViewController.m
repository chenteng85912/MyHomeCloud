//
//  TYKYLocationViewController.m
//  webhall
//
//  Created by tjsoft on 2017/6/12.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJLocationViewController.h"
#import "AJLocation.h"

@interface AJLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AJLocationViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.houseObj[HOUSE_ESTATE_NAME];
    
    [self showLocation];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)showNavigation{
    //当前位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //目的地位置
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([self.houseObj[HOUSE_LATITUDE] doubleValue],[self.houseObj[HOUSE_LONGITUDE] doubleValue]);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
    toLocation.name = self.houseObj[HOUSE_ESTATE_NAME];
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}
//展示位置信息
- (void)showLocation{
    //创建CLLocation 设置经纬度
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[self.houseObj[HOUSE_LATITUDE] doubleValue] longitude:[self.houseObj[HOUSE_LONGITUDE] floatValue]];
    CLLocationCoordinate2D coord = [loc coordinate];
    
    //创建标题
    AJLocation *myPoint = [[AJLocation alloc] initWithCoordinate:[loc coordinate] andTitle:self.houseObj[HOUSE_ESTATE_NAME]];
   
    //添加标注
    [self.mapView addAnnotation:myPoint];
    
    //标题和子标题自动显示
    [self.mapView selectAnnotation:myPoint animated:YES];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.mapView setRegion:region animated:YES];
}
#pragma mark - event response

#pragma mark - private methods
- (IBAction)autoLoactionAction:(UIButton *)sender {
    if (sender.tag==0) {
        [self showLocation];

    }else{
        [self showNavigation];
    }

}

#pragma mark - getters and setters

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
