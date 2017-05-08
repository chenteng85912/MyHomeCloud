//
//  TJMenuViewController.m
//
//  Created by Apple on 2016/11/3.
//

#import "CTLeftMenuViewController.h"

//左边菜单宽度
#define LEFTMENU_WIDTH [[UIScreen mainScreen] bounds].size.width*4/5

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface CTLeftMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backView;     //蒙板
@property (nonatomic, assign) CGPoint startPoint;   //手势起始位置
@property (nonatomic, assign) BOOL isShowMenu;      //是否显示菜单标志位

@end

@implementation CTLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//初始化界面
- (void)initUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.0;
    [self.view addSubview:backView];
    self.backView = backView;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-LEFTMENU_WIDTH, 0, LEFTMENU_WIDTH, self.view.frame.size.height)];
    leftView.clipsToBounds = YES;
    [self.view addSubview:leftView];
    self.leftMenuView = leftView;
    
    self.backView.hidden = YES;
    self.leftMenuView.hidden = YES;

    //添加点击手势
    UITapGestureRecognizer *homeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHome)];
    [self.backView addGestureRecognizer:homeTap];
    
    //添加滑动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];

}

#pragma mark - 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (!self.isResponseGesture) {//不响应手势
        return NO;
    }

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        
        if (point.x>LEFTMENU_WIDTH) {
            return NO;
        }
        self.backView.hidden = NO;
        self.leftMenuView.hidden = NO;
        self.startPoint = point;
    }
    return YES;
}

//拖动手势
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint current = [recognizer locationInView:self.view];
    CGFloat sub = current.x - self.startPoint.x;
    
   
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        //显示菜单栏时，向右滑动手势无效
        //未显示菜单栏时，向左滑动手势无效
        if (!self.isShowMenu) {
            if (sub<0||sub>LEFTMENU_WIDTH) {
                return;
            }
            self.leftMenuView.center = CGPointMake(-LEFTMENU_WIDTH/2+sub, self.leftMenuView.center.y);
            
        }else{
            if (sub>0) {
                return;
            }
            self.leftMenuView.center = CGPointMake(LEFTMENU_WIDTH/2+sub, self.leftMenuView.center.y);
            
        }
        
        float alphe = CGRectGetMaxX(self.leftMenuView.frame)/2/Device_width;
        if (alphe>0.4) {
            alphe=0.4;
        }
        self.backView.alpha = alphe;
        
    }
    
    //手势结束时动作判断
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (!self.isShowMenu) {
            if (CGRectGetMaxX(self.leftMenuView.frame)>LEFTMENU_WIDTH/5) {
                [self showMenu];
                
            }else{
                [self showHome];
                
            }
        }else{
            if (CGRectGetMaxX(self.leftMenuView.frame)>LEFTMENU_WIDTH*4/5) {
                [self showMenu];
                
            }else{
                [self showHome];
                
            }
        }
        
    }
    
}

/**
 *  展示侧边栏
 */
- (void)showMenu {
    [self.view bringSubviewToFront:self.backView];
    [self.view bringSubviewToFront:self.leftMenuView];

    self.backView.hidden = NO;
    self.leftMenuView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        self.leftMenuView.center = CGPointMake(LEFTMENU_WIDTH/2, self.leftMenuView.center.y);
        self.backView.alpha = 0.4;
        
    }];
    
    self.isShowMenu = YES;
}

/**
 *  展示主界面
 */
- (void)showHome {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        self.leftMenuView.center = CGPointMake(-LEFTMENU_WIDTH/2, self.leftMenuView.center.y);
        self.backView.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
        self.leftMenuView.hidden = YES;
    }];
    
    self.isShowMenu = NO;
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
