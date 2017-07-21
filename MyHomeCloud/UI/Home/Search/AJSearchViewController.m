//
//  AJSearchViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/12.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSearchViewController.h"
#import "AJSecondHouseViewController.h"
#import "AJLetHouseViewController.h"
#import "AJNewHouseViewController.h"
#import "AJSearchTableViewCell.h"

@interface AJSearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *typeView;//二手房 租房 新房
@property (weak, nonatomic) IBOutlet UITableView *tbView;//搜索列表
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *clearAllBtn;//清空按钮

@property (strong, nonatomic) UIButton *typeBtn;
@property (strong, nonatomic) NSMutableArray *searchArray;

@end

@implementation AJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.typeBtn];
    [_tbView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSearchTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AJSearchTableViewCell class])];
    
    _tbView.tableHeaderView = _clearAllBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewFrame:) name:UIKeyboardWillHideNotification object:nil];


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self readLocalData];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];

}
#pragma mark UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AJSearchTableViewCell class]) forIndexPath:indexPath];
   
    cell.content.text = self.searchArray[indexPath.row];
    cell.deleteBtn.tag = indexPath.row;
    BUTTON_ACTION(cell.deleteBtn, self, @selector(deleteSearchKey:));
    return cell;
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
    
    [self showHouseList:self.searchArray[indexPath.row]];
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_typeView.alpha) {
        [self chooseHouseType];
    }
    if ([text isEqualToString:@"\n"]) {
      
        [self showSearchResult];
        return NO;
    }
    return YES;
}

- (void)showHouseList:(NSString *)searchKey{
    [_searchBar resignFirstResponder];
    UIViewController *vc;
    if (_type.integerValue==0) {
        AJSecondHouseViewController *second = [AJSecondHouseViewController new];
        second.showModal = SearchHouseModal;
        second.searchKey = searchKey;
        second.showFilter = YES;
        second.className = SECOND_HAND_HOUSE;
        vc = second;
    }else if (_type.integerValue==1) {
        AJLetHouseViewController *let = [AJLetHouseViewController new];
        let.showModal = SearchHouseModal;
        let.searchKey = searchKey;
        let.showFilter = YES;
        let.className = LET_HOUSE;

        vc = let;
    }else{
        AJNewHouseViewController *newHouse = [AJNewHouseViewController new];
        newHouse.showModal = SearchHouseModal;
        newHouse.searchKey = searchKey;
        newHouse.className = N_HOUSE;
        vc = newHouse;
    }
   
    APP_PUSH(vc);
    if ([self.searchArray containsObject:searchKey]) {
        [self.searchArray removeObject:searchKey];
    }
    [self.searchArray insertObject:searchKey atIndex:0];

    [AJLocalDataCenter saveLocalSearchKey:self.searchArray searchModal:[self currentModal]];

}
//前往搜索结果界面
- (void)showSearchResult{
    
    [_searchBar resignFirstResponder];
    [self showHouseList:_searchBar.text];
   
}

- (void)chooseHouseType{
    if (_backView.hidden) {
        _backView.hidden = NO;

    }
    [UIView animateWithDuration:0.25 animations:^{
        if (_typeView.alpha) {
            _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
            _typeView.alpha = 0.0;
            
        }else{
            _typeView.alpha = 1.0;
            _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            
        }

    } completion:^(BOOL finished) {
        if (!_typeView.alpha) {
            _backView.hidden = YES;

        }
    }];
    
}
- (void)backToPreVC{
    [_searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)chooseTypeAction:(UIButton *)sender {
    [self.typeBtn setTitle:sender.currentTitle forState:UIControlStateNormal];
    _type = [NSNumber numberWithInteger:sender.tag];
    [self chooseHouseType];
    [self readLocalData];
}

- (void)readLocalData{
    if (_type.integerValue==0) {
        self.searchBar.placeholder = @"小区/开发商/区域";

    }else if (_type.integerValue==1){
        self.searchBar.placeholder = @"小区/开发商/区域";

    }else{
        self.searchBar.placeholder = @"楼盘/开发商/区域";

    }
    self.searchArray = [AJLocalDataCenter readLocalSearchData:[self currentModal]];

    [_tbView reloadData];
}
- (SearchModal)currentModal{
    if (_type.integerValue==0) {
        return SHouseModal;

    }else if (_type.integerValue==1){
        return LHouseModal;
    }else{
        return NHouseModal;

    }

}
//删除某条搜索记录
- (void)deleteSearchKey:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.searchArray removeObjectAtIndex:indexPath.row];
    [self.tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tbView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];

    [AJLocalDataCenter deleteSearchKey:self.searchArray searchModal:[self currentModal]];

}
- (IBAction)hiddenTypeView:(UITapGestureRecognizer *)sender {
    [self chooseHouseType];
}

//删除搜索记录
- (IBAction)deleteAllAction:(UIButton *)sender {

    [AJLocalDataCenter clearLocalSearchKeys:[self currentModal]];
    [self.searchArray removeAllObjects];
    [_tbView reloadData];
}

#pragma mark 跟随键盘自动调整表格frame
- (void) changeContentViewFrame:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        if (keyBoardEndY<dHeight) {
            _tbView.frame = CGRectMake(0, 0, dWidth, keyBoardEndY-64);
        }
        
    }];
}

- (UIButton *)typeBtn{
    if (_typeBtn ==nil) {
        _typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        if (_type.integerValue==0) {
            [_typeBtn setTitle:@"二手房" forState:UIControlStateNormal];

        }else if (_type.integerValue==1){
            [_typeBtn setTitle:@"租房" forState:UIControlStateNormal];

        }else{
            [_typeBtn setTitle:@"新房" forState:UIControlStateNormal];

        }
        [_typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _typeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_typeBtn setImage:LOADIMAGE(@"down") forState:UIControlStateNormal];
        _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, -10);
        _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [_typeBtn addTarget:self action:@selector(chooseHouseType) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBtn;
}
- (NSMutableArray *)searchArray{
    if (_searchArray ==nil) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
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
