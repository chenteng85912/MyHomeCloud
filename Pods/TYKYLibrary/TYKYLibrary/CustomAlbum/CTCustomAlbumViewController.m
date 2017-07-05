//
//  GroupAlbumViewController.m
//
//  Created by 腾 on 15/9/15.
//
//

#import "CTCustomAlbumViewController.h"
#import "AlbumCollectionViewCell.h"
#import "ListGroupViewController.h"
#import "BigCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CTSavePhotos.h"
#import "UIImage+Tools.h"

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface CTCustomAlbumViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ListGroupViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,BigCollectionViewControllerDelegate>

@property (nonatomic,strong) UICollectionView *ColView;
@property (nonatomic,strong) UILabel *titleLabel;//标题
@property (nonatomic,strong) UIImageView *titleLImg;//标题小箭头
@property (nonatomic,strong) UIButton *titleBtn;//标题按钮
@property (nonatomic,strong) UIView *waringView;//提示警告
@property (nonatomic,strong) UIView *backView;//底部蒙层

@property (nonatomic,strong) ListGroupViewController *albumGroup;//相册列表
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic,strong) NSMutableArray <ALAsset *> *albumArray;//相册数组

@property (nonatomic,assign) BOOL isLoad;
@property (nonatomic,assign) NSInteger selectedNum;//选中照片数量

@end

@implementation CTCustomAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if (![[CTSavePhotos new] checkAuthorityOfAblum]) {
        return;
    }
    [self initCollectionView];//初始化相册
    [self initAlbumGroupData];//初始化相册列表
    [self initNavigationItem];//初始化导航栏按钮
    
    [self.view bringSubviewToFront:self.waringView];

}
#pragma mark 初始化导航栏按钮
- (void)initNavigationItem{
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreVC)];
    
    NSString *rightTitle = [NSString stringWithFormat:@"确认(%ld/%ld)",(long)self.picDataDic.count,(long)self.totalNum];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(comfirnChoose)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.ColView reloadData];
    [self changeComfirnTitie];

}

- (void)backToPreVC{
    
   
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark collectionview
- (void)initCollectionView{
    [self.view addSubview:self.ColView];

    UIView *backview = [[UIView alloc] initWithFrame:self.ColView.frame];
    backview.backgroundColor = [UIColor blackColor];
    backview.alpha = 0.0;
    [self.view addSubview:backview];
    self.backView = backview;
    
}

#pragma mark 初始化标题按钮
- (void)initTitleView:(ALAssetsGroup *)group{
    
    UILabel *label = [self fixLabelWithGroup:group andFontSize:16];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width+5, 3, 20, 14)];
    UIImage *image = [UIImage imageNamed:@"album_down"];
    img.image = [image changeColor:self.navigationController.navigationBar.tintColor];
    self.titleLImg = img;
    
    UIView *customTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width+35, 20)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width+35, 20)];
    self.titleBtn = btn;
    [btn addTarget:self action:@selector(choosePhotosGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    [customTitle addSubview:label];
    [customTitle addSubview:img];
    [customTitle addSubview:btn];
    self.navigationItem.titleView = customTitle;
    
}

#pragma mark 初始化相册分组列表
- (void)initAlbumGroupData{
    
    NSMutableArray *groupArray = [NSMutableArray new];
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if(group.numberOfAssets>0){
                [groupArray addObject:group];

            }
        }else{
            self.albumGroup.groupArray = [groupArray mutableCopy];

            ALAssetsGroup *group = groupArray[groupArray.count-1];

            [self initGroupDetailsData:group];
            [self initTitleView:group];

        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];

}
#pragma mark  ListGroupViewControllerDelegate 刷新相册 
- (void)initGroupDetailsData:(ALAssetsGroup *)group{

    [self.albumArray removeAllObjects];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result){
            [self.albumArray insertObject:result atIndex:0];
          

        }else{

             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.isLoad) {
                     [self choosePhotosGroup:self.titleBtn];
                     [self initTitleView:group];

                 }
                 self.isLoad = YES;

                 [self.ColView reloadData];
             });
            
        }
    }];

}

#pragma  mark 展示照片分组
- (void)choosePhotosGroup:(UIButton *)btn{
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        if (!btn.selected) {
            self.albumGroup.view.center = CGPointMake(Device_width/2, Device_height/4+64);

            self.titleLImg.transform=CGAffineTransformMakeRotation(M_PI);

            self.backView.alpha = 0.3;
            btn.selected = YES;
        }else{
            self.titleLImg.transform=CGAffineTransformMakeRotation(-M_PI*2);

            self.albumGroup.view.center = CGPointMake(Device_width/2, -Device_height/4);
            btn.selected = NO;
            self.backView.alpha = 0.0;
        }
    }];
}

#pragma mark  BigCollectionViewControllerDelegate 图片确认选择
- (void)comfirnChoose{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendImageDictionary:)]) {
            
            [self.delegate sendImageDictionary:self.picDataDic];
            
        }
    }];
  
}

#pragma mark UICollectionViewDelegate
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumArray.count+1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        mycell.selectBut.hidden = YES;
        mycell.imgView.image = nil;
        mycell.cameraView.hidden = NO;
        mycell.backView.hidden = YES;

    }else{
        mycell.cameraView.hidden = YES;
        ALAsset *asset = self.albumArray[indexPath.row-1];
        if ([self.picDataDic.allKeys containsObject:asset.defaultRepresentation.filename]) {
            mycell.selectBut.selected = YES;
            mycell.backView.hidden = NO;

            
        }else{
            mycell.selectBut.selected = NO;
            mycell.backView.hidden = YES;

        }
        mycell.selectBut.hidden = NO;
        mycell.imgView.image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        
        mycell.selectBut.tag = indexPath.row;
        [mycell.selectBut addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return mycell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        if (self.totalNum==self.picDataDic.count) {
            [self showWaringView];
            return;
        }
        [self openCamera];
        return;
    }
    
    BigCollectionViewController *big = [BigCollectionViewController new];
    big.delegate = self;
    big.dataArray = self.albumArray;
    big.index = indexPath.row;
    big.totalNum = self.totalNum;
    big.selectDic = self.picDataDic;

    [self.navigationController pushViewController:big animated:YES];
    
}
#pragma mark 选择照片动作
- (void)choosePicture:(UIButton *)btn{
    ALAsset *asset = self.albumArray[btn.tag-1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag inSection:0];

    if ([self.picDataDic.allKeys containsObject:asset.defaultRepresentation.filename]) {
        [self.picDataDic removeObjectForKey:asset.defaultRepresentation.filename];
        AlbumCollectionViewCell *mycell = (AlbumCollectionViewCell *)[self.ColView cellForItemAtIndexPath:indexPath];
        mycell.selectBut.selected = NO;
        mycell.backView.hidden = YES;
        [self changeComfirnTitie];
        
    }else{
        if (self.totalNum==self.picDataDic.count) {
            [self showWaringView];
            return;
        }
        [self.picDataDic setObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage] forKey:asset.defaultRepresentation.filename];
        AlbumCollectionViewCell *mycell = (AlbumCollectionViewCell *)[self.ColView cellForItemAtIndexPath:indexPath];
        [self showAnimation:mycell.selectBut];
        mycell.backView.hidden = NO;

        [self changeComfirnTitie];
    }

}
#pragma mark 照片选中按钮动画
- (void)showAnimation:(UIButton *)but{
    but.selected = YES;
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         but.transform = CGAffineTransformMakeScale(0.9,0.9);
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              but.transform = CGAffineTransformMakeScale(1.1,1.1);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1
                                                                    delay:0
                                                                  options: UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   but.transform = CGAffineTransformMakeScale(1.0,1.0);
                                                                   
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                               }];
                                          }];
                     }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((Device_width-4)/3, (Device_width-4)/3);

}

#pragma mark 改变确认按钮状态
- (void)changeComfirnTitie{
    
    if (self.picDataDic.count==0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确认(%ld/%ld)",(long)self.picDataDic.count,(long)self.totalNum];

}
#pragma mark 下拉超过一定距离返回
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y<-100) {
        if (self.navigationController.presentingViewController){
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }
    }
}

#pragma mark 打开摄像头
- (void)openCamera{
    if (![[CTSavePhotos new] checkAuthorityOfCamera]) {
        return;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *newImage = nil;
    if (picker.allowsEditing) {
        newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    }else{
        newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        newImage = [newImage normalizedImage];//需要重置图片的方向
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.picDataDic setObject:newImage forKey:[NSString stringWithFormat:@"%.f.JPG",[[NSDate new] timeIntervalSince1970]]];
        [self comfirnChoose];
        if ([[CTSavePhotos new] checkAuthorityOfAblum]) {
            [[CTSavePhotos new] saveImageIntoAlbum:newImage];
        }
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    if (self.titleBtn.selected) {
        [self choosePhotosGroup:self.titleBtn];

    }

}

#pragma mark 标题居中
- (UILabel *)fixLabelWithGroup:(ALAssetsGroup *)group andFontSize:(CGFloat)fontSize{
    
    UILabel *label = [UILabel new];
    label.textColor = self.navigationController.navigationBar.tintColor;
    label.text = [group  valueForProperty:ALAssetsGroupPropertyName];
    label.font = [UIFont systemFontOfSize:fontSize];
    CGSize maxSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    label.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);

    return label;
}
#pragma mark 弹出警告
- (void)showWaringView{
    [UIView animateWithDuration:0.2
                          delay:0.
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.waringView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.waringView.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];

}

#pragma mark 懒加载
- (UICollectionView *)ColView{
    if (_ColView ==nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset =  UIEdgeInsetsMake(1, 1, 1, 1);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.itemSize = CGSizeMake((Device_width-4)/3, (Device_width-4)/3);
        
        CGRect colFrame = CGRectMake(0, 0, Device_width, Device_height);
      
        _ColView = [[UICollectionView alloc] initWithFrame:colFrame collectionViewLayout:layout];
        _ColView.delegate = self;
        _ColView.dataSource = self;
        _ColView.backgroundColor= [UIColor whiteColor];
        _ColView.alwaysBounceVertical = YES;
        [_ColView registerNib:[UINib nibWithNibName:NSStringFromClass([AlbumCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AlbumCollectionViewCell class])];
        _ColView.backgroundColor= [UIColor groupTableViewBackgroundColor];
        _ColView.alwaysBounceVertical = YES;
    }
    return _ColView;
}
- (NSMutableDictionary <NSString*,UIImage*> *)picDataDic{
    if (!_picDataDic) {
        _picDataDic = [NSMutableDictionary new];
        
    }
    return _picDataDic;
}
- (NSMutableArray <ALAsset *> *)albumArray{
    if (!_albumArray) {
        _albumArray = [NSMutableArray new];
    }
    return _albumArray;
}
- (ListGroupViewController *)albumGroup{
    if (_albumGroup==nil) {
        _albumGroup =  [ListGroupViewController new];
        _albumGroup.delegate = self;
        _albumGroup.view.frame = CGRectMake(0,  -Device_height/2, Device_width, Device_height/2);
        _albumGroup.TbView.frame = CGRectMake(0, 0, Device_width, Device_height/2);
        
        [_albumGroup.TbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        [self.view addSubview:_albumGroup.view];
        [self.view bringSubviewToFront:_albumGroup.view];
        [self addChildViewController:_albumGroup];
        
    }
    return _albumGroup;
}

- (UIView *)waringView{
    if (_waringView ==nil) {
        _waringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 120)];
        _waringView.center = self.view.center;
        _waringView.alpha = 0.0;
        _waringView.backgroundColor = [UIColor blackColor];
        _waringView.layer.masksToBounds = YES;
        _waringView.layer.cornerRadius = 5.0;
        
        UIImageView *warningImg = [[UIImageView alloc] initWithFrame:CGRectMake(_waringView.frame.size.width/2-15, 25, 30, 30)];
        warningImg.image = [UIImage imageNamed:@"max_warinig"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, _waringView.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor  = [UIColor whiteColor];
        label.text = @"照片数量已到上限";
        
        [_waringView addSubview:warningImg];
        [_waringView addSubview:label];
        
        [self.view addSubview:_waringView];
    }
    return _waringView;
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
