//
//  AJLetHouseTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJLetHouseTableViewCell.h"
#import "AJLetHouseCellModel.h"

@interface AJLetHouseTableViewCell ()
@property (strong, nonatomic) UIImageView *houseImg;
@property (strong, nonatomic) UILabel *houseDes;
@property (strong, nonatomic) UILabel *houseInfo;
@property (strong, nonatomic) UILabel *houseName;
@property (strong, nonatomic) UILabel *houseTag;
@property (strong, nonatomic) UILabel *housePrice;

@end
@implementation AJLetHouseTableViewCell

- (void)processCellData:(id <AJTbViewCellModelProtocol>)data{
    
    AJLetHouseCellModel *model = (AJLetHouseCellModel *)data;
    NSString *imgStr = model.objectData[HOUSE_THUMB];
  
    
    self.houseImg.frame = model.imgFrame;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    
    self.houseDes.frame = model.desFrame;
    self.houseDes.text = model.houseDes;
    
    self.houseInfo.frame = model.infoFrame;
    self.houseInfo.text = model.houseInfo;
    
    self.houseName.frame = model.nameFrame;
    self.houseName.text = model.houseName;
    
    self.housePrice.frame = model.priceFrame;
    self.housePrice.text = model.letPrice;
    
    self.houseTag.frame  = model.tagFrame;
    self.houseTag.text = model.houseTag;
}

- (UILabel *)houseName{
    if (_houseName == nil) {
        _houseName = [UILabel new];
        _houseName.font = [UIFont systemFontOfSize:DES_FONT];
        _houseName.textColor = [UIColor lightGrayColor];
        [self addSubview:_houseName];;
        
    }
    return _houseName;
}

- (UILabel *)houseInfo{
    if (_houseInfo == nil) {
        _houseInfo = [UILabel new];
        _houseInfo.font = [UIFont systemFontOfSize:SUB_FONT];
        _houseInfo.numberOfLines = 0;
        _houseInfo.textColor = [UIColor lightGrayColor];
        [self addSubview:_houseInfo];;
        
    }
    return _houseInfo;
}

- (UILabel *)houseDes{
    if (_houseDes == nil) {
        _houseDes = [UILabel new];
        _houseDes.font = [UIFont systemFontOfSize:NAME_FONT];
        _houseDes.numberOfLines = 0;
        _houseDes.textColor = [UIColor blackColor];

        [self addSubview:_houseDes];;
        
    }
    return _houseDes;
}

- (UILabel *)housePrice{
    if (_housePrice == nil) {
        _housePrice = [UILabel new];
        _housePrice.font = [UIFont boldSystemFontOfSize:TOTAL_FONT];
        _housePrice.textColor = [UIColor redColor];
        _housePrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:_housePrice];;
    }
    return _housePrice;
}

- (UILabel *)houseTag{
    if (_houseTag == nil) {
        _houseTag = [UILabel new];
        _houseTag.font = [UIFont boldSystemFontOfSize:SUB_FONT];
        _houseTag.textColor = NavigationBarColor;
        _houseTag.layer.borderWidth = 1.0;
//        _houseTag.layer.cornerRadius = 2.0;
        _houseTag.layer.borderColor  = NavigationBarColor.CGColor;
        _houseTag.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_houseTag];;
    }
    return _houseTag;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
