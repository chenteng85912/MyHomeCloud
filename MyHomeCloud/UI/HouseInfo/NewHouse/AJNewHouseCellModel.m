//
//  AJNewHouseCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJNewHouseCellModel.h"

@implementation AJNewHouseCellModel

- (void)calculateSizeConstrainedToSize{
    AVObject *object = self.objectData;

    //图片
    self.imgFrame = CGRectMake(cellX, cellY, IMG_WIDTH, IMG_HEIGHT);
    CGFloat lx = CGRectGetMaxX(self.imgFrame) +cellX;
    
    //名称
    self.estateName = object[HOUSE_ESTATE_NAME];
    CGSize houseSize = [self.estateName sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:NAME_FONT];
    self.nameFrame = CGRectMake(lx, cellY, houseSize.width, houseSize.height);
    
    //地址
    self.address = object[ESTATE_ADDRESS];
    CGSize addressSize = [self.address sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.addressFrame = CGRectMake(lx, CGRectGetMaxY(self.nameFrame)+subY, addressSize.width+5, addressSize.height);
    
    //标签
    self.estateTags = @"住宅 低密度 花园洋房";
    CGSize tagSize = [self.estateTags sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.tagsFrame = CGRectMake(lx, CGRectGetMaxY(self.addressFrame)+subY, tagSize.width, tagSize.height);
    
    //单价
    self.unitPrice = [NSString stringWithFormat:@"均价 约%@元/平",object[HOUSE_UNIT_PRICE]];
    CGSize priceSize = [self.unitPrice sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:TOTAL_FONT];
    self.priceFrame = CGRectMake(lx, CGRectGetMaxY(self.tagsFrame)+subY, priceSize.width+5, priceSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.priceFrame)+cellY;

}
@end
