//
//  AJTagsViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/25.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJTagsViewController.h"

@interface AJTagsViewController ()

@property (strong, nonatomic) NSMutableArray *desArray;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *yearsBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIButton *communitBtn;
@end

@implementation AJTagsViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.addModal==LetHouseModal) {
        _yearsBtn.hidden = YES;
        _schoolBtn.hidden = YES;
    }else{
        _communitBtn.hidden = YES;
    }
    _doneBtn.backgroundColor = NavigationBarColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (IBAction)butAction:(UIButton *)sender {
    if (sender.tag==0) {
        if (self.desArray.count==0) {
            [self.view showTips:@"请至少选择一个标签" withState:TYKYHUDModeWarning complete:nil];

            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 0;
           
        }];
        if ([self.delegate respondsToSelector:@selector(confirmTags:)]) {
            [self.delegate confirmTags:self.desArray];
        }
    }else{
        if (sender.selected) {
            sender.selected = NO;
            sender.backgroundColor = [UIColor clearColor];
            if ([self.desArray containsObject:sender.currentTitle]) {
                [self.desArray removeObject:sender.currentTitle];

            }
            return;
        }
        if (self.desArray.count==3) {
            [self.view showTips:@"只能选择3个标签" withState:TYKYHUDModeWarning complete:nil];
            return;
        }
        sender.selected = YES;
        sender.backgroundColor = [APPDELEGATE desInfo][sender.currentTitle];
        [self.desArray addObject:sender.currentTitle];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - event response

#pragma mark - private methods

#pragma mark - getters and setters
- (NSMutableArray *)desArray{
    if (_desArray ==nil) {
        _desArray = [NSMutableArray new];
    }
    return _desArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
