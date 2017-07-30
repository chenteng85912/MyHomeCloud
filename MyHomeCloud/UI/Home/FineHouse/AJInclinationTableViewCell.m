//
//  AJInclinationTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/7/30.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJInclinationTableViewCell.h"
#import "AJInclilnationModel.h"

@interface AJInclinationTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inAreaage;
@property (weak, nonatomic) IBOutlet UILabel *inPrice;
@property (weak, nonatomic) IBOutlet UILabel *inRooms;
@property (weak, nonatomic) IBOutlet UILabel *inPhone;
@property (weak, nonatomic) IBOutlet UILabel *tags;

@end
@implementation AJInclinationTableViewCell

- (void)processCellData:(id<AJTbViewCellModelProtocol>)data{
    AJInclilnationModel *model = (AJInclilnationModel *)data;
    
    _typeLabel.text = model.incinationType;
    _inAreaage.text = model.incinationAreaage;
    _inPrice.text = model.incinationPrice;
    _inRooms.text = model.incinationRooms;
    _inPhone.text = model.incinationPhone;
    _tags.text = model.incinationTags;
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
