//
//  AJFeedbackTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFeedbackTableViewCell.h"
#import "AJFeedbackCellModel.h"

@interface AJFeedbackTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end
@implementation AJFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)processCellData:(id<AJTbViewCellModelProtocol>)data{
    AJFeedbackCellModel *model = (AJFeedbackCellModel *)data;
    _timeLabel.text = model.time;
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    _userNameLabel.text = model.userName;
    _state.text = model.stateStr;
    _state.backgroundColor = model.stateColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
