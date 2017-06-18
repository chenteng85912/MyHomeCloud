//
//  AJEstateTableViewCell.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/18.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJEstateTableViewCell.h"
#import "AJEstateInfoModal.h"

@interface AJEstateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) UILabel *content;

@end
@implementation AJEstateTableViewCell

- (void)processCellData:(AJEstateInfoModal *)data{
    
    _titleName.text = data.titleName;
    
    self.content.font = [UIFont systemFontOfSize:data.contentFone];
    self.content.frame = data.contentFrame;
    self.content.text = data.content;

}
- (UILabel *)content{
    if (_content == nil) {
        _content = [UILabel new];
        _content.numberOfLines = 0;
        _content.textColor = [UIColor darkGrayColor];
        [self addSubview:_content];;
        
    }
    return _content;
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
