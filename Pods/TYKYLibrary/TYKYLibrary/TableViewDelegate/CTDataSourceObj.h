//
//  CTDataSource.h
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/30.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TabelViewCellBlock)(UITableViewCell *cell, id model, NSIndexPath * indexPath);
typedef void (^CollectionCellBlock)(UICollectionViewCell *cell, id model, NSIndexPath * indexPath);

@interface CTDataSourceObj : NSObject<UITableViewDataSource,UICollectionViewDataSource>

@property (nonatomic,strong) TabelViewCellBlock tbViewCellBlock;
@property (nonatomic,strong) CollectionCellBlock colViewCellBlock;

@property (nonatomic,strong) NSMutableArray *dataArray;

//初始化UITableView
+ (instancetype)createTableViewDataSourceWithIdentify:(NSString *)identifier cellConfigureBlock:(TabelViewCellBlock)cellBlock;
//初始化UICollectionView
+ (instancetype)createCollectionViewDataSourceWithIdentify:(NSString *)identifier cellConfigureBlock:(CollectionCellBlock)cellBlock;

- (void)initDataSource:(NSArray *)models;

@end
