//
//  BigCollectionViewController.m
//
//  Created by Apple on 16/7/22.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "BigCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface BigCollectionViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *colView;
@property (strong, nonatomic) UIView *waringView;//警告提示
@end

@implementation BigCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initWaringView];
    [self initNavigationItem];
    [self changeComfirnTitie];
    
}
#pragma mark 初始化导航栏按钮
- (void)initNavigationItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.index,(unsigned long)self.dataArray.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(comfirnChoose)];

}
#pragma mark 界面布局
- (void)initUI{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(Device_width+10, Device_height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);

    CGRect colFrame = CGRectMake(0, 0, Device_width+20, Device_height);

    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:colFrame collectionViewLayout:layout];
    colView.pagingEnabled = YES;
    colView.delegate = self;
    colView.dataSource = self;
    colView.backgroundColor= [UIColor whiteColor];
    colView.directionalLockEnabled  = YES;
    [self.view addSubview:colView];
    self.colView = colView;
    
    [self.colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BigCollectionViewCell"];
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    [self.colView setContentOffset:CGPointMake((Device_width+20)*(self.index-1), 0)];
    

}
#pragma mark UICollectionViewDelegate
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BigCollectionViewCell" forIndexPath:indexPath];
    [self makeImageCell:mycell withIndex:indexPath];

    return mycell;
}
- (void)makeImageCell:(UICollectionViewCell *)mycell withIndex:(NSIndexPath *)indexPath{
    ALAsset *asset = self.dataArray[indexPath.row];
    
    [mycell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_width, self.colView.frame.size.height)];
    scrView.delegate = self;
    scrView.tag = indexPath.item+2000;
    scrView.maximumZoomScale = 3.0;
    scrView.minimumZoomScale = 0.9;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:scrView.frame];
    
    imgView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];

    imgView.frame = [self makeImageViewFrame:imgView.image];
    imgView.center = scrView.center;
    imgView.tag = indexPath.item+1000;
    [scrView addSubview:imgView];
    [mycell.contentView addSubview:scrView];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(Device_width-60, 40, 40, 40)];
    [but setImage:[UIImage imageNamed:@"unselected_album"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"selected_album"] forState:UIControlStateSelected];
    but.tag = indexPath.item;
    [but addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];

    [mycell.contentView addSubview:but];
    
    if ([self.selectDic.allKeys containsObject:asset.defaultRepresentation.filename]) {
        but.selected = YES;
        
        
    }else{
        but.selected = NO;
        
    }
    
}
#pragma mark 正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        NSInteger pageNum = (scrollView.contentOffset.x - (Device_width+20) / 2) / (Device_width+20) + 1;
        self.title = [NSString stringWithFormat:@"%ld/%lu",(long)pageNum+1,(unsigned long)self.dataArray.count];

    }
    
}
#pragma mark 选择照片
- (void)choosePicture:(UIButton *)btn{
    
    ALAsset *asset = self.dataArray[btn.tag];
    
    //图片名称
    NSString *imgName = asset.defaultRepresentation.filename;
    if ([self.selectDic.allKeys containsObject:imgName]) {
        UIImage *img = self.selectDic[imgName];
        [self.imgArray removeObject:img];
        
        [self.selectDic removeObjectForKey:asset.defaultRepresentation.filename];
        btn.selected = NO;
        
    }else{
        if (self.totalNum==self.selectDic.count) {
            [self showWaringView];
            return;
        }
        [self.selectDic setObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage] forKey:imgName];
        [self.imgArray addObject:self.selectDic[imgName]];

        [self showAnimation:btn];
        
    }
    [self changeComfirnTitie];
    
}
#pragma mark 改变确认按钮状态
- (void)changeComfirnTitie{
    
    if (self.selectDic.count==0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确认(%ld/%ld)",(long)self.selectDic.count,(long)self.totalNum];
    
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
#pragma mark 图片确认选择
- (void)comfirnChoose{
    
    if ([self.delegate respondsToSelector:@selector(comfirnChoose)]) {
        
        [self.delegate comfirnChoose];
    }
    
}
#pragma mark 设置预览图片的大小
- (CGRect)makeImageViewFrame:(UIImage *)image{
    CGSize imageSize = image.size;
    CGFloat scaleW = imageSize.width/Device_width;
    CGFloat picHeight = imageSize.height/scaleW;
    
    CGFloat picW;
    CGFloat picH;
    
    if (picHeight>self.colView.frame.size.height) {
        CGFloat scaleH = picHeight/self.colView.frame.size.height;
        picW = Device_width/scaleH;
        picH = self.colView.frame.size.height;
    }else{
        picW = Device_width;
        picH = picHeight;
    }
    return CGRectMake(0, 0, picW, picH);
}
#pragma mark 图片放大缩小后位置校正
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UICollectionViewCell *mycell = self.colView.visibleCells[0];
    NSIndexPath *index = self.colView.indexPathsForVisibleItems[0];
    UIScrollView *scrView = (UIScrollView *)[mycell viewWithTag:index.item+2000];
    UIImageView *imgView = (UIImageView *)[mycell viewWithTag:index.item+1000];

    CGFloat offsetX = (scrView.bounds.size.width > scrView.contentSize.width)?
    (scrView.bounds.size.width - scrView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrView.bounds.size.height > scrView.contentSize.height)?
    (scrView.bounds.size.height - scrView.contentSize.height) * 0.5 : 0.0;
    imgView.center = CGPointMake(scrView.contentSize.width * 0.5 + offsetX,
                                       scrView.contentSize.height * 0.5 + offsetY);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)tmpScrollView
{
    UICollectionViewCell *mycell = self.colView.visibleCells[0];
    NSIndexPath *index = self.colView.indexPathsForVisibleItems[0];
    UIImageView *imgView = (UIImageView *)[mycell viewWithTag:index.item+1000];
    return imgView;
}
#pragma mark 双击放大缩小
-(void)doubleTap:(UITapGestureRecognizer *)gestureRecognize {
    
    UICollectionViewCell *mycell = self.colView.visibleCells[0];
    NSIndexPath *index = self.colView.indexPathsForVisibleItems[0];
    UIScrollView *scrView = (UIScrollView *)[mycell viewWithTag:index.item+2000];
    if (scrView.zoomScale==1.0) {
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            scrView.zoomScale = 3.0;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            scrView.zoomScale = 1.0;
            
        }];
    }
    
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

#pragma mark 初始化警告弹窗
- (void)initWaringView{
    UIView *warning = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 120)];
    warning.center = self.view.center;
    warning.alpha = 0.0;
    warning.backgroundColor = [UIColor blackColor];
    warning.layer.masksToBounds = YES;
    warning.layer.cornerRadius = 5.0;
    
    UIImageView *warningImg = [[UIImageView alloc] initWithFrame:CGRectMake(warning.frame.size.width/2-15, 25, 30, 30)];
    warningImg.image = [UIImage imageNamed:@"max_warinig"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, warning.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor  = [UIColor whiteColor];
    label.text = @"照片数量已到上限";
    
    [warning addSubview:warningImg];
    [warning addSubview:label];
    
    [self.navigationController.view addSubview:warning];
    [self.navigationController.view bringSubviewToFront:warning];
    self.waringView = warning;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
