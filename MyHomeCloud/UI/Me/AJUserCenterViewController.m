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
#import "AJMyhouseViewController.h"
#import "AJHouseViewController.h"
#import "AJUserHeadViewController.h"

static NSString *CellIdentifier = @"AJUserCellId";

CGFloat const IMAGEHEIGHT  = 200.0f;

@interface AJUserCenterViewController ()<AJUserHeadViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UIView *headInfoView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIImageView *roleIcon;
@property (weak, nonatomic) IBOutlet UILabel *roleName;
@property (strong, nonatomic) NSArray *dataArray;//数据源

@end

@implementation AJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [AJMeCenterData userCenterData];
    
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tbView.tableHeaderView = self.headView;
    
    self.userName.text = [AVUser currentUser].mobilePhoneNumber;
    [self.userHead sd_setImageWithURL:[NSURL URLWithString:[AVUser currentUser][HEAD_URL]] placeholderImage:LOADIMAGE(@"lauchIcon")];
    
    [self initRoleData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

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
    NSArray *temp = self.dataArray[indexPath.section];
    AJMeModel *model = temp[indexPath.row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [CTTool scaleImage:LOADIMAGE(model.iconName) toSize:CGSizeMake(25, 25)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    if (section==3) {
        return 10;
    }
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *temp = self.dataArray[indexPath.section];
    AJMeModel *model = temp[indexPath.row];
    if (!model.className) {
        return;
    }
    UIViewController *vc = [NSClassFromString(model.className) new];
    vc.title = model.title;
    if ([model.className isEqualToString: NSStringFromClass([AJMyhouseViewController class])]) {
        AJMyhouseViewController *house = (AJMyhouseViewController *)vc;
        if (indexPath.row==0) {
            house.showModal = MyHouseModal;
        }else if (indexPath.row==1){
            house.showModal = FavoriteModal;

        }else if (indexPath.row==2){
            house.showModal = UserRecordModal;

        }else{
            house.showModal = AllHouseModal;

        }
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
        currentFrame.size.height = IMAGEHEIGHT-offsetY;
        _headImg.frame = currentFrame;
        
        CGFloat sub = offsetY+20;
        _headInfoView.center = CGPointMake(dWidth/2, (IMAGEHEIGHT+sub)/2);
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    AJUserHeadViewController *head = [AJUserHeadViewController new];
    head.headImg = self.userHead.image;
    head.delegate  = self;
    head.hidesBottomBarWhenPushed = YES;
    APP_PUSH(head);
}

- (void)uploadSuccess:(UIImage *)image{
    self.userHead.image = image;
}
//角色信息
- (void)initRoleData{
    NSInteger role = [[AVUser currentUser][USER_ROLE] integerValue];
    if (role==1) {
        self.roleIcon.image = LOADIMAGE(@"admin");
        self.roleName.text  = @"管理员";
    }else if (role==2) {
        self.roleIcon.image = LOADIMAGE(@"estater");
        self.roleName.text  = @"物业公司";
    }else if (role==3) {
        self.roleIcon.image = LOADIMAGE(@"agency");
        self.roleName.text  = @"中介";
    }else{
        self.roleIcon.image = LOADIMAGE(@"visitor");
        self.roleName.text  = @"游客";
    }
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
