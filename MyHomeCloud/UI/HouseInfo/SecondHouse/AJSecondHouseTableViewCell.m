//
//  AJTHomeTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSecondHouseTableViewCell.h"
#import "AJSecondHouseCellModel.h"
#import "UIImageView+WebCache.h"

@interface AJSecondHouseTableViewCell ()

@property (strong, nonatomic) UILabel *houseName;//名称
@property (strong, nonatomic) UILabel *houseInfo;//基本信息
@property (strong, nonatomic) UILabel *houseTag1;
@property (strong, nonatomic) UILabel *houseTag2;
@property (strong, nonatomic) UILabel *houseTag3;

@property (strong, nonatomic) UILabel *totalPrice;//总价格
@property (strong, nonatomic) UILabel *unitPrice;//单价格
//@property (strong, nonatomic) UILabel *houseTime;//时间

@property (strong, nonatomic) UIImageView *houseImg;//图片


@end
@implementation AJSecondHouseTableViewCell

- (void)processCellData:(id <AJTbViewCellModelProtocol>)data{
    
    AJSecondHouseCellModel *model = (AJSecondHouseCellModel *)data;
    
    self.houseName.text =  model.houseName;
    self.houseName.frame = model.nameFrame;
    if (dWidth==320) {
        self.houseName.font = [UIFont systemFontOfSize:14];
    }
    self.houseInfo.text = model.subTitle;
    self.houseInfo.frame = model.subFrame;
    
    self.houseTag1.frame  = model.tag1Frame;
    self.houseTag1.text = model.houseTag1;
    self.houseTag1.textColor = [APPDELEGATE desInfo][model.houseTag1];
    self.houseTag1.layer.borderColor = self.houseTag1.textColor.CGColor;
    
    self.houseTag2.frame  = model.tag2Frame;
    self.houseTag2.text = model.houseTag2;
    self.houseTag2.textColor = [APPDELEGATE desInfo][model.houseTag2];
    self.houseTag2.layer.borderColor = self.houseTag2.textColor.CGColor;

    self.houseTag3.frame  = model.tag3Frame;
    self.houseTag3.text = model.houseTag3;
    self.houseTag3.textColor = [APPDELEGATE desInfo][model.houseTag3];
    self.houseTag3.layer.borderColor = self.houseTag3.textColor.CGColor;

    self.totalPrice.text = model.totalPrice;
    self.totalPrice.frame = model.totalFrame;
    
    self.unitPrice.text = model.unitPrice;
    self.unitPrice.frame = model.unitFrame;
    
    self.houseImg.frame = model.imgFrame;;
    NSString *imgStr = model.objectData[HOUSE_THUMB];
   
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)houseName{
    if (_houseName == nil) {
        _houseName = [UILabel new];
        _houseName.font = [UIFont systemFontOfSize:NAME_FONT];
        _houseName.numberOfLines = 0;
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

- (UILabel *)houseTag1{
    if (_houseTag1 == nil) {
        _houseTag1 = [UILabel new];
        _houseTag1.font = [UIFont systemFontOfSize:SUB_FONT];
        _houseTag1.layer.borderWidth = 1.0;
        _houseTag1.layer.cornerRadius = 2.0;
        _houseTag1.layer.masksToBounds = YES;
        _houseTag1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_houseTag1];;
    }
    return _houseTag1;
}
- (UILabel *)houseTag2{
    if (_houseTag2 == nil) {
        _houseTag2 = [UILabel new];
        _houseTag2.font = [UIFont systemFontOfSize:SUB_FONT];
        _houseTag2.layer.borderWidth = 1.0;
        _houseTag2.layer.cornerRadius = 2.0;
        _houseTag2.layer.masksToBounds = YES;
        _houseTag2.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_houseTag2];;
    }
    return _houseTag2;
}
- (UILabel *)houseTag3{
    if (_houseTag3 == nil) {
        _houseTag3 = [UILabel new];
        _houseTag3.font = [UIFont systemFontOfSize:SUB_FONT];
        _houseTag3.layer.borderWidth = 1.0;
        _houseTag3.layer.cornerRadius = 2.0;
        _houseTag3.layer.masksToBounds = YES;
        _houseTag3.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_houseTag3];;
    }
    return _houseTag3;
}
- (UILabel *)totalPrice{
    if (_totalPrice == nil) {
        _totalPrice = [UILabel new];
        _totalPrice.font = [UIFont boldSystemFontOfSize:TOTAL_FONT];
        _totalPrice.textColor = [UIColor redColor];
        [self addSubview:_totalPrice];;

    }
    return _totalPrice;
}

- (UILabel *)unitPrice{
    if (_unitPrice == nil) {
        _unitPrice = [UILabel new];
        _unitPrice.font = [UIFont systemFontOfSize:UNIT_FONT];
        _unitPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:_unitPrice];;
    }
    return _unitPrice;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
