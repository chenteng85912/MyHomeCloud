//
//  AJTHomeTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeTableViewCell.h"

@implementation AJHomeTableViewCell

- (void)processCellData:(id<AJTbViewCellModelProtocol>)data{
    AJHomeCellModel *model = (AJHomeCellModel *)data;

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
