//
//  AJUploadHomeImagesViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/8/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUploadHomeImagesViewController.h"
#import "PreviewUpLoadCollectionViewCell.h"
#import "AJUploadPicModel.h"

@interface AJUploadHomeImagesViewController ()<CTSendPhotosProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *colView;
@property (strong, nonatomic) NSMutableArray <AJUploadPicModel *> *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation AJUploadHomeImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _uploadBtn.backgroundColor = NavigationBarColor;
    [self.colView registerNib:[UINib nibWithNibName:NSStringFromClass([PreviewUpLoadCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PreviewUpLoadCollectionViewCell class])];
    
    self.colView.alwaysBounceVertical = YES;

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保存" target:self sel:@selector(saveHouseData)]];

    [self fetchData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)backToPreVC{
    if (self.dataArray.count>0) {
        BOOL uploading = NO;
        for (AJUploadPicModel *model in self.dataArray) {
            if (model.state.integerValue==1) {
                uploading = YES;
            }
        }
        if (uploading) {
            [UIAlertController alertWithTitle:@"温馨提示" message:@"图片正在上传，是否退出?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
                if (buttonIndex==1) {
                   
                    POPVC;
                }
            }];
            return;
        }
    }
    POPVC;
}
//获取已经上传的图片
- (void)fetchData{
    [self.view showHUD:nil];

    self.baseQuery.className = AJCLOUD_INFO;
    WeakSelf;
    [self.baseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (objects.count>0) {
            [weakSelf.dataArray addObjectsFromArray:[self creatUploadedData:objects]];
            [weakSelf.colView hiddenTipsView];

        }else{
            [weakSelf.colView addNoDataTipView];
        }
        [weakSelf.colView reloadData];
    }];
}
- (NSMutableArray <AJUploadPicModel *>*)creatUploadedData:(NSArray *)headData{
    NSMutableArray <AJUploadPicModel *> *temp = [NSMutableArray new];
    for (AVObject *obj in headData) {
        AJUploadPicModel *upload = [AJUploadPicModel new];
        upload.orginObj = obj;
        upload.state = @2;
        upload.picUrl = obj[HOME_IMAGE_URL];
        upload.objId = obj[HOUSE_FILE_ID];
        [temp addObject:upload];
    }
    
    return temp;
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
        if (img) {
            [show addObject:img];
        }else if(modal.picUrl){
            [show addObject:modal.picUrl];
            
        }
    }
    
    [CTImagePreviewViewController showPictureWithUrlOrImages:show withCurrentPageNum:indexPath.row];
}

- (IBAction)choosePicAction:(UIButton *)sender {
    if (self.dataArray.count==9) {
        [self.view showTips:@"最多上传9张图片" withState:TYKYHUDModeWarning complete:nil];
        return;
    }

    CTPhotosNavigationViewController *nav = [CTPhotosNavigationViewController initWithDelegate:self];
    [self presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark - CTSendPhotosProtocol
- (void)sendImageDataArray:(NSMutableArray<NSData *> *)imgDataArray{
    
    [self.view showHUD:nil];
    [self performSelector:@selector(creatUnUploadData:) withObject:imgDataArray afterDelay:0];
    
}
//上传图片
- (void)creatUnUploadData:(NSMutableArray<NSData *> *)imgDataArray{

    NSInteger count = imgDataArray.count;
    for (int i = 0; i<count; i++) {
        NSData *imgData = imgDataArray[i];
        NSString *imgName = [NSString stringWithFormat:@"%f_%d",[NSDate new].timeIntervalSince1970,i];
        
        AJUploadPicModel *upload = [AJUploadPicModel new];
        upload.isHome = YES;

        AVFile *file = [AVFile fileWithName:imgName data:imgData];
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
    [modal.orginObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf.view removeHUD];
        if (succeeded) {
            debugLog(@"删除成功");
            [AJSB deleteFile:modal.objId complete:nil];
            [weakSelf removeCollectionItem:index];
        }else{
            [weakSelf.view showTips:@"删除失败" withState:TYKYHUDModeFail complete:nil];

        }
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
