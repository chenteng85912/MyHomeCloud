//
//  AJNewHouseTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouseTableViewCell.h"
#import "AJNewHouseCellModel.h"

@interface AJNewHouseTableViewCell ()
@property (strong, nonatomic) UIImageView *houseImg;
@property (strong, nonatomic) UILabel *houseName;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *unitPrice;
@property (strong, nonatomic) UILabel *estateTags;

@end
@implementation AJNewHouseTableViewCell
- (void)processCellData:(id <AJTbViewCellModelProtocol>)data{
    AJNewHouseCellModel *model = (AJNewHouseCellModel *)data;
    
    NSString *imgStr = model.objectData[HOUSE_THUMB];
    
    self.houseImg.frame = model.imgFrame;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    
    self.houseName.text = model.estateName;
    self.houseName.frame = model.nameFrame;
    
    self.address.text = model.address;
    self.address.frame = model.addressFrame;
    
    self.estateTags.text = model.estateTags;
    self.estateTags.frame = model.tagsFrame;
    
    self.unitPrice.text = model.unitPrice;
    self.unitPrice.frame = model.priceFrame;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIImageView *)houseImg{
    if (_houseImg ==nil) {
        _houseImg = [UIImageView new];
        _houseImg.clipsToBounds = YES;
        _houseImg.contentMode = UIViewContentModeScaleAspectFill;
        _houseImg.layer.masksToBounds = YES;
        _houseImg.layer.cornerRadius = 2.0;
        [self addSubview:_houseImg];
    }
    return _houseImg;
}
- (UILabel *)houseName{
    if (_houseName == nil) {
        _houseName = [UILabel new];
        _houseName.font = [UIFont systemFontOfSize:NAME_FONT];
        _houseName.textColor = [UIColor blackColor];
        [self addSubview:_houseName];;
        
    }
    return _houseName;
}
- (UILabel *)address{
    if (_address == nil) {
        _address = [UILabel new];
        _address.font = [UIFont boldSystemFontOfSize:DES_FONT];
        _address.textColor = [UIColor lightGrayColor];
        [self addSubview:_address];;
        
    }
    return _address;
}
- (UILabel *)estateTags{
    if (_estateTags == nil) {
        _estateTags = [UILabel new];
        _estateTags.font = [UIFont boldSystemFontOfSize:DES_FONT];
        _estateTags.textColor = [UIColor lightGrayColor];
        [self addSubview:_estateTags];;
        
    }
    return _estateTags;
}
- (UILabel *)unitPrice{
    if (_unitPrice == nil) {
        _unitPrice = [UILabel new];
        _unitPrice.font = [UIFont boldSystemFontOfSize:TOTAL_FONT];
        _unitPrice.textColor = [UIColor redColor];
        [self addSubview:_unitPrice];;
        
    }
    return _unitPrice;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
