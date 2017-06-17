//
//  AJReserverTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/17.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJReserverTableViewCell.h"
#import "AJReserverCellModel.h"

@interface AJReserverTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *reserverTime;
@property (weak, nonatomic) IBOutlet UILabel *agenterName;
@property (weak, nonatomic) IBOutlet UILabel *agenterPhone;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;

@property (weak, nonatomic) IBOutlet UILabel *reserverState;
@end
@implementation AJReserverTableViewCell


- (void)processCellData:(id<AJTbViewCellModelProtocol>)data{
    
    AJReserverCellModel *modal = (AJReserverCellModel *)data;
    _creatTime.text = modal.creatTime;
    _houseName.text = modal.houseName;
    _reserverTime.text = modal.rTime;
    _agenterName.text = modal.agenterName;
    _agenterPhone.text = modal.agenterPhone;
    _reserverState.text = modal.state;
    _reserverState.backgroundColor = modal.stateColor;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
