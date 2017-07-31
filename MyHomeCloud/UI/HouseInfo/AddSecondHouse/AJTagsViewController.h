//
//  AJTagsViewController.h
//  MyHomeCloud
//
//  Created by tjsoft on 2017/6/25.
//  Copyright © 2017年 TENG. All rights reserved.
//


#import "AJAddHouserViewController.h"

@protocol AJTagsViewControllerDelegate <NSObject>

- (void)confirmTags:(NSArray *)tagArray;

@end

@interface AJTagsViewController : CTBaseViewController

@property (weak, nonatomic) id<AJTagsViewControllerDelegate>delegate;

@property (assign, nonatomic) AddHouseModal addModal;

@end
