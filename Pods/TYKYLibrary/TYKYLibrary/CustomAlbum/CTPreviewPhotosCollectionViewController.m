//
//  BigCollectionViewController.m
//
//  Created by Apple on 16/7/22.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "CTPreviewPhotosCollectionViewController.h"
#import "CTPhotoManager.h"

@interface CTPreviewPhotosCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CTImageScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *colView;

//顶部视图 懒加载
@property (nonatomic, strong) UIView * topBar;
@property (nonatomic, strong) UIButton *selectBut;//选择按钮
@property (nonatomic, strong) UIButton *backBtn;//返回按钮

//底部视图
@property (nonatomic, strong) CTBottomView * bottomBar;

@property (nonatomic, strong) UIActivityIndicatorView * activityView;

@property (nonatomic, assign) BOOL isHiddenTop;;

@end
static NSString *PreviewCollectionCellIdengifier = @"PreviewCollectionCellIdengifier";

@implementation CTPreviewPhotosCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self.colView setContentOffset:CGPointMake((Device_width+20)*self.collectionModel.currenIndex, 0)];
    [self blockActions];

    [self refreshSendBtn];
    
    self.bottomBar.originBtn.selected = self.collectionModel.sendOriginImg;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    self.topBar.hidden = _touchPreview;
}
//按钮回调
- (void)blockActions{
    
    WEAKSELF;
    [self.backBtn blockWithControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    //右上角选择按钮
    [self.selectBut blockWithControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
       
        CTPHAssetModel *model = weakSelf.collectionModel.albumArray[weakSelf.collectionModel.currenIndex];
        if (!model.selected&&weakSelf.collectionModel.selectedArray.count==CTPhotosConfiguration.maxNum) {
            [weakSelf presentAlertController:CTPhotosConfiguration.maxNum];
            
            return;
        }
        model.selected = !model.selected;
        weakSelf.selectBut.selected = model.selected;
        if (model.selected) {
            [weakSelf.selectBut showAnimation];
            [weakSelf.collectionModel addSelectedIndex:weakSelf.collectionModel.currenIndex];
            
        }else{
            [weakSelf.collectionModel removeSelectedIndex:weakSelf.collectionModel.currenIndex];
        }
        [weakSelf refreshSendBtn];
    }];
    
    //原图切换
    [self.bottomBar.originBtn blockWithControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender){
        weakSelf.collectionModel.sendOriginImg = !weakSelf.collectionModel.sendOriginImg;
        weakSelf.bottomBar.originBtn.selected = weakSelf.collectionModel.sendOriginImg;

    }];
    
    //发送图片
    [self.bottomBar.senderBtn blockWithControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        [weakSelf.activityView startAnimating];
        [CTPhotoManager sendImageData:weakSelf.collectionModel complete:^{
            [weakSelf.activityView stopAnimating];

            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        }];
     
    }];

}
//刷新发送按钮
- (void)refreshSendBtn{
    [self.bottomBar.senderBtn setTitle:self.collectionModel.sendBtnTitle forState:UIControlStateNormal];
    
    self.bottomBar.senderBtn.enabled = self.collectionModel.selectedArray.count;
}

#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionModel.albumArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:PreviewCollectionCellIdengifier forIndexPath:indexPath];
    [mycell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CTPHAssetModel *model = self.collectionModel.albumArray[indexPath.row];
    CTImageScrollView *scrView = [CTImageScrollView initWithFrame:CGRectMake(0, 0, Device_width,self.colView.frame.size.height) image:nil];
    scrView.scrolDelegate = self;
    [mycell.contentView addSubview:scrView];

    // 默认大小
    CGSize imageSize = CGSizeMake(model.asset.pixelWidth/3, model.asset.pixelHeight/3);
    [model.asset fetchPreviewImageWithSize:imageSize complete:^(UIImage * _Nullable thumbImg) {
        [scrView refreshShowImage:thumbImg];

    }];

    return mycell;
}

#pragma mark 正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger pageNum = (scrollView.contentOffset.x - (Device_width+20) / 2) / (Device_width+20) + 1;
    self.collectionModel.currenIndex = pageNum;
    
    CTPHAssetModel *model = self.collectionModel.albumArray[self.collectionModel.currenIndex];
    self.selectBut.selected = model.selected;

}
#pragma mark CTImageScrollViewDelegate 点击隐藏
- (void)singalTapAction{
    _isHiddenTop = !_isHiddenTop;
    
    WEAKSELF;
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:0.5];
        if (_isHiddenTop) {
            weakSelf.topBar.center = CGPointMake(weakSelf.topBar.center.x, weakSelf.topBar.center.y-NAVBAR_HEIGHT);
            weakSelf.bottomBar.center = CGPointMake(weakSelf.bottomBar.center.x, weakSelf.bottomBar.center.y+weakSelf.bottomBar.frame.size.height);

        }else{
            weakSelf.topBar.center = CGPointMake(weakSelf.topBar.center.x, weakSelf.topBar.center.y+NAVBAR_HEIGHT);
            weakSelf.bottomBar.center = CGPointMake(weakSelf.bottomBar.center.x, weakSelf.bottomBar.center.y-weakSelf.bottomBar.frame.size.height);
        }
    }];
}
- (UICollectionView *)colView{
    if (!_colView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(Device_width+10, Device_height);
        layout.sectionInset = UIEdgeInsetsMake(-20, 0, 0, 10);
        
        CGRect colFrame = CGRectMake(0, 0, Device_width+20, Device_height);
        if (IPhoneX) {
            colFrame = CGRectMake(0, 0, Device_width+20, Device_height+5);
        }
        _colView = [[UICollectionView alloc] initWithFrame:colFrame collectionViewLayout:layout];
        _colView.pagingEnabled = YES;
        _colView.delegate = self;
        _colView.dataSource = self;
        _colView.backgroundColor= [UIColor whiteColor];
        _colView.directionalLockEnabled  = YES;
        
        [_colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PreviewCollectionCellIdengifier];
        [self.view addSubview:_colView];

    }
    return _colView;
}
- (UIView *)topBar
{
    if (!_topBar){
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NAVBAR_HEIGHT)];
        
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [self.view addSubview:_topBar];
    }
    
    return _topBar;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, NAVBAR_HEIGHT-44, 60, 44)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.topBar addSubview:_backBtn];
    }
    return _backBtn;
}
- (CTBottomView *)bottomBar
{
    if (!_bottomBar){
        CGFloat height = IPhoneX ? 79 : 44;

        _bottomBar = [[CTBottomView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-height, self.view.bounds.size.width, height)];
        
        _bottomBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

        [self.view addSubview:_bottomBar];
    }
    
    return _bottomBar;
}
- (UIButton *)selectBut{
    if (!_selectBut) {
        _selectBut = [[UIButton alloc] initWithFrame:CGRectMake(Device_width-54, NAVBAR_HEIGHT-44, 44, 44)];
        [_selectBut setImage:[UIImage imageNamed:@"punselect"] forState:UIControlStateNormal];
        [_selectBut setImage:[UIImage imageNamed:@"pselected"] forState:UIControlStateSelected];
        [self.topBar addSubview:_selectBut];
    }
    return _selectBut;
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.frame = CGRectMake(0, 0, 50, 50);
        _activityView.center = self.colView.center;
        _activityView.hidesWhenStopped = YES;
        [self.view addSubview:_activityView];
    }
    
    return _activityView;
}
@end
