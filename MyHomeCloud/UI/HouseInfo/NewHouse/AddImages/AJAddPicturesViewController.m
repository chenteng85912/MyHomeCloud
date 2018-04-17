//
//  AJAddPicturesViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJAddPicturesViewController.h"
#import "PreviewUpLoadCollectionViewCell.h"
#import "AJPicCollectionReusableView.h"
#import "AJUploadPicModel.h"
#import "AJHouseInfoViewController.h"

@interface AJAddPicturesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *colloctionView;

@property (strong, nonatomic) NSMutableArray <NSMutableArray <AJUploadPicModel *> *> *dataArray;

@property (assign, nonatomic) NSInteger currentSecion;
@end

@implementation AJAddPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"楼盘相册";
    //注册
    [self.colloctionView registerNib:[UINib nibWithNibName:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class])];
    
    [self.colloctionView registerNib:[UINib nibWithNibName:NSStringFromClass([AJPicCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AJPicCollectionReusableView class])];
    
    self.colloctionView.alwaysBounceVertical = YES;

    if (self.isEditModal) {
        [self setupLongPressGesture];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保 存" target:self sel:@selector(saveAction)]];

    }
    _tipLabel.hidden = !self.isEditModal;
    [self initDataArray];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isEditModal) {
        self.colloctionView.frame = CGRectMake(0, 0, dWidth, dHeight-NAVBAR_HEIGHT-40);
    }
}
- (void)initDataArray{

    if (self.houseInfo) {
        NSDictionary *dic1 = self.houseInfo[ESTATE_SCENE_PIC];
        [self.dataArray addObject:[self creatUploadData:dic1]];
        
        NSDictionary *array2 = self.houseInfo[ESTATE_EFFECT_PIC];
        [self.dataArray addObject:[self creatUploadData:array2]];
        
        NSDictionary *array3 = self.houseInfo[ESTATE_SUPPORT_PIC];
        [self.dataArray addObject:[self creatUploadData:array3]];
        
        NSDictionary *array4 = self.houseInfo[ESTATE_FACT_PIC];
        [self.dataArray addObject:[self creatUploadData:array4]];
        
        [self.colloctionView reloadData];
    }
}
- (NSMutableArray <AJUploadPicModel *>*)creatUploadData:(NSDictionary *)dic{
    NSMutableArray <AJUploadPicModel *> *temp = [NSMutableArray new];
    for (NSString *key in dic.allKeys) {
        AJUploadPicModel *upload = [AJUploadPicModel new];
        upload.state = @2;
        upload.picUrl = dic[key];
        upload.objId = key;
        [temp addObject:upload];
    }
   
    return temp;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray[section].count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewUpLoadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) forIndexPath:indexPath];
    AJUploadPicModel *model = self.dataArray[indexPath.section][indexPath.row];
    cell.modal = model;
    cell.selectBtn.hidden = !_isEditModal;
    if (self.isEditModal) {
        cell.selectBtn.tag = indexPath.row+indexPath.section*100;
        BUTTON_ACTION(cell.selectBtn, self, @selector(deleteCellAction:));
    }else{
        cell.progressLabel.hidden = YES;

    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *showArray = [NSMutableArray new];
    NSMutableArray *selArray = self.dataArray[indexPath.section];
    
    for (AJUploadPicModel *modal in selArray) {
    
        [showArray addObject:modal.picUrl];

    }
    
    [CTImagePreviewViewController showPictureWithUrlOrImages:showArray withCurrentPageNum:indexPath.row];
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(dWidth/4, dWidth/4);
}

//动态设置某组头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(dWidth, 50);
}

//头、尾部显示
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader])
    {

        AJPicCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AJPicCollectionReusableView class]) forIndexPath:indexPath];
        headerView.indexPath = indexPath;
        headerView.addBtn.tag = indexPath.section;
        if (self.isEditModal) {
            headerView.addBtn.hidden = NO;
            headerView.addBtn.tag = indexPath.section;
            BUTTON_ACTION(headerView.addBtn, self, @selector(addNewPicture:));

        }
        reusableview = headerView;
        
    }
    
    return reusableview;
}
- (void)deleteCellAction:(UIButton *)btn{
    NSInteger section = btn.tag/100;
    NSInteger item = btn.tag%100;
    
    AJUploadPicModel *modal = self.dataArray[section][item];
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
    NSInteger section = index/100;
    NSInteger item = index%100;
    
    AJUploadPicModel *modal = self.dataArray[section][item];
    
    WeakSelf;
    [self.view showHUD:nil];
    [AJSB deleteFile:modal.objId complete:^(BOOL success, NSError *error) {
        [weakSelf.view removeHUD];
        
        if (success) {
            [weakSelf removeCollectionItem:index];
            if (weakSelf.houseInfoVC) {
                weakSelf.houseInfoVC.isChange = YES;
                if ([weakSelf checkAllPicture]) {
                    [weakSelf.houseInfo saveInBackground];
                    
                }
            }
        }else{
            [weakSelf.view showTips:@"删除失败" withState:TYKYHUDModeFail complete:nil];
        }
    }];
    
}
//删除单元格动画
- (void)removeCollectionItem:(NSInteger)index{
    NSInteger section = index/100;
    NSInteger item = index%100;
    
    WeakSelf;
    [self.colloctionView performBatchUpdates:^{
        [weakSelf.dataArray[section] removeObjectAtIndex:item];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:item inSection:section];
        
        [weakSelf.colloctionView deleteItemsAtIndexPaths:@[indexpath]];
        
    } completion:^(BOOL finished) {
       
        [weakSelf.colloctionView reloadData];
        
    }];
}
- (void)addNewPicture:(UIButton *)btn{
    NSMutableArray *temp = self.dataArray[btn.tag];
    _currentSecion = btn.tag;
    if (temp.count==9) {
        [self.view showTips:@"最多上传9张图片" withState:TYKYHUDModeWarning complete:nil];
        return;
    }

    
    [CTCustomAlbum showCustomAlbumWithBlock:^(NSArray<UIImage *> *imagesArray) {
        [self.view showHUD:nil];
        [self performSelector:@selector(addPictureData:) withObject:imagesArray afterDelay:0];
    }];
}

//上传图片
- (void)addPictureData:(NSMutableArray<UIImage *> *)imgDataArray{
    
    NSInteger count = imgDataArray.count;
    for (int i = 0; i<count; i++) {
        UIImage *image = imgDataArray[i];
        NSString *imgName = [NSString stringWithFormat:@"%f_%d",[NSDate new].timeIntervalSince1970,i];
        
        AJUploadPicModel *upload = [AJUploadPicModel new];
        
        AVFile *file = [AVFile fileWithData:UIImageJPEGRepresentation(image, 1) name:imgName];
        upload.picFile = file;
        [self.dataArray[_currentSecion] addObject:upload];
    }
    [self.view removeHUD];
   
    [self.colloctionView reloadData];
}
#pragma mark 拖动单元格
// 设置手势
- (void)setupLongPressGesture
{
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longPress.minimumPressDuration = 0.3;
    [self.colloctionView addGestureRecognizer:longPress];
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.colloctionView indexPathForItemAtPoint:[longGesture locationInView:self.colloctionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.colloctionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.colloctionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.colloctionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.colloctionView endInteractiveMovement];
            break;
        default:
            [self.colloctionView cancelInteractiveMovement];
            break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isMove = YES;
    NSMutableArray *selArray = self.dataArray[indexPath.section];
    for (AJUploadPicModel *modal in selArray) {
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
    id objc = self.dataArray[sourceIndexPath.section][sourceIndexPath.row];
    //从资源数组中移除该数据
    [self.dataArray[sourceIndexPath.section] removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray[sourceIndexPath.section] insertObject:objc atIndex:destinationIndexPath.item];
    [self.colloctionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    
}
- (void)backToPreVC{
    
    if (!_isEditModal) {
        [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    BOOL uploadSuc = NO;
    for (NSArray *temp in self.dataArray) {
        for (AJUploadPicModel *model in temp) {
            if (model.picFile.objectId) {
                uploadSuc = YES;
                break;
                
            }
            
        }
    }
    if (uploadSuc) {
        
        [UIAlertController alertWithTitle:@"温馨提示" message:@"退出将丢失已经上传的图片，是否退出?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                for (NSArray *temp in self.dataArray) {
                    for (AJUploadPicModel *model in temp) {
                        if (model.picFile.objectId) {
                            [AJSB deleteFile:model.picFile.objectId complete:nil];
                            
                        }
                    }
                }
                [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }];
        return;
    }
    
    [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)saveAction{

    if (![self checkAllPicture]) {
        NSDictionary *imgDic = self.houseInfo[HOUSE_FILE_ID];
        if (imgDic.count==0) {
            [self.view showTips:@"请至少上传一张照片" withState:TYKYHUDModeWarning complete:nil];
        }else{
            [self.view showTips:@"照片未全部上传完成" withState:TYKYHUDModeWarning complete:nil];

        }

        return;
    }
    [KEYWINDOW showHUD:@"正在保存..."];
    WeakSelf;
    [self.houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [KEYWINDOW removeHUD];
        if (!succeeded) {
            [KEYWINDOW showTips:@"保存失败" withState:TYKYHUDModeFail complete:nil];
            return ;
        }
        [KEYWINDOW showTips:@"保存成功" withState:TYKYHUDModeSuccess complete:^{
            weakSelf.houseInfoVC.isChange = YES;

            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewHouseNotification object:nil];

            }];
        }];

    }];

}
//检测是否有图片还在上传
- (BOOL)checkAllPicture{
   
    BOOL success = YES;
    NSMutableDictionary  *imgDic = [NSMutableDictionary new];
    
    for (int i=0;i<self.dataArray.count;i++) {
        NSArray <AJUploadPicModel *> *temp = self.dataArray[i];
        NSMutableDictionary *picDic = [NSMutableDictionary new];

        for (AJUploadPicModel *modal in temp) {
            
            if (modal.state.integerValue!=2) {
                success = NO;
                break;
            }
            [picDic setObject:modal.picUrl forKey:modal.objId];
            [imgDic setObject:modal.picUrl forKey:modal.objId];
        }
        if (i==0) {
            [self.houseInfo setObject:picDic forKey:ESTATE_SCENE_PIC];
            
        }else if (i==1) {
            [self.houseInfo setObject:picDic forKey:ESTATE_EFFECT_PIC];
            
        }else if (i==2) {
            [self.houseInfo setObject:picDic forKey:ESTATE_SUPPORT_PIC];
            
        }else{
            [self.houseInfo setObject:picDic forKey:ESTATE_FACT_PIC];

        }
    }
   
    if (success) {
        
        [self.houseInfo setObject:imgDic.allValues[0]     forKey:HOUSE_THUMB];
        [self.houseInfo setObject:imgDic        forKey:HOUSE_FILE_ID];
    }
    
    return success;
}
- (NSMutableArray <NSMutableArray <AJUploadPicModel *>*> *)dataArray{
    if (_dataArray==nil) {
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
