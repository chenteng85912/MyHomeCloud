//
//  AJFilterViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/28.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFilterViewController.h"


@interface AJFilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@property (strong, nonatomic)NSArray *roomsArray;
@property (strong, nonatomic)NSArray *priceArray;
@property (strong, nonatomic)NSArray *areasArray;
@property (assign, nonatomic)NSInteger currentIndex;

@end

@implementation AJFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.roomsArray = @[@"不限",@"一房",@"两房",@"三房",@"四房",@"五房",@"五房以上"];
    if ([self.className isEqualToString:SECOND_HAND_HOUSE]) {
        
    }else{
        
    }
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}
- (IBAction)btnAction:(UIButton *)sender {
    _currentIndex=sender.tag;
    //0区域 1租金 总价 2房型 3更多
    if (sender.tag==0) {
        
    }else if (sender.tag==1){
        
    }else if (sender.tag==2){
        
    }else{
        
    }
    [self showOrHiddenTbView:YES];
    [self.tbView reloadData];

}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self showOrHiddenTbView:NO];
}
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex==0) {
        return self.areasArray.count;
        
    }else if (_currentIndex==1){
        return self.priceArray.count;
    }else{
        return self.roomsArray.count;
        
    }

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSArray *array;
    if (_currentIndex==0) {
        array = self.areasArray;
        
    }else if (_currentIndex==1){
        array = self.priceArray;
    }else{
        array = self.roomsArray;
        
    }
    cell.textLabel.text = array[indexPath.row];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark UITableViewDelegate UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)showOrHiddenTbView:(BOOL)isShow{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = isShow;
        
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
