//
//  TYKYBaseViewController.m
//  MVPProject
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import "CTBaseViewController.h"
#import "AJHouseDesViewController.h"
#import "AJAddPicturesViewController.h"
#import "AJUploadHomeImagesViewController.h"
#import "AJReserverDetailsViewController.h"

@interface CTBaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation CTBaseViewController

#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;

    if (self.subController) {
        return;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = NavigationBarColor;


    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.navigationItem.leftBarButtonItem) {
        return;
    }
    
    //添加返回键
    if (self.navigationController.viewControllers.count<2&&!self.navigationController.presentingViewController) {
        self.navigationItem.leftBarButtonItem = nil;
        
    }else{
        UIImage *backImg = LOADIMAGE(@"close");
        if (self.navigationController.viewControllers.count>1) {
            backImg = LOADIMAGE(@"back");
            if (self.isFlip) {
                backImg = LOADIMAGE(@"close");
            }
        }
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleDone target:self action:@selector(backToPreVC)];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - private method
- (void)backToPreVC{
    
    if (self.navigationController.viewControllers.count>1) {
        [self.view endEditing:YES];
        if (_isFlip) {
            [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.navigationController.presentingViewController) {
        
        [self.view endEditing:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    if (self.navigationController.viewControllers.count==0) {
        return NO;
    }else{
        if ([self isKindOfClass:[AJHouseDesViewController class]]
            ||[self isKindOfClass:[AJAddPicturesViewController class]]
            ||[self isKindOfClass:[AJUploadHomeImagesViewController class]]
            ||[self isKindOfClass:[AJReserverDetailsViewController class]]) {
            return NO;
        }
        return YES;
    }
}
- (AVQuery *)baseQuery{
    if (_baseQuery==nil) {
        _baseQuery = [AVQuery new];
//        _baseQuery.cachePolicy = kAVCachePolicyCacheElseNetwork;
        _baseQuery.limit = 50;;
        [_baseQuery orderByDescending:@"createdAt"];

    }
    return _baseQuery;
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
