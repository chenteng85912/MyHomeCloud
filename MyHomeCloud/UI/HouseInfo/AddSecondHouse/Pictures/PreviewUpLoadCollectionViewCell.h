//
//  PreviewUpLoadCollectionViewCell.h
//  BaoAnTong
//
//  Created by 腾 on 16/8/29.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJCircleView.h"


@class AJUploadPicModel;

@interface PreviewUpLoadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;//选中按钮
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//上传状态
@property (strong, nonatomic) AJUploadPicModel *modal;//数据模型

@end
