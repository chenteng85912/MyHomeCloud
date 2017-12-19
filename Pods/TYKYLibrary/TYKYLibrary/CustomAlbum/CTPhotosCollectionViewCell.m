//
//  AlbumCollectionViewCell.m
//
//  Created by 腾 on 15/9/16.
//
//

#import "CTPhotosCollectionViewCell.h"

@interface CTPhotosCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imgView;

@end

@implementation CTPhotosCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)processData:(CTPHAssetModel *)assetModel
          indexPath:(NSIndexPath *)indexPath{

    self.selectBut.selected = assetModel.selected;
    self.selectBut.tag = indexPath.row;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [assetModel.asset fetchThumbImageWithSize:CGSizeMake(width/4, width/4) complete:^(UIImage * _Nullable img) {
        self.imgView.image = img;
    }];
    
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = true;
        [self.contentView addSubview:_imgView];
    }
    [self.contentView bringSubviewToFront:self.selectBut];
    return _imgView;
}
- (UIButton *)selectBut{
    if (!_selectBut) {
        _selectBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-40, self.frame.size.height-40, 40, 40)];
       
        [_selectBut setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [_selectBut setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        _selectBut.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 0, 0);
        [self.contentView addSubview:_selectBut];
    }
    return _selectBut;
}

@end
