//
//  AJUserCenterViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/9.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUserCenterViewController.h"
#import "AJMeCenterData.h"
#import "AJMeModel.h"
#import "AJUserHeadViewController.h"
#import "AJUserHouseViewController.h"
#import "AJFeedbackViewController.h"

static NSString *CellIdentifier = @"AJUserCellId";

@interface AJUserCenterViewController ()<AJUserHeadViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UIView *headInfoView;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UIImageView *roleIcon;
@property (weak, nonatomic) IBOutlet UIView *userHeadView;

@property (strong, nonatomic) NSArray *dataArray;//数据源

@end

@implementation AJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
   
    self.tbView.tableHeaderView = _headView;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initUserData];
    [self initHeadFrame];
}
- (void)initHeadFrame{
    if (dWidth>320) {
        _headView.frame = CGRectMake(0, 0, dWidth, dHeight/3);
        
        _userHeadView.frame = CGRectMake(dWidth/2-50, 60, 100, 100);
        if (dWidth==375) {
            _userHeadView.frame = CGRectMake(dWidth/2-45, 50, 90, 90);
            
        }
        _userName.center = CGPointMake(dWidth/2, CGRectGetMaxY(_userHeadView.frame)+20);
        _roleIcon.center = CGPointMake(dWidth/2, CGRectGetMaxY(_userName.frame)+10);
        _userHeadView.layer.cornerRadius = _userHeadView.frame.size.width/2;
    }
}
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *temp =self.dataArray[section];
    return temp.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *temp = self.dataArray[indexPath.section];
    AJMeModel *model = temp[indexPath.row];
    cell.textLabel.text = model.title;
    if (dWidth==320) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:16];

    }
    UIImage *img = [CTTool scaleImage:LOADIMAGE(model.iconName) toSize:CGSizeMake(25, 25)];
    cell.imageView.image = [img imageChangeThemeColor];
    if ([model.title isEqualToString:@"客服热线"]) {
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(dWidth-120,0, dWidth-120-40, 50)];
        phone.textAlignment = NSTextAlignmentRight;
        phone.textColor = [UIColor lightGrayColor];
        phone.font = [UIFont systemFontOfSize:12];
        phone.text = @"400-600-5555";
        [cell.contentView addSubview:phone];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    if (dWidth==320) {
        return 10;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 10;
    }
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *temp = self.dataArray[indexPath.section];
    AJMeModel *model = temp[indexPath.row];
    
    if (model.phoneNumber) {
        [CTTool takePhoneNumber:model.phoneNumber];
      
        return;
    }
    if (!model.className) {
        return;
    }
    
    if (model.isNeedLogin&&![AVUser currentUser]) {
        [AJSB goLoginViewComplete:^{
            
        }];
        //打开登录界面
        return;
    }
    
    UIViewController *vc = [NSClassFromString(model.className) new];
    vc.title = model.title;
    if ([model.className isEqualToString: NSStringFromClass([AJUserHouseViewController class])]) {
        AJUserHouseViewController *house = (AJUserHouseViewController *)vc;
        house.showModal = model.showModal;
        vc = house;
    }
    if ([model.className isEqualToString: NSStringFromClass([AJFeedbackViewController class])]) {
        AJFeedbackViewController *house = (AJFeedbackViewController *)vc;
        house.showModal = model.showModal;
        vc = house;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    APP_PUSH(vc);
    
}

#pragma mark UIScrollViewDelegate
//头部拉伸放大
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < -20) {
        CGRect currentFrame = _headImg.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = dHeight/3-offsetY;
        _headImg.frame = currentFrame;
        
        CGFloat sub = offsetY+20;
        _headInfoView.center = CGPointMake(dWidth/2, (dHeight/3+sub)/2);
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    if (![AVUser currentUser]) {
        [AJSB goLoginViewComplete:^{
            
        }];
        //打开登录界面
        return;
    }
    if (sender.tag==1) {
        return;
    }
    AJUserHeadViewController *head = [AJUserHeadViewController new];
    head.headImg = self.userHead.image;
    head.delegate  = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:head];
    APP_PRESENT(nav);

}
#pragma mark - AJUserHeadViewControllerDelegate
- (void)uploadSuccess:(UIImage *)image{
    self.userHead.image = image;
}
//角色信息
- (void)initUserData{

    _userHeadView.layer.cornerRadius = _userHeadView.frame.size.width/2;
    _roleIcon.hidden = ![AVUser currentUser];
   
    if ([AVUser currentUser]) {
        [_userName setTitle:[AVUser currentUser][USER_NICKNAME] forState:UIControlStateNormal];
        [self.userHead sd_setImageWithURL:[NSURL URLWithString:[AVUser currentUser][HEAD_URL]] placeholderImage:LOADIMAGE(@"defaultHead")];
        NSInteger role = [[AVUser currentUser][USER_ROLE] integerValue];
        if (role==1) {
            self.roleIcon.image = LOADIMAGE(@"estater");
        }else if (role==2) {
            self.roleIcon.image = LOADIMAGE(@"agency");
        }else if (role==3){
            self.roleIcon.image = LOADIMAGE(@"admin");
            
        }else{
            self.roleIcon.image = LOADIMAGE(@"visitor");

        }
    }else{
        [_userName setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.userHead.image = LOADIMAGE(@"defaultHead");

    }
    self.dataArray = [AJMeCenterData userCenterData];
    [self.tbView reloadData];

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
