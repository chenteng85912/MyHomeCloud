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

@interface AJAddPicturesViewController ()<CTCustomAlbumViewControllerDelegate>
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
    
    [self.colloctionView registerClass:[AJPicCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AJPicCollectionReusableView class])];
    
    self.colloctionView.alwaysBounceVertical = YES;

    if (self.isEditModal) {
        [self setupLongPressGesture];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保 存" target:self sel:@selector(saveAction)]];

    }

    [self initDataArray];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)initDataArray{

    if (self.houseInfo) {
        NSArray *array1 = self.houseInfo[ESTATE_SCENE_PIC];
        [self.dataArray addObject:[self creatUploadData:array1]];
        
        NSArray *array2 = self.houseInfo[ESTATE_EFFECT_PIC];
        [self.dataArray addObject:[self creatUploadData:array2]];
        
        NSArray *array3 = self.houseInfo[ESTATE_SUPPORT_PIC];
        [self.dataArray addObject:[self creatUploadData:array3]];
        
        NSArray *array4 = self.houseInfo[ESTATE_FACT_PIC];
        [self.dataArray addObject:[self creatUploadData:array4]];
        
        [self.colloctionView reloadData];
    }
}
- (NSMutableArray <AJUploadPicModel *>*)creatUploadData:(NSArray *)array{
    NSMutableArray <AJUploadPicModel *> *temp = [NSMutableArray new];
    for (NSString *picUrl in array) {
        AJUploadPicModel *upload = [AJUploadPicModel new];
        
        upload.picUrl = picUrl;
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
    cell.modal = self.dataArray[indexPath.section][indexPath.row];
    if (self.isEditModal) {
        cell.selectBtn.hidden = NO;
        cell.selectBtn.tag = indexPath.row+indexPath.section*100;
        BUTTON_ACTION(cell.selectBtn, self, @selector(deleteCellAction:));

    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *show = [NSMutableArray new];
    for (AJUploadPicModel *modal in self.dataArray) {
        UIImage *img = [UIImage imageWithData:modal.picFile.getData];
        
        [show addObject:img];
    }
    
    [[CTImagePreviewViewController defaultShowPicture] showPictureWithUrlOrImages:show withCurrentPageNum:indexPath.row andRootViewController:self];
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(dWidth/3, dWidth/3);
}

//动态设置某组头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(dWidth, 40);
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
    [AJSB deleteFile:modal.picFile.objectId complete:^{
        [weakSelf.view removeHUD];
        [weakSelf removeCollectionItem:index];
        
    }];
    
}
//删除单元格动画
- (void)removeCollectionItem:(NSInteger)index{
    NSInteger section = index/100;
    NSInteger item = index%100;
    WeakSelf;
    [self.colloctionView performBatchUpdates:^{
        
        [weakSelf.dataArray[section] removeObjectAtIndex:index];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:item inSection:section];
        
        [weakSelf.colloctionView deleteItemsAtIndexPaths:@[indexpath]];
        
    } completion:^(BOOL finished) {
       
        [weakSelf.colloctionView reloadData];
        
    }];
}
- (void)addNewPicture:(UIButton *)btn{
    NSMutableArray *temp = self.dataArray[btn.tag];
    _currentSecion = btn.tag;
    if (temp.count==12) {
        [self.view showTips:@"最多上传12张图片" withState:TYKYHUDModeWarning complete:nil];
        return;
    }
    CTCustomAlbumViewController *album = [CTCustomAlbumViewController new];
    album.delegate = self;
    album.totalNum = 12 - temp.count;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma  mark - CTCustomAlbumViewControllerDelegate
//传出图片字典，key为图片名称，value为对应的图片
- (void)sendImageDictionary:(NSDictionary <NSString*,UIImage*> *)imageDic{
    [self.view showHUD:nil];
    [self performSelector:@selector(addPictureData:) withObject:imageDic afterDelay:0];
}
//上传图片
- (void)addPictureData:(NSDictionary *)imageDic{
    for (NSString *imgName in imageDic.allKeys) {
        UIImage *img = [CTTool imageCompressForWidth:imageDic[imgName] targetWidth:500];
        NSString *timeName = [NSString stringWithFormat:@"%f_%@",[NSDate new].timeIntervalSince1970,imgName];
        AJUploadPicModel *upload = [AJUploadPicModel new];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.6);
        
        AVFile *file = [AVFile fileWithName:timeName data:imgData];
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
    id objc = self.dataArray[sourceIndexPath.section][sourceIndexPath.row];
    //从资源数组中移除该数据
    [self.dataArray[sourceIndexPath.section] removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray[sourceIndexPath.section] insertObject:objc atIndex:destinationIndexPath.item];
    [self.colloctionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    
}
- (void)saveAction{
    [self.houseInfo setObject:self.dataArray[0] forKey:ESTATE_SCENE_PIC];
    [self.houseInfo setObject:self.dataArray[1] forKey:ESTATE_EFFECT_PIC];
    [self.houseInfo setObject:self.dataArray[2] forKey:ESTATE_SUPPORT_PIC];
    [self.houseInfo setObject:self.dataArray[3] forKey:ESTATE_FACT_PIC];

    [KEYWINDOW showHUD:@"正在保存..."];
    [self.houseInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [KEYWINDOW removeHUD];
        if (!succeeded) {
            [KEYWINDOW showTips:@"保存失败" withState:TYKYHUDModeFail complete:nil];
            return ;
        }
        [KEYWINDOW showTips:@"保存成功" withState:TYKYHUDModeFail complete:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    }];

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
