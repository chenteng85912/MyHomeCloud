//
//  TJNoticeDetailsViewController.m
//  webhall
//
//  Created by Apple on 16/7/29.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "TJMessageListDetailsViewController.h"
#import "TJMessageListTableViewCell.h"
#import "AJMessageBean.h"
#import "AJMessageBeanDao.h"
#import "AJMessageController.h"
#import "AJUserHouseViewController.h"
#import "AJWKWebViewController.h"

#define ITEM_HEIGHT 180

@interface TJMessageListDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int pageSize;

@end

@implementation TJMessageListDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _pageSize = 20;

    [self.tbView  registerNib:[UINib nibWithNibName:NSStringFromClass([TJMessageListTableViewCell class]) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([TJMessageListTableViewCell class])];
    
    //设置下拉刷新
    self.tbView .mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(fetchData)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotification:) name:kNotificationUpdateMessage object:nil];
   //1预约 2新闻资讯 3系统通知
    if (self.msgBean.msgType.integerValue==1) {
        self.title  =@"预约消息";
    }else if (self.msgBean.msgType.integerValue==2) {
        self.title  =@"新闻资讯";

    }else{
        self.title  =@"系统通知";

    }
    
}
#pragma mark 接收到新消息通知
- (void)didReceiveRemoteNotification:(NSNotification *)notification
{
    NSString *msgType = notification.userInfo[@"msgType"];
    if (!msgType) {
        return;
    }
    [self.view hiddenTipsView];

    if ([msgType isEqualToString:_msgBean.msgType]) {
        [self.tbView.mj_header beginRefreshing];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark 获取数据
- (void)fetchData{
   
    NSArray *tempArr = [AJMessageBeanDao findMessages:_msgBean pageNo:_page pageSize:_pageSize];
    
    [self.tbView.mj_header endRefreshing];
    [self.msgBean.beansArray removeAllObjects];

    if (tempArr.count==0) {
        [self.view addNoMessageTipView];
        [self.tbView reloadData];
        return;
    }
   [self.tbView hiddenTipsView];
    [self.msgBean.beansArray addObjectsFromArray:tempArr];
    
    if (tempArr.count==_pageSize) {
        _page++;
        _tbView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    [self.tbView reloadData];
    
}
//加载更多数据
- (void)loadMoreData{
    NSArray *tempArr = [AJMessageBeanDao findMessages:_msgBean pageNo:_page pageSize:_pageSize];
    [_tbView.mj_footer endRefreshing];

    if (tempArr.count==0) {
        _tbView.mj_footer = nil;
        
        return;
    }
    if (tempArr.count==_pageSize) {
        _page++;

    }else{
        [self.msgBean.beansArray addObjectsFromArray:tempArr];
        [_tbView reloadData];
        _tbView.mj_footer = nil;

    }
    
}
#pragma mark UITableViewDelegate UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgBean.beansArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJMessageListTableViewCell class]) forIndexPath:indexPath];
    
    cell.msgBean = self.msgBean.beansArray[indexPath.row];
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showAlertView:indexPath.row];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AJMessageBean *msgBean = self.msgBean.beansArray[indexPath.row];
    
    if (!msgBean.isRead) {
        msgBean.isRead = YES;
        TJMessageListTableViewCell *cell = (TJMessageListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.unreadLabel.hidden = YES;
        self.megHome.isRefresh = YES;
        NSInteger unreadNum = self.msgBean.unReadNum.integerValue;
        if (unreadNum>0) {
            unreadNum--;
            self.msgBean.unReadNum = [NSString stringWithFormat:@"%ld",(long)unreadNum];
        }
      
        [AJMessageBeanDao updateMessage:msgBean];
        
    }

    //1预约 2新闻资讯 3系统通知
    NSInteger type = msgBean.msgType.integerValue;
    if (type==1) {
        AJUserHouseViewController *house = [AJUserHouseViewController new];
        house.showModal = ReserverHouseModal;
        APP_PUSH(house);
    }else if (type==2){
        //打开连接
        AJWKWebViewController *webView = [AJWKWebViewController new];
        webView.urlPath = msgBean.msgUrl;
        webView.title = msgBean.msgTitle;
        APP_PUSH(webView);
    }else{
        
    }
    
}

- (void)showAlertView:(NSInteger )index{
    [UIAlertController alertWithTitle:@"温馨提示" message:@"删除该条消息？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [self deleteMessage:index];
        }else{
            [self.tbView setEditing:NO];
        }
    }];
   
}
//删除消息
- (void)deleteMessage:(NSInteger )index{

    AJMessageBean *msgBean = self.msgBean.beansArray[index];
    
    [self.msgBean.beansArray removeObject:msgBean];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [AJMessageBeanDao deleteOneNotice:msgBean formType:DetailsMessageType];
    if (self.msgBean.beansArray.count==0) {
        [self.tbView addNoMessageTipView];
        [AJMessageBeanDao deleteOneNotice:msgBean formType:ListMessageType];
        [self.listArray removeObject:self.msgBean];
    }else{
        if (!msgBean.isRead) {
            NSInteger unreadNum = self.msgBean.unReadNum.integerValue;
            unreadNum--;
            self.msgBean.unReadNum = [NSString stringWithFormat:@"%ld",(long)unreadNum];
        }
    }
    self.megHome.isRefresh = YES;
}

- (void)backToPreVC{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    POPVC;
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
