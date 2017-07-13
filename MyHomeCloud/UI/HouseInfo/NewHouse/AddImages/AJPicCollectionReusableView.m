//
//  AJPicCollectionReusableView.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJPicCollectionReusableView.h"

@interface AJPicCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation AJPicCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        _titleLabel.text = @"项目现场";
    }else if (indexPath.section==1){
        _titleLabel.text = @"效果图";

    }else if (indexPath.section==2){
        _titleLabel.text = @"小区配套";

    }else{
        _titleLabel.text = @"实景图";

    }
}
@end
