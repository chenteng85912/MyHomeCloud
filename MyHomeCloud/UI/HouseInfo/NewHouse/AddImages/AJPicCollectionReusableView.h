//
//  AJPicCollectionReusableView.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/7/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJPicCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic)NSIndexPath *indexPath;
@end
