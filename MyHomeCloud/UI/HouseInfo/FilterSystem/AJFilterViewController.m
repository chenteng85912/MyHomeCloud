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
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *moreBtnView;

@property (strong, nonatomic) NSArray *roomsArray;//房型
@property (strong, nonatomic) NSArray *priceArray;//价格
@property (strong, nonatomic) NSArray *areasArray;//区域
@property (strong, nonatomic) NSArray *allBtnArray;//按钮

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
    
    _allBtnArray = @[_areaBtn,_priceBtn,_roomsBtn,_moreBtn];
    for (UIButton *btn in _allBtnArray) {
        if (dWidth==320) {
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.className isEqualToString:N_HOUSE]) {
        _areaView.frame = CGRectMake(0, 0, dWidth/3, 40);
        _priceView.frame = CGRectMake(dWidth/3, 0, dWidth/3, 40);
        _typeView.frame = CGRectMake(dWidth*2/3, 0, dWidth/3, 40);
        
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    if (CGRectGetMaxY(_clearBtn.frame)>dHeight-64-80) {
        _moreFilterView.contentSize = CGSizeMake(dWidth, CGRectGetMaxY(_clearBtn.frame)+45);
        _moreFilterView.alwaysBounceVertical = YES;
        
    }else{
        _clearBtn.center = CGPointMake(dWidth/2, dHeight-64-80-25);
    }
}
//初始化参数
- (void)initFilterParamaters{
    self.roomsArray = @[@"不限",@"1房",@"2房",@"3房",@"4房",@"5房",@"5房以上"];
    self.areasArray = [APPDELEGATE areaArray];
    if ([self.className isEqualToString:SECOND_HAND_HOUSE]) {
        self.priceArray = @[@"不限",@"50万以下",@"50-100万",@"100-150万",@"150-200万",@"200-300万",@"300万以上"];
        [_priceBtn setTitle:@"总价" forState:UIControlStateNormal];
    }else if ([self.className isEqualToString:LET_HOUSE]){
        [_priceBtn setTitle:@"租金" forState:UIControlStateNormal];
        self.priceArray = @[@"不限",@"1000元以下",@"1000-1500元",@"1500-2000元",@"2000-3000元",@"3000-4000元",@"4000元以上"];

    }else{
        _moreBtnView.hidden = YES;
        [_priceBtn setTitle:@"均价" forState:UIControlStateNormal];
        self.priceArray = @[@"不限",@"10000元以下",@"10000-15000元/平",@"15000-20000元/平",@"20000-25000元/平",@"25000-30000元/平",@"30000元以上"];
        self.roomsArray = @[@"不限",@"公寓",@"洋房",@"别墅",@"商铺",@"写字楼"];

    }
    
}
- (IBAction)btnAction:(UIButton *)sender {
    //4清空条件
    if (sender.tag==4) {
        
        [self resetBtnState:_directionView];
        [self resetBtnState:_areaageView];
        [self resetBtnState:_describeView];
        [self resetBtnState:_floorView];
        
        [self.moreDic removeAllObjects];
        [self.areaAgeDic removeAllObjects];
        [self.moreDic setObject:self.areaAgeDic forKey:HOUSE_AREAAGE];
        return;

    }
    sender.selected = !sender.selected;

    for (UIButton *btn in _allBtnArray) {
        if (sender==btn) {
            continue;
        }
        btn.selected = NO;
    }
    if (sender!=_comfirnBtn) {
        _comfirnBtn.hidden = NO;

    }else{
        _comfirnBtn.hidden = YES;

    }
    //0区域 1租金/总价 2房型 3更多
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

    }else {
        //确定更多条件
        _moreView.alpha = 0;

        [self showOrHiddenTbView:NO];

        //重新请求数据
        if ([self.delegate respondsToSelector:@selector(refreshTbView)]) {
            [self.delegate refreshTbView];
        }
    }
   
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    for (UIButton *btn in _allBtnArray) {
        btn.selected = NO;
    }
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
        [self.areaAgeDic removeAllObjects];
        return;
        
    }
    [self resetBtnState:_areaageView];

    sender.selected = YES;

    if ([sender.currentTitle containsString:@"-"]) {
        NSArray *priArray = [sender.currentTitle componentsSeparatedByString:@"-"];
        [self.areaAgeDic setObject:priArray[0]    forKey:FILTER_MIN];
        [self.areaAgeDic setObject:[self filterStr:priArray[1]] forKey:FILTER_MAX];
        
    }else if ([sender.currentTitle containsString:@"下"]) {
        [self.areaAgeDic setObject:[self filterStr:sender.currentTitle] forKey:FILTER_MAX];
        
    }else{
        [self.areaAgeDic setObject:[self filterStr:sender.currentTitle] forKey:FILTER_MIN];
        
    }
    
    debugLog(@"面积过滤条件%@",self.areaAgeDic);
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
    UIButton *currentBtn;
    if (_currentIndex==0) {
        array = self.areasArray;
        currentBtn = _areaBtn;
    }else if (_currentIndex==1){
        array = self.priceArray;
        currentBtn = _priceBtn;
    }else{
        array = self.roomsArray;
        currentBtn = _roomsBtn;
    }
    cell.textLabel.text = array[indexPath.row];
    
    if ([currentBtn.currentTitle isEqualToString:array[indexPath.row]]) {
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
        
        if (_currentIndex==0) {
            [_areaBtn setTitle:@"区域" forState:UIControlStateNormal];
            [self.filterDic removeObjectForKey:HOUSE_AREA];
        }else if (_currentIndex==1) {
            [self initFilterParamaters];
            [self.priceDic removeAllObjects];
        }else {
            if ([self.className isEqualToString:N_HOUSE]) {
                [_roomsBtn setTitle:@"类型" forState:UIControlStateNormal];
                [self.filterDic removeObjectForKey:ESTATE_TYPE];

            }else{
                [_roomsBtn setTitle:@"房型" forState:UIControlStateNormal];
                [self.filterDic removeObjectForKey:HOUSE_AMOUNT];

            }
        }
    }else{
        NSArray *dataArray;
        UIButton *btn;
        if (_currentIndex==0) {
            dataArray = self.areasArray;
            btn = _areaBtn;
            [self.filterDic setObject:self.areasArray[indexPath.row] forKey:HOUSE_AREA];

        }else if (_currentIndex==1) {
            dataArray = self.priceArray;
            btn = _priceBtn;
            [self initPriceParamaters:self.priceArray[indexPath.row]];

        }else {
            dataArray = self.roomsArray;
            btn = _roomsBtn;
            //建筑类型
            if ([self.className isEqualToString:N_HOUSE]) {
                [self.filterDic setObject:self.roomsArray[indexPath.row] forKey:ESTATE_TYPE];

            }else{
                //房间数量
                [self.filterDic setObject:self.roomsArray[indexPath.row] forKey:HOUSE_AMOUNT];

            }
        }
       
        [btn setTitle:dataArray[indexPath.row] forState:UIControlStateNormal];
        
    }
   
    [self showOrHiddenTbView:NO];
    //重新请求数据
    if ([self.delegate respondsToSelector:@selector(refreshTbView)]) {
        [self.delegate refreshTbView];
    }
    for (UIButton *btn in _allBtnArray) {
        btn.selected = NO;
    }
}
- (void)initPriceParamaters:(NSString *)price{
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
    debugLog(@"过滤的数据:%ld",(long)num);
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
//价格 最大值 最小值
- (NSMutableDictionary *)priceDic{
    if (_priceDic==nil) {
        _priceDic = [NSMutableDictionary new];
        
    }
    return _priceDic;
}
- (NSMutableDictionary *)moreDic{
    if (_moreDic==nil) {
        _moreDic = [NSMutableDictionary new];
        [_moreDic setObject:self.areaAgeDic forKey:HOUSE_AREAAGE];
    }
    return _moreDic;
}
//面积 最大值 最小值
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
