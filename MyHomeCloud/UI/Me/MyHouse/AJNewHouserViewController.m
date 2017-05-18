//
//  AJNewHouserViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouserViewController.h"
#import "AJHouseDesViewController.h"

@interface AJNewHouserViewController ()<CTONEPhotoDelegate>

@property (strong, nonatomic) AVObject *houseData;
@property (strong, nonatomic) NSArray *houseNameArray;

@end

@implementation AJNewHouserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加房源";
    self.houseNameArray = @[@"鼎峰品筑",@"鼎峰尚镜",@"鼎峰卡布斯",@"鼎峰金椅豪园"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"下一步" target:self sel:@selector(addHomeDes)]];
}

//保存房源
- (AVObject *)creatHouseInfo{

    AVObject *houseData = [AVObject objectWithClassName:HOUSE_INFO];
    [houseData setObject:[AVUser currentUser].mobilePhoneNumber      forKey:USER_PHONE];

    [houseData setObject:@"30"          forKey:HOUSE_TOTAL_FLOOR];
    [houseData setObject:self.houseNameArray[arc4random() % 3]      forKey:HOUSE_ESTATE_NAME];
    [houseData setObject:@"鼎峰集团"      forKey:HOUSE_DEVELOPER];
    [houseData setObject:@"12"          forKey:HOUSE_BUILD_NUMBER];
    [houseData setObject:@"12"              forKey:HOUSE_FLOOR_NUM];
    [houseData setObject:@"3房2厅"           forKey:HOUSE_AMOUNT];

    [houseData setObject:@"一单元"           forKey:HOUSE_UNIT];
    [houseData setObject:@"1101"            forKey:HOUSE_NUMBER];
    [houseData setObject:@"寮步镇"           forKey:HOUSE_AREA];
    [houseData setObject:[NSString stringWithFormat:@"%d",(arc4random() % 80) + 70]             forKey:HOUSE_AREAAGE];
    [houseData setObject:[NSString stringWithFormat:@"%d",(arc4random() % 100) + 100]           forKey:HOUSE_TOTAL_PRICE];
    [houseData setObject:[NSString stringWithFormat:@"%d",(arc4random() % 3000) + 13000]        forKey:HOUSE_UNIT_PRICE];

    //缩略图
//    if (imgFile) {
//        [houseData setObject:imgFile.url                 forKey:HOUSE_THUMB];
//        [houseData setObject:@[imgFile.objectId]         forKey:HOUSE_FILE_ID];
//
//    }

    //先上传图片
//    [house setObject:@[@""]     forKey:HOUSE_PICTURE];
    return houseData;
}
- (IBAction)chooseImage:(id)sender {
    [UIAlertController alertWithTitle:@"上传图片" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册选取"] preferredStyle:UIAlertControllerStyleActionSheet block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [CTONEPhoto shareSigtonPhoto].delegate = self;
            [[CTONEPhoto shareSigtonPhoto] openCamera:self editModal:NO];
        }else if (buttonIndex==2){
            [CTONEPhoto shareSigtonPhoto].delegate = self;
            [[CTONEPhoto shareSigtonPhoto] openAlbum:self editModal:NO];
        }
    }];

}
#pragma mark - CTONEPhotoDelegate
- (void)sendOnePhoto:(UIImage *)image withImageName:(NSString *)imageName;{
    [self saveHouseImage:[CTTool imageCompressForWidth:image targetWidth:300]];
    
}
#pragma mark 上传用户头像
- (void)saveHouseImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    NSString *name = [NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]];
    AVFile *file = [AVFile fileWithName:name data:imgData];
    
    [CTTool showKeyWindowHUD:@"正在上传..."];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [CTTool removeKeyWindowHUD];
        if (!succeeded) {
            [self.view showTips:@"上传失败，请重试" withState:TYKYHUDModeSuccess complete:nil];
            
            return;
        }

    }];
}
- (void)addHomeDes{
    AJHouseDesViewController *des = [AJHouseDesViewController new];
    des.houseObj = [self creatHouseInfo];
    
    APP_PUSH(des);
}


- (void)uploadThumb:(UIImage *)img{
    
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
