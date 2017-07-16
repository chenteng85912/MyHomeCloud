//
//  AJPickViewTextField.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJPickViewTextField.h"

CGFloat const PICKVIEW_HEIGHT = 200.0;

@interface AJPickViewTextField ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) UIDatePicker *datePick;

@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) NSString *first;
@property (strong, nonatomic) NSString *second;
@property (strong, nonatomic) NSString *third;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@end
@implementation AJPickViewTextField

- (void)drawRect:(CGRect)rect
{
   
    if (self.tag==7||self.tag==8||self.tag==9) {
        self.inputView = self.datePick;

    }else{
        if (self.tag!=2) {
            [self.pickView selectRow:self.firstArray.count/2 inComponent:0 animated:NO];
            [self pickerView:self.pickView didSelectRow:self.firstArray.count/2 inComponent:0];
        }else{
            self.first = self.firstArray[2];
            self.second = self.secondArray[2];
            self.third = self.thirdArray[2];
            
            [self.pickView selectRow:2 inComponent:0 animated:NO];
            [self pickerView:self.pickView didSelectRow:2 inComponent:0];
            
            [self.pickView selectRow:2 inComponent:1 animated:NO];
            [self pickerView:self.pickView didSelectRow:2 inComponent:1];
            
            [self.pickView selectRow:2 inComponent:2 animated:NO];
            [self pickerView:self.pickView didSelectRow:2 inComponent:2];
            
        }
        self.inputView = self.pickView;
    }
    
    self.inputAccessoryView = self.toolBar;
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.tag==2) {
        return 3;
    }
    
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.tag==2) {
        switch (component) {
            case 0:
                return self.firstArray.count;
                break;
            case 1:
                return self.secondArray.count;
                break;
            case 2:
                return self.thirdArray.count;
                break;
            default:
                return self.firstArray.count;

                break;
        }
    }
    return self.firstArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.firstArray[row];

            break;
        case 1:
            return self.secondArray[row];
            
            break;
        case 2:
            return self.thirdArray[row];
            
            break;
        default:
            return self.firstArray[row];

            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.tag==2) {
      
        if (component==0) {
            self.first = self.firstArray[row];
        }else if (component==1){
            self.second = self.secondArray[row];

        }else{
            self.third = self.thirdArray[row];

        }
        
        self.text = [NSString stringWithFormat:@"%@房%@厅%@卫",self.first,self.second,self.third];
    }else{
        self.text = self.firstArray[row];

    }
}

- (void)comfirnAction{
    
    [self resignFirstResponder];
    [super resignFirstResponder];
    
}
- (void)dateChanged:(UIDatePicker *)sender{

    NSDateFormatter *formatter = [NSDateFormatter new];
    if (self.tag==8||self.tag==9) {
        [formatter setDateFormat:@"yyyy-MM-dd"];

    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    }
    self.text = [formatter stringFromDate:sender.date];
}
- (UIDatePicker *)datePick{
    if (_datePick ==nil) {
        _datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        if (self.tag==8||self.tag==9) {
            _datePick.datePickerMode = UIDatePickerModeDate;
        }else{
            _datePick.datePickerMode = UIDatePickerModeDateAndTime;
            _datePick.minimumDate = [NSDate new];
            _datePick.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30*24*60*60];
            _datePick.minuteInterval = 30;
            _datePick.date = [NSDate new];

        }
        [_datePick addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        _datePick.backgroundColor = [UIColor whiteColor];

    }
    return _datePick;
}
- (UIPickerView *)pickView{
    if (_pickView ==nil) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, dWidth, PICKVIEW_HEIGHT)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        if (self.tag==2) {
            UILabel *room = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            room.textAlignment = NSTextAlignmentCenter;
            room.center = CGPointMake(dWidth/3-20, PICKVIEW_HEIGHT/2);
            room.text = @"房";
            [_pickView addSubview:room];
            
            UILabel *room1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            room1.textAlignment = NSTextAlignmentCenter;
            room1.center = CGPointMake(dWidth*2/3-20, PICKVIEW_HEIGHT/2);
            room1.text = @"厅";
            [_pickView addSubview:room1];
            
            UILabel *room2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            room2.textAlignment = NSTextAlignmentCenter;
            room2.center = CGPointMake(dWidth-20, PICKVIEW_HEIGHT/2);
            room2.text = @"卫";
            [_pickView addSubview:room2];
        }
    }
    return _pickView;
}
- (UIToolbar *)toolBar{
    if (_toolBar ==nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dWidth, 44)];
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(comfirnAction)];
        doneBtn.tintColor = NavigationBarColor;
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [_toolBar setItems:@[flexibleSpaceLeft,doneBtn]];
    }
    return _toolBar;
}

- (NSMutableArray *)firstArray{
    if (_firstArray == nil) {
        _firstArray = [NSMutableArray new];
        //户型
        if (self.tag==2) {
            [_firstArray addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];

        }
        //朝向
        if (self.tag==3) {
            [_firstArray addObjectsFromArray:@[@"东",@"南",@"西",@"北",@"东南",@"东北",@"西南",@"西北",@"未知"]];
        }
        //楼层
        if (self.tag==4||self.tag==5) {
            for (int i =1; i<33; i++) {
                [_firstArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        //装修情况
        if (self.tag==6) {
            [_firstArray addObjectsFromArray:@[@"毛坯",@"普通装修",@"精装修",@"豪华装修",@"未知"]];
        }
        
        //物业类型
        if (self.tag==10) {
            [_firstArray addObjectsFromArray:@[@"洋房",@"公寓",@"普通住宅",@"商业",@"未知"]];
        }
        
        //产权年限
        if (self.tag==11) {
            [_firstArray addObjectsFromArray:@[@"40年",@"50年",@"70年",@"未知"]];
        }
        //建筑类型
        if (self.tag==12) {
            [_firstArray addObjectsFromArray:@[@"低层",@"多层",@"中高层",@"高层",@"超高层",@"未知"]];
        }
        //楼盘地区
        if (self.tag==13) {
            [_firstArray addObjectsFromArray:@[@"未知",@"莞城区",@"南城区",@"东城区",@"茶山镇",@"大朗镇",@"寮步镇",
                                               @"常平镇",@"横沥镇",@"东坑镇",@"石排镇",@"企石镇",@"桥头镇",@"谢岗镇",
                                               @"塘厦镇",@"樟木头镇",@"清溪镇",@"黄江镇",@"凤岗镇",
                                               @"万江区",@"高埗镇",@"石碣镇",@"石龙镇",@"麻涌镇",@"中堂镇",@"望牛墩镇",@"洪梅镇",@"道滘镇",
                                               @"虎门镇",@"厚街镇",@"长安镇",@"沙田镇"]];
        }
    }
    return _firstArray;
}
- (NSMutableArray *)secondArray{
    if (_secondArray == nil) {
        _secondArray = [NSMutableArray new];
        //厅
        if (self.tag==2) {
            [_secondArray addObjectsFromArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];

        }
    }
    return _secondArray;
}
- (NSMutableArray *)thirdArray{
    if (_thirdArray == nil) {
        _thirdArray = [NSMutableArray new];
        //卫
        if (self.tag==2) {
            [_thirdArray addObjectsFromArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];

        }
    }
    return _thirdArray;
}
@end
