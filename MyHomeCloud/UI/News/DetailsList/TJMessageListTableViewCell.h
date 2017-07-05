//
//  TJMessageListTableViewCell.h
//  webhall
//
//  Created by Apple on 16/9/26.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJMessageBean;
@interface TJMessageListTableViewCell : UITableViewCell

@property (nonatomic,strong) AJMessageBean *msgBean;

@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;

@end
