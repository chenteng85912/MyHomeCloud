//
//  CTDataSource.m
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/30.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTDataSourceObj.h"

@interface CTDataSourceObj ()

@property (nonatomic,copy) NSString *cellIdentifier;
@property (nonatomic,copy) CTTbViewCellBlock tbViewCellBlock;
@property (nonatomic,copy) NSMutableArray *dataArray;

@end

@implementation CTDataSourceObj

+ (instancetype)createTableViewDataSourceWithIdentify:(NSString *)identifier
                                   cellConfigureBlock:(CTTbViewCellBlock)cellBlock{
    return [[[self class]alloc]initTableViewWithIdentifier:identifier
                                        cellConfigureBlock:cellBlock];
}

- (instancetype)initTableViewWithIdentifier:(NSString  * _Nullable)identifier
                         cellConfigureBlock:(CTTbViewCellBlock)cellBlock{
    self = [super init];
    if (self) {
        _tbViewCellBlock = cellBlock;
        
        _cellIdentifier = identifier;
    }
   
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return !_dataArray?0:_dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
    }
    id model = _dataArray[indexPath.row];
    if (_tbViewCellBlock) {
        
        _tbViewCellBlock(cell, model,indexPath);
    }
    return cell;
}

- (void)initDataSource:(NSArray * _Nullable)models
              complete:(dispatch_block_t)block{

    _dataArray = [NSMutableArray arrayWithArray:models];
    if (block) {
        block();
    }
}
@end
