//
//  TJMessageControllerCell.m
//  TYKYTwoLearnOneDo
//
//  Created by TJ-iOS on 16/5/11.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "TJMessageControllerCell.h"
#import "AJMessageBean.h"


@interface TJMessageControllerCell ()

@property (nonatomic, strong) NSIndexPath *index;
@property (weak, nonatomic) IBOutlet UILabel *msgTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *unReadNumber;

@end

@implementation TJMessageControllerCell


-(void)setMessageBean:(AJMessageBean *)messageBean
{
    if (_messageBean != messageBean) {
        _messageBean = messageBean;
        
    }
    _titleLabel.text = messageBean.msgTitle;
    if (messageBean.unReadNum) {
        _unReadNumber.hidden = NO;
        if (messageBean.unReadNum.integerValue>99) {
            _unReadNumber.text = @"99+";

        }else if (messageBean.unReadNum.integerValue==0) {
            _unReadNumber.hidden = YES;
            
        }
        else{
            
            _unReadNumber.text = messageBean.unReadNum;

        }
    }else{
        _unReadNumber.hidden = YES;
    }
    
    _contentLabel.text  = messageBean.msgContent;
    
    _msgTimeLB.text = messageBean.msgTime;
    
    //1预约 2新闻资讯 3系统通知
    if (messageBean.msgType.integerValue==1) {
        _typeIcon.image = LOADIMAGE(@"bespeak_notice");
    }else if (messageBean.msgType.integerValue==2){
        _typeIcon.image = LOADIMAGE(@"news_notice");

    }else{
        _typeIcon.image = LOADIMAGE(@"system_notice");

    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
}


@end
