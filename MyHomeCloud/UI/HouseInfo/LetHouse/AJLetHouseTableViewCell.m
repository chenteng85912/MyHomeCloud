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
@property (strong, nonatomic) UILabel *housePrice;

@property (strong, nonatomic) UILabel *houseTag1;
@property (strong, nonatomic) UILabel *houseTag2;
@property (strong, nonatomic) UILabel *houseTag3;
@end
@implementation AJLetHouseTableViewCell

- (void)processCellData:(id <AJTbViewCellModelProtocol>)data{
    
    AJLetHouseCellModel *model = (AJLetHouseCellModel *)data;
    NSString *imgStr = model.objectData[HOUSE_THUMB];
  
    
    self.houseImg.frame = model.imgFrame;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    
    self.houseDes.frame = model.desFrame;
    self.houseDes.text = model.houseDes;
    if (dWidth==320) {
        self.houseDes.font = [UIFont systemFontOfSize:14];
    }
    self.houseInfo.frame = model.infoFrame;
    self.houseInfo.text = model.houseInfo;
    
    self.houseName.frame = model.nameFrame;
    self.houseName.text = model.houseName;
    
    self.housePrice.frame = model.priceFrame;
    self.housePrice.text = model.letPrice;
    
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
