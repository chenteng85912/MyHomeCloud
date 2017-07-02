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
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *roomsBtn;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIView *directionView;
@property (weak, nonatomic) IBOutlet UIView *areaageView;
@property (weak, nonatomic) IBOutlet UIView *describeView;
@property (weak, nonatomic) IBOutlet UIView *floorView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirnBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *moreFilterView;

@property (strong, nonatomic) NSArray *roomsArray;//房型
@property (strong, nonatomic) NSArray *priceArray;//价格
@property (strong, nonatomic) NSArray *areasArray;//区域
@property (strong, nonatomic) NSMutableDictionary  *priceDic;//价格条件
@property (strong, nonatomic) NSMutableDictionary  *moreDic;//更多条件
@property (strong, nonatomic) NSMutableDictionary  *areaAgeDic;//面积条件

@property (assign, nonatomic) NSInteger currentIndex;//0区域 1价格 2房型 3更多

@end

@implementation AJFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headView.backgroundColor = NavigationBarColor;
    [self initFilterParamaters];
    

    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (CGRectGetMaxY(_clearBtn.frame)>dHeight-64-80) {
        _moreFilterView.contentSize = CGSizeMake(dWidth, CGRectGetMaxY(_clearBtn.frame)+50);
        _moreFilterView.alwaysBounceVertical = YES;
        
    }else{
        _clearBtn.center = CGPointMake(dWidth/2, dHeight-64-80-30);
    }
}
//初始化参数
- (void)initFilterParamaters{
    self.roomsArray = @[@"不限",@"1房",@"2房",@"3房",@"4房",@"5房",@"5房以上"];
    self.areasArray = [APPDELEGATE areaArray];
    if ([self.className isEqualToString:SECOND_HAND_HOUSE]) {
        self.priceArray = @[@"不限",@"50万以下",@"50-100万",@"100-150万",@"150-200万",@"200-300万",@"300万以上"];
        [_priceBtn setTitle:@"总价" forState:UIControlStateNormal];
    }else {
        [_priceBtn setTitle:@"租金" forState:UIControlStateNormal];
        self.priceArray = @[@"不限",@"1000元以下",@"1000-1500元",@"1500-2000元",@"2000-3000元",@"3000-4000元",@"4000元以上"];

    }
    
}
- (IBAction)btnAction:(UIButton *)sender {
    
    //0区域 1租金 总价 2房型 3更多
    if (sender.tag<4) {
        if (sender.tag==3) {
            //更多
            if (_tbView.alpha) {
                [UIView animateWithDuration:0.3 animations:^{
                    _tbView.alpha = 0;
                    _backView.alpha = 0;
                }];
            }
            
            if (_currentIndex==3&&_moreView.alpha) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    _moreView.alpha = 0;
                } completion:^(BOOL finished) {
                    [self showOrHiddenTbView:NO];
                }];
                
            }else{
                self.view.frame = CGRectMake(0, 0, dWidth, dHeight-64);

                [UIView animateWithDuration:0.3 animations:^{
                    _moreView.alpha = 1;

                }];
            }
        }else{

            if (_moreView.alpha) {
                [UIView animateWithDuration:0.3 animations:^{
                    _moreView.alpha = 0;

                }];
            }
           
            if (_currentIndex==sender.tag&&_tbView.alpha) {
                
                [self showOrHiddenTbView:NO];
                return;
            }
            [self showOrHiddenTbView:YES];

        }
        _currentIndex=sender.tag;
        [self.tbView reloadData];

    }else if (sender.tag==4){
        //清空条件
        [self resetBtnState:_directionView];
        [self resetBtnState:_areaageView];
        [self resetBtnState:_describeView];
        [self resetBtnState:_floorView];

        [self.moreDic removeAllObjects];
    }else {
        //确定更多条件
        [UIView animateWithDuration:0.3 animations:^{
            _moreView.alpha = 0;
        }];
        [self showOrHiddenTbView:NO];

        //重新请求数据
        if ([self.delegate respondsToSelector:@selector(refreshTbView)]) {
            [self.delegate refreshTbView];
        }
    }
   
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self showOrHiddenTbView:NO];
}
//楼层情况
- (IBAction)floorAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [self.moreDic removeObjectForKey:FILTER_FLOOR];
        return;

    }
    [self resetBtnState:_floorView];
    sender.selected = YES;
    [self.moreDic setObject:sender.currentTitle forKey:FILTER_FLOOR];
}
//装修
- (IBAction)descibeAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [self.moreDic removeObjectForKey:HOUSE_DISCRIBE];
        return;
        
    }
    [self resetBtnState:_describeView];
    sender.selected = YES;
    [self.moreDic setObject:sender.currentTitle forKey:HOUSE_DISCRIBE];

}
//朝向
- (IBAction)directionAction:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        [self.moreDic removeObjectForKey:HOUSE_DIRECTION];
        return;
        
    }
    [self resetBtnState:_directionView];
    sender.selected = YES;
    [self.moreDic setObject:sender.currentTitle forKey:HOUSE_DIRECTION];

}
//面积
- (IBAction)moreBtnAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        [self.moreDic removeObjectForKey:HOUSE_AREAAGE];
        return;
        
    }
    [self resetBtnState:_areaageView];

    sender.selected = YES;
    [self.moreDic setObject:sender.currentTitle forKey:HOUSE_AREAAGE];

    if ([sender.currentTitle containsString:@"-"]) {
        NSArray *priArray = [sender.currentTitle componentsSeparatedByString:@"-"];
        [self.areaAgeDic setObject:priArray[0]    forKey:FILTER_MIN];
        [self.areaAgeDic setObject:[self filterStr:priArray[1]] forKey:FILTER_MAX];
        
    }else if ([sender.currentTitle containsString:@"下"]) {
        [self.areaAgeDic setObject:[self filterStr:sender.currentTitle] forKey:FILTER_MAX];
        
    }else{
        [self.areaAgeDic setObject:[self filterStr:sender.currentTitle] forKey:FILTER_MIN];
        
    }
    
    debugLog(@"价格过滤条件%@",self.priceDic);
}
- (void)resetBtnState:(UIView *)view{
    for (id sView in view.subviews) {
        if ([sView isKindOfClass:[UIButton class]]) {
            [(UIButton *)sView setSelected:NO];
        }
    }
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
    
    NSString *str = [self.filterDic objectForKey:[NSNumber numberWithInteger:_currentIndex]];
    if ([str isEqualToString:array[indexPath.row]]) {
        cell.textLabel.textColor = NavigationBarColor;
    }else{
        cell.textLabel.textColor = [UIColor blackColor];

    }
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
    if (indexPath.row==0) {
        
        [self.filterDic removeObjectForKey:[NSNumber numberWithInteger:_currentIndex]];
        if (_currentIndex==0) {
            [_areaBtn setTitle:@"区域" forState:UIControlStateNormal];
        }else if (_currentIndex==1) {
            [self initFilterParamaters];
            [self.priceDic removeAllObjects];
        }else {
            [_roomsBtn setTitle:@"房型" forState:UIControlStateNormal];
        }
    }else{
        NSArray *dataArray;
        UIButton *btn;
        if (_currentIndex==0) {
            dataArray = self.areasArray;
            btn = _areaBtn;
        }else if (_currentIndex==1) {
            dataArray = self.priceArray;
            btn = _priceBtn;

        }else {
            dataArray = self.roomsArray;
            btn = _roomsBtn;

        }
       
        [btn setTitle:dataArray[indexPath.row] forState:UIControlStateNormal];
        [self.filterDic setObject:dataArray[indexPath.row] forKey:[NSNumber numberWithInteger:_currentIndex]];
        
    }
   
    [self showOrHiddenTbView:NO];
    [self initPriceParamaters];
    //重新请求数据
    if ([self.delegate respondsToSelector:@selector(refreshTbView)]) {
        [self.delegate refreshTbView];
    }
}
- (void)initPriceParamaters{
    NSNumber *index = [NSNumber numberWithInteger:1];
    NSString *price = self.filterDic[index];
    if (!price) {
        return;
    }
    if ([price containsString:@"-"]) {
        NSArray *priArray = [price componentsSeparatedByString:@"-"];
        [self.priceDic setObject:priArray[0]    forKey:FILTER_MIN];
        [self.priceDic setObject:[self filterStr:priArray[1]] forKey:FILTER_MAX];

    }else if ([price containsString:@"下"]) {
        [self.priceDic setObject:[self filterStr:price] forKey:FILTER_MAX];
        
    }else{
        [self.priceDic setObject:[self filterStr:price] forKey:FILTER_MIN];

    }
   
    debugLog(@"价格过滤条件%@",self.priceDic);
}
- (NSString *)filterStr:(NSString *)maxPrice{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSInteger num = [[maxPrice stringByTrimmingCharactersInSet:nonDigits] integerValue];
    debugLog(@"过滤的价格数据:%ld",(long)num);
    return [NSString stringWithFormat:@"%ld",(long)num];
}
- (void)showOrHiddenTbView:(BOOL)isShow{
    if (isShow) {
        self.view.frame = CGRectMake(0, 0, dWidth, dHeight-64);
        [_tbView reloadData];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = isShow;
        self.tbView.alpha = isShow;
    } completion:^(BOOL finished) {
        if (!isShow) {
            self.view.frame = _headView.bounds;
        }
    }];
}

- (NSMutableDictionary *)filterDic{
    if (_filterDic==nil) {
        _filterDic = [NSMutableDictionary new];
        [_filterDic setObject:self.priceDic forKey:FILTER_PRICE];
        [_filterDic setObject:self.moreDic  forKey:FILTER_MORE];

    }
    return _filterDic;
}
- (NSMutableDictionary *)priceDic{
    if (_priceDic==nil) {
        _priceDic = [NSMutableDictionary new];
        
    }
    return _priceDic;
}
- (NSMutableDictionary *)moreDic{
    if (_moreDic==nil) {
        _moreDic = [NSMutableDictionary new];
        [_moreDic setObject:self.areaAgeDic forKey:FILTER_AREAAGE];
    }
    return _moreDic;
}
- (NSMutableDictionary *)areaAgeDic{
    if (_areaAgeDic==nil) {
        _areaAgeDic = [NSMutableDictionary new];
        
    }
    return _areaAgeDic;
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
