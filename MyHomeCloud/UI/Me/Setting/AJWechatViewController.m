//
//  AJWechatViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJWechatViewController.h"
#import "AJUMShareUtil.h"

@interface AJWechatViewController ()
@property (weak, nonatomic) IBOutlet UIView *wechatView;

@end

@implementation AJWechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)shareWechat:(UIButton *)sender {
    [self hiddenView];
    if (sender.tag==0) {
        [AJUMShareUtil shareWechatSession];
    }else{
        [AJUMShareUtil shareWechatTimeLine];

    }
}

- (void)hiddenView{
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        _wechatView.center = CGPointMake(dWidth/2, dHeight-64+40);
    }];
    
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
