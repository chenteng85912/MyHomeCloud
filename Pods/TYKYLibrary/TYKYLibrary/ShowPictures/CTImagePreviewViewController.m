//
//  ImagePreviewViewController.m
//  TYKYTwoLearnOneDo
//
//  Created by Apple on 16/7/22.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "CTImagePreviewViewController.h"
#import "CTLazyImageView.h"

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

#define CTImageShowIdentifier @"CTImageShowIdentifier"


@interface CTImagePreviewViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *colView;
@property (strong, nonatomic) NSArray *dataArray;//图片或者网址数据
@property (strong, nonatomic) UILabel *pageNumLabel;//页码显示

@end

@implementation CTImagePreviewViewController

static CTImagePreviewViewController *imageShowInstance = nil;

#pragma mark 单例
+ (void)defaultShowPicture
{

    @synchronized(self){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            imageShowInstance = [[self alloc] init];
            
        });
    }
}

#pragma mark 界面布局
+ (void)initUI{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(Device_width+10, Device_height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Device_width+20, Device_height) collectionViewLayout:layout];
    colView.pagingEnabled = YES;
    colView.delegate = imageShowInstance;
    colView.dataSource = imageShowInstance;
    [imageShowInstance.view addSubview:colView];
    colView.backgroundColor= [UIColor blackColor];
    colView.directionalLockEnabled  = YES;
    imageShowInstance.colView = colView;
    
    [imageShowInstance.colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CTImageShowIdentifier];
    
    //单击返回
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:imageShowInstance action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [imageShowInstance.view addGestureRecognizer:singleTapGestureRecognizer];
    
    //双击放大
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:imageShowInstance action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [imageShowInstance.view addGestureRecognizer:doubleTapGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];

    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(Device_width/2-25, Device_height-60, 50, 30)];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.textColor = [UIColor whiteColor];
    pageLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    pageLabel.layer.masksToBounds = YES;
    pageLabel.layer.cornerRadius = 5.0;
    [imageShowInstance.view addSubview:pageLabel];
    imageShowInstance.pageNumLabel = pageLabel;
    
}

#pragma mark 展示图片
+ (void)showPictureWithUrlOrImages:(NSArray *)imageArray withCurrentPageNum:(NSInteger)currentNum{
    [self defaultShowPicture];
    [self initUI];

    [self showPicture:imageArray withCurrentPageNum:currentNum];
}

+ (void)showPicture:(NSArray *)imageArray withCurrentPageNum:(NSInteger)currentNum{
    if (imageArray.count == 0) {
        return;
    }
    if (imageArray.count<currentNum+1) {
        currentNum = imageArray.count-1;
    }
    
    if (imageArray.count==1) {
        imageShowInstance.pageNumLabel.hidden = YES;
    }else{
        imageShowInstance.pageNumLabel.hidden = NO;
        
    }
    imageShowInstance.dataArray = imageArray;
    [imageShowInstance.colView reloadData];
    
    [imageShowInstance.colView setContentOffset:CGPointMake((Device_width+20)*currentNum, 0)];
    imageShowInstance.pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",currentNum+1,(unsigned long)imageArray.count];
    
    imageShowInstance.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imageShowInstance animated:YES completion:nil];

}
#pragma mark UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageShowInstance.dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:CTImageShowIdentifier forIndexPath:indexPath];
    
    [mycell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_width, Device_height)];
    scrView.delegate = imageShowInstance;
    scrView.tag = indexPath.item+2000;
    scrView.maximumZoomScale = 3.0;
    scrView.minimumZoomScale = 0.9;
    
    id obj = imageShowInstance.dataArray[indexPath.row];
    if ([obj isKindOfClass:[UIImage class]]) {
        UIImageView *imgView = [imageShowInstance makeImageView:imageShowInstance.dataArray[indexPath.row]];
        imgView.tag = indexPath.item+1000;
        [scrView addSubview:imgView];
    }else{
        CTLazyImageView *imgView = [[CTLazyImageView alloc] initWithFrame:scrView.frame];
        [imgView loadFullScreenImage:imageShowInstance.dataArray[indexPath.item]];
        imgView.tag = indexPath.item+1000;
        [scrView addSubview:imgView];
    }
  
    [mycell.contentView addSubview:scrView];

    return mycell;
}

#pragma mark 正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        int pageNum = (scrollView.contentOffset.x - (Device_width+20) / 2) / (Device_width+20) + 1;
        self.pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",pageNum+1,(long)self.dataArray.count];
    }
  
}
#pragma mark 设置预览图片的大小
- (UIImageView *)makeImageView:(UIImage *)image{
    
    CGSize imageSize = image.size;
    CGFloat scaleW = imageSize.width/Device_width;
    CGFloat picHeight = imageSize.height/scaleW;
    
    CGFloat picW;
    CGFloat picH;
    
    if (picHeight>Device_height) {
        CGFloat scaleH = picHeight/(Device_height);
        picW = Device_width/scaleH;
        picH = Device_height;
    }else{
        picW = Device_width;
        picH = picHeight;
    }
    
    UIImageView *preImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picW, picH)];
    preImg.center = CGPointMake(Device_width/2, Device_height/2);
    preImg.userInteractionEnabled = YES;
    preImg.image = image;
    
    return preImg;
    
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

#pragma mark 手势放大图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)tmpScrollView
{
    
    UICollectionViewCell *mycell = self.colView.visibleCells[0];
    NSIndexPath *index = self.colView.indexPathsForVisibleItems[0];
    UIImageView *imgView = (UIImageView *)[mycell viewWithTag:index.item+1000];
    return imgView;
}

#pragma mark 单击图片返回
- (void)singleTap:(UITapGestureRecognizer *)gestureRecognize {
   
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
#pragma mark 双击放大缩小
- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognize {
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
