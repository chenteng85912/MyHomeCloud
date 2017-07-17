//
//  TJMessageController.m
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/9.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "AJMessageController.h"
#import "TJMessageControllerCell.h"
#import "AJMessageBean.h"
#import "AJMessageBeanDao.h"
#import "TJMessageListDetailsViewController.h"


#define ITEM_HEIGHT 80

@interface AJMessageController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <AJMessageBean *>*dataArray;//表格数据

@end


@implementation AJMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotification:) name:kNotificationUpdateMessage object:nil];

    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TJMessageControllerCell class]) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([TJMessageControllerCell class])];
    
    //设置下拉刷新
    self.tableView.mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(fetchMsgListData)];
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark 接收到新消息通知
- (void)didReceiveRemoteNotification:(NSNotification *)notification
{
    
    [self fetchMsgListData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isRefresh) {
        self.isRefresh = NO;
       
        [self.tableView reloadData];
        if (self.dataArray.count==0) {
            [_tableView addNoMessageTipView];
        }
    }

}

#pragma mark 获取首页消息列表数据
- (void)fetchMsgListData{
    
    NSMutableArray *temp = [NSMutableArray new];
    
    //读取系统消息
    NSArray *systermData = [AJMessageBeanDao findListMessagesWithUserId:DEFAULT_USERID];
    [temp addObjectsFromArray:systermData];
    
    //已经登录后 读取用户相关消息
    if ([AVUser currentUser]) {
        NSArray *tempArr = [AJMessageBeanDao findListMessagesWithUserId:[AVUser currentUser].mobilePhoneNumber];
        [temp addObjectsFromArray:tempArr];

    }
    [self.tableView.mj_header endRefreshing];
    [self.dataArray removeAllObjects];
    if (temp.count ==0) {
        [self.tableView addNoMessageTipView];
        [self.tableView reloadData];

        return;
    }
    
    [self.tableView hiddenTipsView];
    
    [self.dataArray addObjectsFromArray:temp];
    for (AJMessageBean *msg in temp) {
        [self initUnReadNotificationNumbers:msg];
    }

    [self.tableView reloadData];

}

#pragma mark UITableViewDelegate UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessageControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TJMessageControllerCell" forIndexPath:indexPath];
    
    cell.messageBean = self.dataArray[indexPath.row];
    if (indexPath.row==self.dataArray.count-1) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AJMessageBean *messageBean = self.dataArray[indexPath.row];
    
    if (messageBean.msgType.integerValue==17) {

       
        return;
    }
    TJMessageListDetailsViewController *msg = [TJMessageListDetailsViewController new];
    msg.msgBean = messageBean;
    msg.megHome = self;
    msg.listArray = self.dataArray;
    msg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msg animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showAlertView:indexPath];
        
    }
}
#pragma mark 读取未读消息数量
- (void)initUnReadNotificationNumbers:(AJMessageBean *)message{
    
    NSArray *tempArr = [AJMessageBeanDao findMessages:message pageNo:0 pageSize:1000];
    [message.beansArray addObjectsFromArray:tempArr];

    if (tempArr.count==0) {
        return;
    }
    NSInteger unreadNum = 0;
    for (AJMessageBean *bean in tempArr) {
        if (!bean.isRead) {
            unreadNum++;
            continue;
        }
    }
    message.unReadNum = [NSString stringWithFormat:@"%lu",unreadNum];
   
}
- (void)showAlertView:(NSIndexPath *)indexPath{
    [UIAlertController alertWithTitle:@"温馨提示" message:@"删除该类型所有消息？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] preferredStyle:UIAlertControllerStyleAlert block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [self deleteMessage:indexPath];
        }else{
            [self.tableView setEditing:NO];
        }
    }];
    
}
//删除消息
- (void)deleteMessage:(NSIndexPath *)indexPath{
    AJMessageBean *messageBean = self.dataArray[indexPath.row];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.dataArray.count==0) {
        [_tableView addNoMessageTipView];
    }else
    {
        [_tableView hiddenTipsView];
    }
    
    //从数据库删除
    [AJMessageBeanDao deleteOneNotice:messageBean formType:ListMessageType];
    [AJMessageBeanDao deleteMessagesWithMsgType:messageBean];

}
- (NSMutableArray <AJMessageBean *> *)dataArray{
    if (_dataArray ==nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
