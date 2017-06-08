//
//  AJLetHouseCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/6.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJLetHouseCellModel.h"

@implementation AJLetHouseCellModel

- (void)calculateSizeConstrainedToSize{
    AVObject *object = self.objectData;
    if (self.subObj) {
        object = self.subObj;
        
    }
    //图片
    self.imgFrame = CGRectMake(cellX, cellY, IMG_WIDTH, IMG_HEIGHT);
    CGFloat lx = CGRectGetMaxX(self.imgFrame) +cellX;
    
    //描述
    self.houseDes = [NSString stringWithFormat:@"%@ %@ %@元",object[HOUSE_ESTATE_NAME],object[HOUSE_AMOUNT],object[LET_HOUSE_PRICE]];
    CGSize desSize = [self.houseDes sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:NAME_FONT];
    self.desFrame = CGRectMake(lx, cellY, desSize.width, desSize.height);

    //房屋信息
    self.houseInfo = [NSString stringWithFormat:@"%@ %@m² %@",object[HOUSE_AMOUNT],object[HOUSE_AREAAGE],object[HOUSE_DIRECTION]];
    CGSize infoSize = [self.houseInfo sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.infoFrame = CGRectMake(lx, CGRectGetMaxY(self.desFrame)+subY, infoSize.width, infoSize.height);
    
    //名称
    self.houseName = object[HOUSE_ESTATE_NAME];
    CGSize nameSize = [self.houseName sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.nameFrame = CGRectMake(lx, CGRectGetMaxY(self.infoFrame)+subY, nameSize.width, nameSize.height);

    //租金
    self.letPrice = [NSString stringWithFormat:@"%@元/月",object[LET_HOUSE_PRICE]];
    CGSize priceSize = [self.letPrice sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.priceFrame = CGRectMake(dWidth-cellX-priceSize.width-20, CGRectGetMaxY(self.infoFrame)+subY, priceSize.width+20, priceSize.height);
    
    //标签
    self.houseTag = @"随时看房";
    CGSize tagSize = [self.houseTag sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:DES_FONT];
    self.tagFrame = CGRectMake(lx, CGRectGetMaxY(self.nameFrame)+subY, tagSize.width+4, tagSize.height+2);
    
    self.cellHeight = CGRectGetMaxY(self.tagFrame)+cellY;
    
}
@end
