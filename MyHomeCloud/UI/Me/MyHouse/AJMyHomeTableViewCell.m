//
//  AJMyHomeTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJMyHomeTableViewCell.h"
#import "AJHomeCellModel.h"
#import "UIImageView+WebCache.h"

@implementation AJMyHomeTableViewCell

- (void)processCellData:(AJTbViewCellModel *)data{
    AVObject *object = data.objectData;
    if (data.objectData[HOUSE_OBJECT]) {
        object = data.objectData[HOUSE_OBJECT];
    }
    
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
