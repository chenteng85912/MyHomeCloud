//
//  TJPageController.m
//
//

#import "CTCustomePageController.h"

#define  DEVICE_WIDTH    self.view.frame.size.width

CGFloat const  TITLE_SCALE = 0.2;
CGFloat const  PAGE_HEAD_HEIGHT = 45.0;
CGFloat const  LINE_HEIGHT = 3.0;

NSInteger const MAX_BUTTON_NUMBER = 5;

#define  TITILE_FONT  DEVICE_WIDTH==320?12:14

@interface CTCustomePageController ()<UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat titleBtnWidth;        //标题按钮宽度
@property (strong, nonatomic) UIScrollView *contentScrView; //内容底部滚动视图
@property (strong, nonatomic) UIButton *curruntBtn;         //当前选中按钮
@property (strong, nonatomic) NSArray *RGBArray;            //按钮选中颜色RGB
@property (strong, nonatomic) UIView *bottomLine;           //底部线条
@property (assign, nonatomic) CGFloat titleWidth;           //底部线条宽度

@property (strong, nonatomic) UIButton *moreBtn;            //头部更多按钮
@property (strong, nonatomic) UIView *moreBtnView;          //按钮展示

@property (assign, nonatomic) BOOL isLoad;

@end

@implementation CTCustomePageController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isLoad) {
        _isLoad = YES;
        if (!_viewControllers) {
            return;
        }
        [self initUI];
    }
}

#pragma mark 界面布局
- (void)initUI{
    if (!_viewControllers) {
        return;
    }
  
    _titleBtnWidth = DEVICE_WIDTH/MIN(_viewControllers.count, MAX_BUTTON_NUMBER);
    
    if (_headBtnStyle==NavigationButtonView) {
        _titleBtnWidth = self.headScrView.frame.size.width/_viewControllers.count;

    }
    if (!_lineHeight) {
        _lineHeight = LINE_HEIGHT;
    }
    if (!_headBtnHeigth) {
        _headBtnHeigth = PAGE_HEAD_HEIGHT;
    }
    if (!_selectedColor) {
        _selectedColor = [UIColor redColor];
    }
    
    if (_selectedIndex>_viewControllers.count-1) {
        _selectedIndex = 0;
    }
    
    //添加头部标题
    if (_headBtnStyle==DefaultButtonView) {
     
        [self.view addSubview:self.headScrView];
        
    }
    for (int i = 0; i <_viewControllers.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_titleBtnWidth*i, 0, _titleBtnWidth, _headBtnHeigth)];
        btn.tag = i+100;
        if (_headBtnStyle==NavigationButtonView) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        }
        [btn addTarget:self action:@selector(switchViewControllers:) forControlEvents:UIControlEventTouchUpInside];
        UIViewController *vc = _viewControllers[i];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:TITILE_FONT];
        if (i==_selectedIndex) {
            _curruntBtn = btn;
            [self setButScale:_curruntBtn withScale:1];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        [self.headScrView addSubview:btn];
        _titleWidth = [self strLenth:btn.currentTitle]*(1+TITLE_SCALE);
        
    }
   
    //添加底部线条
    if (_lineShowMode!=UnDisplayMode) {
        if (_headBtnStyle!=NavigationButtonView) {
            UIView *bottom =[[UIView alloc] initWithFrame:CGRectMake(0, _headBtnHeigth-0.5, DEVICE_WIDTH, 0.5)];
            bottom.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:bottom];
        }
      
        UIView *line = [UIView new];
        line.tag = 891101;
        line.backgroundColor = _selectedColor;
        if (_lineShowMode == AboveShowMode) {
            line.frame = CGRectMake(_titleBtnWidth/2-_titleWidth/2, 0, _titleWidth, _lineHeight);
        }else{
            line.frame = CGRectMake(_titleBtnWidth/2-_titleWidth/2, _headBtnHeigth-_lineHeight, _titleWidth, _lineHeight);

        }
        line.layer.masksToBounds = YES;
        line.layer.cornerRadius = 2.0;
        self.bottomLine = line;
        [self.headScrView addSubview:line];
    }

    //添加内容
    [self.view addSubview:self.contentScrView];

    for (UIViewController *vc in _viewControllers) {
        [self addChildViewController:vc];
    }
    
    // 定位到指定位置
    CGPoint offset = self.contentScrView.contentOffset;
    
    offset.x = _selectedIndex * DEVICE_WIDTH;
    [self.contentScrView setContentOffset:offset animated:NO];
    
    [self scrollViewDidEndScrollingAnimation: self.contentScrView];

}

#pragma mark - <UIScrollViewDelegate>

/**
 *  当scrollView进行动画结束的时候会调用这个方法, 例如调用[self.contentScrollView setContentOffset:offset animated:YES];方法的时候
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / width;
    
    _curruntBtn = [self.headScrView viewWithTag:index+100];
    _selectedIndex = index;
    [self refreshHeadView:index];
    
    if (self.scrollBlock) {
        self.scrollBlock(index);
    }
    UIViewController *willShowVc = self.childViewControllers[index];
    
    if([willShowVc isViewLoaded]) return;
    
    willShowVc.view.frame = CGRectMake(index * width, 0, width, height);
    
    [scrollView addSubview:willShowVc.view];
    
}

/**
 *  当手指抬起停止减速的时候会调用这个方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 *  scrollView滚动时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale<0||scale>_viewControllers.count-1) {
        return;
    }
    // 获取需要操作的的左边的button
    NSInteger leftIndex = scale;
    UIButton *leftBtn = [self.headScrView viewWithTag:leftIndex+100];
  
    // 获取需要操作的右边的button
    NSInteger rightIndex = scale+1;
    UIButton *rightBtn = (rightIndex == _viewControllers.count) ?  nil : [self.headScrView viewWithTag:rightIndex+100];

    // 右边的比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1- rightScale;
    
    // 设置比例
    [self setButScale:leftBtn withScale:leftScale];
    [self setButScale:rightBtn withScale:rightScale];
    
    if (_lineShowMode!=UnDisplayMode) {
       
        UIView *line = (UIView *)[self.headScrView viewWithTag:891101];
        line.center = CGPointMake(_titleBtnWidth*scale+_titleBtnWidth/2, line.center.y);
    }
}

#pragma mark 切换视图控制器
- (void)switchViewControllers:(UIButton *)btn{
    if (btn==_curruntBtn) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.moreBtnView.alpha = 0.0;
    }];
    _curruntBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [_curruntBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _curruntBtn = [self.headScrView viewWithTag:btn.tag];
    
    _selectedIndex = btn.tag-100;
    if (self.scrollBlock) {
        self.scrollBlock(_selectedIndex);
    }
 
    // 定位到指定位置
    CGPoint offset = self.contentScrView.contentOffset;
    
    offset.x = _selectedIndex * DEVICE_WIDTH;
    [self.contentScrView setContentOffset:offset animated:NO];
    
    [self refreshHeadView:btn.tag-100];
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[_selectedIndex];
    if([willShowVc isViewLoaded]) return;
    willShowVc.view.frame = CGRectMake(_selectedIndex * DEVICE_WIDTH, 0, DEVICE_WIDTH, self.contentScrView.frame.size.height);
    [self.contentScrView addSubview:willShowVc.view];
}

- (void)refreshHeadView:(NSInteger)index{
    if (_viewControllers.count<=MAX_BUTTON_NUMBER) {
        return;
    }
    CGPoint headOffset = self.headScrView.contentOffset;
    headOffset.x = _titleBtnWidth*MIN(index<2?0:index-2, _viewControllers.count-MAX_BUTTON_NUMBER);
    [self.headScrView setContentOffset:headOffset animated:YES];
}

#pragma mark 设置头部按钮大小渐变
- (void)setButScale:(UIButton *)btn withScale:(CGFloat)scale {
    if (![btn isKindOfClass:[UIButton class]]) {
        return;
    }
    
    CGFloat red = [self.RGBArray[0] floatValue];
    CGFloat green = [self.RGBArray[1] floatValue];
    CGFloat blue = [self.RGBArray[2] floatValue];

    // 颜色渐变
    CGFloat red1 = scale*red;
    CGFloat green1 = green*scale;
    CGFloat blue1 = blue*scale;
    [btn setTitleColor:[UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:1.0] forState:UIControlStateNormal];
    
    // 大小缩放比例
    CGFloat transformScale = 1 + (scale * TITLE_SCALE);
    btn.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

- (CGFloat)strLenth:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, _headBtnHeigth) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TITILE_FONT]} context:nil].size.width;
}

- (void)refreshHeadBtnAndLineColor:(UIColor *)nColor{
    self.selectedColor = nColor;
    self.RGBArray = nil;
    self.bottomLine.backgroundColor = self.selectedColor;
    [self.curruntBtn setTitleColor:self.selectedColor forState:UIControlStateNormal];
}
- (void)showMoreBtnView:(UIButton *)btn{
    for (UIButton *btn in self.moreBtnView.subviews) {
        if (_curruntBtn.tag==btn.tag) {
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:TITILE_FONT];

        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:TITILE_FONT];

        }
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.moreBtnView.alpha = !self.moreBtnView.alpha;
    }];
}
- (UIScrollView *)headScrView{
    if (_headScrView==nil) {
       
         _headScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _headBtnHeigth)];
        if (_headBtnStyle==NavigationButtonView) {
            _headScrView.frame = CGRectMake(0, 0, DEVICE_WIDTH-180, _headBtnHeigth);
            _headScrView.backgroundColor = [UIColor clearColor];

        }else{
            _headScrView.backgroundColor = [UIColor whiteColor];
          
        }
        _headScrView.contentSize = CGSizeMake( _titleBtnWidth* _viewControllers.count, _headBtnHeigth);
        _headScrView.scrollEnabled = _viewControllers.count>MAX_BUTTON_NUMBER?true:false;
        _headScrView.showsHorizontalScrollIndicator = NO;
        _headScrView.bounces = _headScrView.scrollEnabled;
        
    }
    return _headScrView;
}
- (UIScrollView *)contentScrView{
    if (_contentScrView==nil) {
        _contentScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headBtnHeigth, self.view.frame.size.width , self.view.frame.size.height-_headBtnHeigth)];
        if (_headBtnStyle==NavigationButtonView) {
            _contentScrView.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        }
        _contentScrView.contentSize = CGSizeMake(self.view.frame.size.width*_viewControllers.count, _contentScrView.frame.size.height);
        _contentScrView.pagingEnabled = YES;
        _contentScrView.showsHorizontalScrollIndicator = NO;
        _contentScrView.directionalLockEnabled = YES;
        if (_viewControllers.count>1) {
            _contentScrView.delegate = self;

        }
    }
    return _contentScrView;
}

- (NSArray *)RGBArray{
    if (_RGBArray==nil) {
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        CGFloat alpha = 0.0;
        [_selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
        _RGBArray = @[@(red), @(green), @(blue), @(alpha)];
    }
    return _RGBArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
