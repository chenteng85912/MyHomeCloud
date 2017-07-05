//
//  TJMessageListTableViewCell.m
//  webhall
//
//  Created by Apple on 16/9/26.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "TJMessageListTableViewCell.h"
#import "AJMessageBean.h"


@interface TJMessageListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *msgTime;

@end
@implementation TJMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setMsgBean:(AJMessageBean *)msgBean{
    if (_msgBean!=msgBean) {
        _msgBean = msgBean;
    }

    _unreadLabel.hidden = msgBean.isRead;
    
    _titleLabel.text = msgBean.msgTitle;
    _messageContent.text = msgBean.msgContent;
    
    _msgTime.text = msgBean.msgTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
