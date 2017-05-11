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

static NSString *CellIdentifier = @"AJUserCellId";
CGFloat const IMAGEHEIGHT  = 200.0f;

@interface AJUserCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UIView *headInfoView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation AJUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [AJMeCenterData userCenterData];
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tbView.tableHeaderView = self.headView;
    
//    self.userName.text = [AVUser currentUser].mobilePhoneNumber;

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
    [self scaleCellImageView:cell.imageView withImage:[UIImage imageNamed:model.iconName]];
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
    Class vcClass = NSClassFromString(model.className);             //反射
    UIViewController *vc = [vcClass new];
    vc.title = model.title;
    vc.hidesBottomBarWhenPushed = YES;
    APP_PUSH(vc);
    
}

//裁剪图片
- (void)scaleCellImageView:(UIImageView *)imgView withImage:(UIImage *)img{
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [img drawInRect:imageRect];
    
    imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
    if (sender.tag==0) {
        //头像
    }else{
        //登录
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
