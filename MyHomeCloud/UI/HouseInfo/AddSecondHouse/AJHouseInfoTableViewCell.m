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
@implementation AJNewHouseTableViewCell

- (void)processCellData:(AJNewHouseModel *)data{
    AVObject *object = data.objectData;
    _houseName.text  = object[HOUSE_ESTATE_NAME];
    _devlopName.text = object[HOUSE_DEVELOPER];
    _areaName.text = object[HOUSE_AREA];
    _houseYear.text = object[HOUSE_YEARS];
    
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
