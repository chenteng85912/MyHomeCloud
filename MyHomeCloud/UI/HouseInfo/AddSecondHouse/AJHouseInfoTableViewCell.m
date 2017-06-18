//
//  AJNewHouseTableViewCell.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHouseInfoTableViewCell.h"
#import "AJNewHouseModel.h"

@interface AJHouseInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *devlopName;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UILabel *houseYear;

@end
@implementation AJHouseInfoTableViewCell

- (void)processCellData:(AJNewHouseModel *)data{
    _houseName.text  = data.houseName;
    _devlopName.text = data.devlopName;
    _areaName.text = data.areaName;
    _houseYear.text = data.houseYear;
    
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
