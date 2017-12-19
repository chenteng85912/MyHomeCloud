//
//  BigCollectionViewController.h
//
//  Created by Apple on 16/7/22.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTImageScrollView.h"
#import "CTPhotosConfig.h"
#import "CTCollectionModel.h"
#import "UIViewController+CTAlertShow.h"
#import "CTBottomView.h"

@class CTPHAssetModel;

@interface CTPreviewPhotosCollectionViewController : UIViewController

@property (nonatomic,strong) CTCollectionModel *collectionModel;

//@property (nonatomic,assign) BOOL touchPreview;

@end

