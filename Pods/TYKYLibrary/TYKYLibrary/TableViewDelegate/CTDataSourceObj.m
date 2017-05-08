//
//  CTDataSource.m
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/30.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTDataSourceObj.h"

@interface CTDataSourceObj ()

@property (nonatomic,strong) NSString *cellIdentifier;

@end
@implementation CTDataSourceObj

+ (instancetype)createTableViewDataSourceWithIdentify:(NSString *)identifier cellConfigureBlock:(TabelViewCellBlock)cellBlock{
    return [[[self class]alloc]initTableViewWithIdentifier:identifier cellConfigureBlock:cellBlock];
}

- (instancetype)initTableViewWithIdentifier:(NSString *)identifier cellConfigureBlock:(TabelViewCellBlock)cellBlock{
    self = [super init];
    if (self) {
        self.tbViewCellBlock = cellBlock;
        
        self.cellIdentifier = identifier;
    }
   
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return !_dataArray?0:_dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier      forIndexPath:indexPath];
    id model = _dataArray[indexPath.row];
    
    self.tbViewCellBlock(cell, model,indexPath);
    return cell;
}



+ (instancetype)createCollectionViewDataSourceWithIdentify:(NSString *)identifier cellConfigureBlock:(CollectionCellBlock)cellBlock{
    return [[[self class]alloc]initCollectionViewWithIdentifier:identifier cellConfigureBlock:cellBlock];

}
- (instancetype)initCollectionViewWithIdentifier:(NSString *)identifier cellConfigureBlock:(CollectionCellBlock)cellBlock{
    self = [super init];
    if (self) {
        self.colViewCellBlock = cellBlock;
        
        self.cellIdentifier = identifier;
    }
    
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return !_dataArray?0:_dataArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id model = _dataArray[indexPath.row];
    self.colViewCellBlock(cell, model,indexPath);
    return cell;
}

- (void)initDataSource:(NSArray *)models{
    if (!models) {
        return;
    }
    _dataArray = [NSMutableArray arrayWithArray:models];
}
@end
