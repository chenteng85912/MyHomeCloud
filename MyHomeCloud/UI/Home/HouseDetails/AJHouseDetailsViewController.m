//
//  AJHouseDetailsViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDetailsViewController.h"

@interface AJHouseDetailsViewController ()

@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) AVObject *likedObj;

@end

@implementation AJHouseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ %@ %@万",self.houseInfo[HOUSE_ESTATE_NAME],self.houseInfo[HOUSE_AMOUNT],self.houseInfo[HOUSE_TOTAL_PRICE]];
//    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [self.rightBtn setImage:LOADIMAGE(@"unlike") forState:UIControlStateNormal];
//    [self.rightBtn setImage:LOADIMAGE(@"liked") forState:UIControlStateSelected];
//    
//    [self.rightBtn addTarget:self action:@selector(addLikeHouse) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
//    
//    [self checkLikeState];
}
- (void)checkLikeState{
    
    [self.view showHUD:nil];
    
    self.baseQuery.className = FAVORITE_HOUSE;
    [self.baseQuery whereKey:USER_PHONE equalTo:[AVUser currentUser].mobilePhoneNumber];
    [self.baseQuery whereKey:HOUSE_ID equalTo:self.houseInfo.objectId];
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.view removeHUD];
        if (objects.count>0) {
            self.likedObj = objects[0];
            self.rightBtn.selected = YES;
        }else{
            self.rightBtn.selected = NO;

        }
    }];

}
- (void)addLikeHouse{
    WeakSelf;

    if (self.rightBtn.selected) {
        [self.likedObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                self.rightBtn.selected = NO;
                self.likedObj = nil;
            }
        }];

    }else{
        AVObject *houseInfo = [[AVObject alloc] initWithClassName:FAVORITE_HOUSE];

        [houseInfo setObject:self.houseInfo.objectId forKey:HOUSE_ID];
        [houseInfo setObject:[AVUser currentUser].mobilePhoneNumber forKey:USER_PHONE];
        
        [houseInfo setObject:[AVObject objectWithClassName:HOUSE_INFO objectId:self.houseInfo.objectId] forKey:HOUSE_OBJECT];
        
        [houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                weakSelf.likedObj = houseInfo;
                weakSelf.rightBtn.selected = YES;
            }

        }];
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
