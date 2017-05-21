//
//  AJHouseDesViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/14.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseDesViewController.h"
#import "PreviewUpLoadCollectionViewCell.h"
#import "AJUploadPicModel.h"


@interface AJHouseDesViewController ()<CTCustomAlbumViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colView;

@property (strong, nonatomic) NSMutableArray <AJUploadPicModel *> *dataArray;

@end

@implementation AJHouseDesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"房屋详情完善";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保存" target:self sel:@selector(saveHouseData)]];
    
    [self.colView registerNib:[UINib nibWithNibName:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class])];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PreviewUpLoadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.modal = self.dataArray[indexPath.row];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(dWidth/3, dWidth/3);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *show = [NSMutableArray new];
    for (AJUploadPicModel *modal in self.dataArray) {
        NSString *filePath = [CTTool imagePathWithImageName:modal.picFile.name];
        NSData *imgData = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [UIImage imageWithData:imgData];
        [show addObject:img];
    }
    
    [[CTImagePreviewViewController defaultShowPicture] showPictureWithUrlOrImages:show withCurrentPageNum:indexPath.row+1 andRootViewController:self];
}
- (void)saveHouseData{
    NSMutableDictionary *houseDes = [NSMutableDictionary new];
    [houseDes setObject:@"证满五年"      forKey:YEARS_DES];
    [houseDes setObject:@"随时看房"      forKey:WATCH_DES];
    [houseDes setObject:@"精装修"        forKey:DECORATE_DES];
    [self.houseObj setObject:houseDes forKey:HOUSE_DESCRIBE];

  
    NSMutableArray *imgArray = [NSMutableArray new];
    for (AJUploadPicModel *modal in self.dataArray) {
        if (modal.state.integerValue!=2) {
            [self.view showTips:@"图片未全部上传" withState:TYKYHUDModeWarning complete:nil];
            break;
        }
        [imgArray addObject:modal.picFile.objectId];
    }
    [self.houseObj setObject:self.dataArray[0].picFile.url                 forKey:HOUSE_THUMB];
    [self.houseObj setObject:imgArray         forKey:HOUSE_FILE_ID];

    //先上传图片
    //    [house setObject:@[@""]     forKey:HOUSE_PICTURE];
    //    [houseData setObject:@"一单元"           forKey:HOUSE_UNIT];
    //    [houseData setObject:@"1101"            forKey:HOUSE_NUMBER];
    
    [self.view showHUD:@"正在保存..."];
    WeakSelf;

    [self.houseObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];

        if (!succeeded) {
            [weakSelf.view showTips:@"保存失败" withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        [weakSelf.view showTips:@"保存成功" withState:TYKYHUDModeSuccess complete:^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewHouseNotification object:nil];
                
            }];
        }];

    }];

}
- (IBAction)choosePicAction:(UIButton *)sender {
    if (self.dataArray.count==9) {
        [self.view showTips:@"最多上传9张图片" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    CTCustomAlbumViewController *album = [CTCustomAlbumViewController new];
    album.delegate = self;
    album.totalNum = 9 - self.dataArray.count;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - CTCustomAlbumViewControllerDelegate
- (void)sendImageDictionary:(NSDictionary *)imageDic{

    for (NSString *imgName in imageDic.allKeys) {
        UIImage *img = [CTTool imageCompressForWidth:imageDic[imgName] targetWidth:500];
        NSString *timeName = [NSString stringWithFormat:@"%f_%@",[NSDate new].timeIntervalSince1970,imgName];
        AJUploadPicModel *upload = [AJUploadPicModel new];
        
        NSData *imgData = UIImageJPEGRepresentation(img, 0.6);
        NSString *filePath = [CTTool imagePathWithImageName:timeName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [imgData writeToFile:filePath atomically:YES];
            
        }
        AVFile *file = [AVFile fileWithName:timeName data:imgData];
        upload.picFile = file;
        [self.dataArray addObject:upload];
    }
    [self.colView reloadData];

}

- (NSMutableArray <AJUploadPicModel *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
