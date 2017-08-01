//
//  AJFinanceTableViewCell.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/8/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFinanceTableViewCell.h"
#import "AJFinanceCellModel.h"

@interface AJFinanceTableViewCell ()
@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UILabel *content;

@end
@implementation AJFinanceTableViewCell

- (void)processCellData:(id<AJTbViewCellModelProtocol>)data{
    AJFinanceCellModel *model = (AJFinanceCellModel *)data;
    
    self.imgView.frame = model.imgFrame;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:LOADIMAGE(@"defaultImg")];
    
    self.content.attributedText = model.content;
    self.content.frame = model.contentFrame;
    
    self.imgBtn.frame = model.imgFrame;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIImageView *)imgView{
    if (_imgView ==nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
    }
    return _imgView;
}
- (UILabel *)content{
    if (_content == nil) {
        _content = [UILabel new];
        _content.font = [UIFont systemFontOfSize:CONTENT_FONT];
        _content.textColor = [UIColor blackColor];
        _content.backgroundColor = [UIColor clearColor];
        _content.numberOfLines = 0;
        [self addSubview:_content];;
    }
    return _content;
}
- (UIButton *)imgBtn{
    if (_imgBtn ==nil) {
        _imgBtn = [UIButton new];
        [self addSubview:_imgBtn];
    }
    return _imgBtn;
}
@end
