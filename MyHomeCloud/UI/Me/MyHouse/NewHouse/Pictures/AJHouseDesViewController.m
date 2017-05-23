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
    
    self.colView.alwaysBounceVertical = YES;
    [self setupLongPressGesture];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataArray.count==0) {
        [self.colView addTipView:@"暂无图片"];
    }
}
- (void)backToPreVC{
    if (self.dataArray.count>0) {
       
        [UIAlertController alertWithTitle:@"温馨提示" message:@"退出将丢失已经上传的图片，是否退出?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                for (AJUploadPicModel *model in self.dataArray) {
                    [CTTool deleteFile:model.picFile.objectId complete:nil];

                }
                POPVC;

            }
        }];
        return;
    }
    POPVC;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PreviewUpLoadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.modal = self.dataArray[indexPath.row];
    cell.selectBtn.tag = indexPath.row;
    BUTTON_ACTION(cell.selectBtn, self, @selector(deleteCellAction:));
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(dWidth/3, dWidth/3);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

   
    NSMutableArray *show = [NSMutableArray new];
    for (AJUploadPicModel *modal in self.dataArray) {
        UIImage *img = [UIImage imageWithData:modal.picFile.getData];
        
        [show addObject:img];
    }
    
    [[CTImagePreviewViewController defaultShowPicture] showPictureWithUrlOrImages:show withCurrentPageNum:indexPath.row andRootViewController:self];
}
//保存房屋信息
- (void)saveHouseData{
    if (self.dataArray.count==0) {
        [self.view showTips:@"暂未上传图片" withState:TYKYHUDModeWarning complete:nil];

        return;
    }
    if (self.dataArray.count<6) {
        [self.view showTips:@"请至少上传6张图片" withState:TYKYHUDModeWarning complete:nil];

        return;
    }
    NSMutableDictionary *houseDes = [NSMutableDictionary new];
    [houseDes setObject:@"证满五年"      forKey:YEARS_DES];
    [houseDes setObject:@"随时看房"      forKey:WATCH_DES];
    [houseDes setObject:@"精装修"        forKey:DECORATE_DES];
    [self.houseObj setObject:houseDes forKey:HOUSE_DESCRIBE];

    if (![self checkAllPicture]) {
        [self.view showTips:@"图片未全部上传成功" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
   
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
//检测是否有图片还在上传
- (BOOL)checkAllPicture{
    BOOL success = YES;
    NSMutableArray *imgArray = [NSMutableArray new];
    for (AJUploadPicModel *modal in self.dataArray) {
        if (modal.state.integerValue!=2) {
            success = NO;
            break;
        }
        [imgArray addObject:modal.picFile.objectId];
    }
   
    if (success) {
        [self.houseObj setObject:self.dataArray[0].picFile.url                 forKey:HOUSE_THUMB];
        [self.houseObj setObject:imgArray         forKey:HOUSE_FILE_ID];
    }
   
    return success;
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

    [self.view showHUD:nil];
    [self performSelector:@selector(creatUploadData:) withObject:imageDic afterDelay:0];

}
//上传图片
- (void)creatUploadData:(NSDictionary *)imageDic{
    for (NSString *imgName in imageDic.allKeys) {
        UIImage *img = [CTTool imageCompressForWidth:imageDic[imgName] targetWidth:500];
        NSString *timeName = [NSString stringWithFormat:@"%f_%@",[NSDate new].timeIntervalSince1970,imgName];
        AJUploadPicModel *upload = [AJUploadPicModel new];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.6);
       
        AVFile *file = [AVFile fileWithName:timeName data:imgData];
        upload.picFile = file;
        [self.dataArray addObject:upload];
    }
    [self.view removeHUD];
    if (self.dataArray.count>0) {
        [self.colView hiddenTipsView];

    }
    [self.colView reloadData];
}
- (void)deleteCellAction:(UIButton *)btn{
    AJUploadPicModel *modal = self.dataArray[btn.tag];
    if (modal.state.integerValue==2) {
        WeakSelf;
        [UIAlertController alertWithTitle:@"温馨提示" message:@"该图片已上传,是否删除?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [weakSelf deleteCell:btn.tag];
            }
        }];

    }else{
        [self removeCollectionItem:btn.tag];

    }
    
}
- (void)deleteCell:(NSInteger)index{
    AJUploadPicModel *modal = self.dataArray[index];

    WeakSelf;
    [self.view showHUD:nil];
    [CTTool deleteFile:modal.picFile.objectId complete:^{
        [weakSelf.view removeHUD];
        [weakSelf removeCollectionItem:index];

    }];
   
}
//删除单元格动画
- (void)removeCollectionItem:(NSInteger)index{
    WeakSelf;
    [self.colView performBatchUpdates:^{
        [weakSelf.dataArray removeObjectAtIndex:index];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [weakSelf.colView deleteItemsAtIndexPaths:@[indexpath]];
        
    } completion:^(BOOL finished) {
        if (weakSelf.dataArray.count==0) {
            [weakSelf.colView addTipView:@"暂无图片"];
        }
        [weakSelf.colView reloadData];
        
    }];
}

#pragma mark 拖动单元格
// 设置手势
- (void)setupLongPressGesture
{
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    
    [self.colView addGestureRecognizer:longPress];
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.colView indexPathForItemAtPoint:[longGesture locationInView:self.colView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.colView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.colView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.colView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.colView endInteractiveMovement];
            break;
        default:
            [self.colView cancelInteractiveMovement];
            break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isMove = YES;
    for (AJUploadPicModel *modal in self.dataArray) {
        if (modal.state.integerValue==1) {
            isMove = NO;
            break;
        }
        
    }
    if (isMove) {
        return YES;
    }else{
        [self.view showTips:@"图片正在上传，禁止拖动" withState:TYKYHUDModeWarning complete:nil];
        return NO;
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    //取出源item数据
    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
    [_colView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    
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
