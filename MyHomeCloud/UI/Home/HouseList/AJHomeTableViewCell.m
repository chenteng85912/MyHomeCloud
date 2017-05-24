//
//  AJTHomeTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJHomeTableViewCell.h"
#import "AJHomeCellModel.h"
#import "UIImageView+WebCache.h"

@interface AJHomeTableViewCell ()

@property (strong, nonatomic) UILabel *houseName;//名称
@property (strong, nonatomic) UILabel *houseInfo;//基本信息
@property (strong, nonatomic) UILabel *houseDes;//描述
@property (strong, nonatomic) UILabel *totalPrice;//总价格
@property (strong, nonatomic) UILabel *unitPrice;//单价格
//@property (strong, nonatomic) UILabel *houseTime;//时间

@property (strong, nonatomic) UIImageView *houseImg;//图片
@property (strong, nonatomic) UIImageView *userHeadImg;//头像



@end
@implementation AJHomeTableViewCell

- (void)processCellData:(id <AJTbViewCellModelProtocol>)data{
    
    AJHomeCellModel *model = (AJHomeCellModel *)data;
    
    self.houseName.text =  model.houseName;
    self.houseName.frame = model.nameFrame;
    
    self.houseInfo.text = model.subTitle;
    self.houseInfo.frame = model.subFrame;
    
    self.houseDes.text = model.houseDes;
    self.houseDes.frame = model.desFrame;
    
    self.totalPrice.text = model.totalPrice;
    self.totalPrice.frame = model.totalFrame;
    
    self.unitPrice.text = model.unitPrice;
    self.unitPrice.frame = model.unitFrame;
    
    self.houseImg.frame = model.imgFrame;;
    NSString *imgStr = model.objectData[HOUSE_THUMB];
    if (model.subObj) {
        imgStr = model.subObj[HOUSE_THUMB];
    }
    self.houseImg.layer.masksToBounds = YES;
    self.houseImg.layer.cornerRadius = 2.0;
    self.houseImg.clipsToBounds = YES;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:LOADIMAGE(@"defaultImg")];
    
//    self.userHeadImg.frame = model.userHeadFrame;
//    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:model.userObj[HEAD_URL]] placeholderImage:LOADIMAGE(@"userDefault")];

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

- (UILabel *)houseDes{
    if (_houseDes == nil) {
        _houseDes = [UILabel new];
        _houseDes.font = [UIFont systemFontOfSize:DES_FONT];
        _houseDes.numberOfLines = 0;
        _houseDes.textColor = [UIColor lightGrayColor];
        [self addSubview:_houseDes];;

    }
    return _houseDes;
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
        [self addSubview:_houseImg];
    }
    return _houseImg;
}
- (UIImageView *)userHeadImg{
    if (_userHeadImg ==nil) {
        _userHeadImg = [UIImageView new] ;
        _userHeadImg.clipsToBounds = YES;
        _userHeadImg.layer.masksToBounds = YES;
        _userHeadImg.layer.cornerRadius = 15;
        _userHeadImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_userHeadImg];
    }
    return _userHeadImg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
