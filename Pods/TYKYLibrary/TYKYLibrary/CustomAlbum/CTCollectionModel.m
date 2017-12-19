//
//  CTCollectionModel.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/17.
//  Copyright © 2017年 CHENTENG. All rights reserved.
//

#import "CTCollectionModel.h"
#import "CTPhotosConfig.h"

@implementation CTCollectionModel

- (void)addSelectedIndex:(NSInteger)index{
    CTPHAssetModel *model = self.albumArray[index];
    if (![self.selectedArray containsObject:model]) {
        [self.selectedArray addObject:model];
    }
}
- (void)removeSelectedIndex:(NSInteger)index{
    CTPHAssetModel *model = self.albumArray[index];
    if ([self.selectedArray containsObject:model]) {
        [self.selectedArray removeObject:model];
    }
}
- (NSString *)sendBtnTitle{
  
    if (self.selectedArray.count==0) {
        return @"发送";
    }else{
        return [NSString stringWithFormat:@"发送(%lu)",(unsigned long)self.selectedArray.count];
    }
    
}

- (NSMutableArray <CTPHAssetModel *> *)albumArray{
    if (!_albumArray) {
        _albumArray = [NSMutableArray new];
    }
    return _albumArray;
}
- (NSMutableArray <CTPHAssetModel *> *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}
@end
