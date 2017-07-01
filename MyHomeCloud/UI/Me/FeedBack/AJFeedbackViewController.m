//
//  AJFeedbackViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFeedbackViewController.h"
#import "AJFeedbackCellModel.h"
#import "AJFeedbackTableViewCell.h"

@interface AJFeedbackViewController ()

@end

@implementation AJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    
    return YES;
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
    return USER_FEEDBACK;
    
}
- (NSString *)requestKeyName{
#if AJCLOUDADMIN
    return nil;
    
#else
    return [AVUser currentUser].mobilePhoneNumber;
    
#endif
}

- (BOOL)canDeleteCell{
    
    return YES;
}
- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJFeedbackTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJFeedbackCellModel class]);
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AJFeedbackCellModel *model = (AJFeedbackCellModel *)self.dataArray[indexPath.row];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
