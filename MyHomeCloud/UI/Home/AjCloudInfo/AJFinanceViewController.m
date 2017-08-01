//
//  AJFinanceViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/8/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFinanceViewController.h"
#import "AJFinanceCellModel.h"
#import "AJFinanceTableViewCell.h"

@interface AJFinanceViewController ()

@end

@implementation AJFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPreview = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isOneModal) {
        [self.tableView reloadData];
    }
}
#pragma mark - AJTbViewProtocol
- (BOOL)makeMJRefresh{
    if (_isOneModal) {
        return NO;
    }
    return YES;
}
- (BOOL)firstShowAnimation{
    return YES;
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}
- (NSString *)requestClassName{
   
    return AJCLOUD_INFO;
    
}

- (NSString *)customeTbViewCellClassName{
    return  NSStringFromClass([AJFinanceTableViewCell class]);
}
- (NSString *)customeTbViewCellModelClassName{
    return NSStringFromClass([AJFinanceCellModel class]);
}
- (void)loadDataSuccess{
    self.tableView.tableFooterView = nil;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)AJTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJTbViewCellModel <AJTbViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    
    AJFinanceTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:[self customeTbViewCellClassName]];
    myCell.imgBtn.tag = indexPath.row;
    BUTTON_ACTION(myCell.imgBtn, self, @selector(showImages:));
    [myCell processCellData:model];
    
    return myCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)showImages:(UIButton *)btn{
    
    NSMutableArray *imgArray = [NSMutableArray new];
    for (AJFinanceCellModel *model in self.dataArray) {
        [imgArray addObject:model.picUrl];
    }
    [[CTImagePreviewViewController defaultShowPicture] showPictureWithUrlOrImages:imgArray withCurrentPageNum:btn.tag andRootViewController:self];

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
