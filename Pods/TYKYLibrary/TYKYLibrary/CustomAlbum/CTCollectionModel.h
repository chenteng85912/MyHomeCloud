//
//  CTCollectionModel.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/17.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPHAssetModel.h"

@interface CTCollectionModel : NSObject

@property (nonatomic,strong) NSMutableArray <CTPHAssetModel *> *albumArray;//相册数组
@property (nonatomic,strong) NSMutableArray <CTPHAssetModel *> *selectedArray;//选中相册数组

@property (nonatomic,assign) BOOL sendOriginImg;//是否输出原图

@property (nonatomic,copy,readonly) NSString *sendBtnTitle;

@property (nonatomic,assign) NSInteger currenIndex;//

- (void)addSelectedIndex:(NSInteger)index;

- (void)removeSelectedIndex:(NSInteger)index;

@end
