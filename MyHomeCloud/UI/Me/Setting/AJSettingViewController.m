//
//  AJSettingViewController.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/11.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSettingViewController.h"
#import "AJMeCenterData.h"
#import "CTDelegateObj.h"
#import "CTDataSourceObj.h"
#import "AJMeModel.h"
#import "AppDelegate.h"
#import "AJWechatViewController.h"

static NSString *CellIdentifier = @"TJSettingsCellId";

@interface AJSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) UIView *topView;//顶部视图
@property (strong, nonatomic) CTDelegateObj *tableDelegate;
@property (strong, nonatomic) CTDataSourceObj *tableDatasource;
@property (strong, nonatomic) NSArray *tableList;
@property (strong, nonatomic) AJWechatViewController *wechatVC;

@end

@implementation AJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    // Do any additional setup after loading the view from its nib.
}
//初始化表视图 配置代理
- (void)initTableView{
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    //代理
    _tableDelegate = [CTDelegateObj createTableViewDelegateWithSetRowHeight:60 headerHeight:0 footerHeight:0 selectBlock:^(NSIndexPath *indexPath) {
        [self selectItemAction:indexPath];
    }];
    //数据源
    _tableDatasource = [CTDataSourceObj createTableViewDataSourceWithIdentify:CellIdentifier cellConfigureBlock:^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dWidth==320) {
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }else{
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
        }
        cell.textLabel.text = [(AJMeModel *)model title];
        if ([cell.textLabel.text isEqualToString:@"清理缓存"]) {
            [self initLocalDataSizeLabel:cell.contentView];
        }
    }];
    
    _tableView.delegate = _tableDelegate;
    _tableView.dataSource = _tableDatasource;
    
    self.tableList = [AJMeCenterData getSettingData];
    
    _tableView.tableHeaderView = self.topView;
    if ([AVUser currentUser]) {
        self.footerView.hidden = NO;
        _tableView.tableFooterView = self.footerView;
    }
    
    [_tableDatasource initDataSource:self.tableList];
    [_tableView reloadData];
}

//点击单元格动作
- (void)selectItemAction:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJMeModel *model = self.tableList[indexPath.row];
    if (model.className) {
        
        Class vcClass = NSClassFromString(model.className);//反射
        UIViewController *vc = [vcClass new];
        vc.title = model.title;
       
        APP_PUSH(vc);
        
    }else{
        if ([model.title isEqualToString:@"清理缓存"]) {
            [self clearLocalData];

        }else{
            //微信分享
            [self.wechatVC showOrHiddenView];
        }
        
    }
}
- (IBAction)logoutAction:(UIButton *)sender {

    [UIAlertController alertWithTitle:nil message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] preferredStyle:UIAlertControllerStyleActionSheet block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [CTTool showKeyWindowHUD:@"正在注销..."];
            [[AVUser currentUser] setObject:@0 forKey:USER_LOGIN_STATE];
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [CTTool removeKeyWindowHUD];
                [AVUser logOut];
                [[UIApplication sharedApplication].keyWindow showTips:@"注销成功" withState:TYKYHUDModeSuccess complete:^{
                    [self backToPreVC];

                }];

            }];
           
        }
    }];
}
//清理缓存
- (void)clearLocalData{
    
    WeakSelf;
    [UIAlertController alertWithTitle:@"确定清理?" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"清理缓存"] preferredStyle:UIAlertControllerStyleActionSheet block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [weakSelf.view showHUD:@"正在清理..."];
            [AJLocalDataCenter clearLocalData];
            [AVQuery clearAllCachedResults];

            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                [weakSelf.view removeHUD];
                [weakSelf.view showTips:@"清理成功" withState:TYKYHUDModeSuccess complete:nil];
                
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
}
-(void)initLocalDataSizeLabel:(UIView *)view{
    UILabel *oldLabel = [view viewWithTag:10001];
    if (oldLabel) {
        [oldLabel removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width-135, 15, 100, 30)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.tag = 10001;
    [view addSubview:label];
    label.text = [AJLocalDataCenter calcuteLocalDataSize];
}
- (UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dWidth, 110)];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, dWidth, 20)];
        versionLabel.textAlignment = NSTextAlignmentCenter;
        versionLabel.textColor = [UIColor grayColor];
        versionLabel.font = [UIFont systemFontOfSize:13];
        versionLabel.text = [NSString stringWithFormat:@"版本号：%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
        
        [_topView addSubview:versionLabel];
        
        NSString *iconStr = [[infoDic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconStr]];
        icon.frame = CGRectMake(_topView.center.x-30, 15, 60, 60);
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 5.0;
        [_topView addSubview:icon];
    }
    return _topView;
}
- (AJWechatViewController *)wechatVC{
    if (_wechatVC ==nil) {
        _wechatVC = [AJWechatViewController new];
        _wechatVC.view.alpha = 0.0;
        [self addChildViewController:_wechatVC];
        _wechatVC.view.frame = self.view.bounds;
        [self.view addSubview:_wechatVC.view];
    }
    return _wechatVC;
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
