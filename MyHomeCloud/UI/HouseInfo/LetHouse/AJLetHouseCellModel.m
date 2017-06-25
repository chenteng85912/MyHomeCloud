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
    NSArray *desArray = object[HOUSE_TAGS];
    if (desArray&&desArray.count>0) {
        self.houseTag1 = desArray[0];
        if (desArray.count==2) {
            self.houseTag2 = desArray[1];
        }
        if (desArray.count==3) {
            self.houseTag2 = desArray[1];
            self.houseTag3 = desArray[2];

        }
    }else{
        self.houseTag1 = @"随时看房";

    }
  
    CGSize tag1Size = [self.houseTag1 sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
    self.tag1Frame = CGRectMake(lx, CGRectGetMaxY(self.nameFrame)+subY, tag1Size.width+4, tag1Size.height+2);
    
    if (self.houseTag2) {
        CGSize tag2Size = [self.houseTag2 sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
        self.tag2Frame = CGRectMake(CGRectGetMaxX(self.tag1Frame)+5, CGRectGetMaxY(self.nameFrame)+subY, tag2Size.width+4, tag2Size.height+2);
    }
    if (self.houseTag3) {
        CGSize tag3Size = [self.houseTag3 sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
        self.tag3Frame = CGRectMake(CGRectGetMaxX(self.tag2Frame)+5, CGRectGetMaxY(self.nameFrame)+subY, tag3Size.width+4, tag3Size.height+2);
    }
    self.cellHeight = CGRectGetMaxY(self.tag1Frame)+cellY;
    
}
@end
