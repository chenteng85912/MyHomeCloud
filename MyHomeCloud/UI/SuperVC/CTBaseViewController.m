//
//  TYKYBaseViewController.m
//  MVPProject
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import "CTBaseViewController.h"

@interface CTBaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation CTBaseViewController

#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    if (self.navigationItem.leftBarButtonItem) {
        return;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    //添加返回键
    if (self.navigationController.viewControllers.count<2&&!self.navigationController.presentingViewController) {
        self.navigationItem.leftBarButtonItem = nil;
       
    }else{
        UIImage *backImg = [UIImage imageNamed:@"close"];
        if (self.navigationController.viewControllers.count>1) {
            backImg = [UIImage imageNamed:@"back"];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backToPreVC)];
        self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(5, 0, 5, 10);
        self.navigationItem.leftBarButtonItem.tintColor = NavigationBarColor;
    }
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - private method
- (void)backToPreVC{
    
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.navigationController.presentingViewController) {
        
       
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize
{
    if (self.navigationController.viewControllers.count==0) {
        return NO;
    }else{
       
        return YES;
    }
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
