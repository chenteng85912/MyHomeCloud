//
//  AJHomeCellModel.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/5/13.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSecondHouseCellModel.h"

@implementation AJSecondHouseCellModel
- (void)calculateSizeConstrainedToSize{
    
    AVObject *object = self.objectData;
   
    //图片
    self.imgFrame = CGRectMake(cellX, cellY, IMG_WIDTH, IMG_HEIGHT);
    CGFloat lx = CGRectGetMaxX(self.imgFrame) +cellX;
    
    //名称
    self.houseName = [NSString stringWithFormat:@"%@ %@ %@万",object[HOUSE_ESTATE_NAME],object[HOUSE_AMOUNT],object[HOUSE_TOTAL_PRICE]];
    CGSize houseSize = [self.houseName sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:NAME_FONT];
    self.nameFrame = CGRectMake(lx, cellY, houseSize.width, houseSize.height);
    
    //副标题
    self.subTitle =  [NSString stringWithFormat:@"%@/%@m²/%@",object[HOUSE_AMOUNT],object[HOUSE_AREAAGE],object[HOUSE_ESTATE_NAME]];
    CGSize subSize = [self.subTitle sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
    self.subFrame = CGRectMake(lx, CGRectGetMaxY(self.nameFrame)+subY, subSize.width, subSize.height);
    
    //描述
//    NSDictionary *desObj = object[HOUSE_DESCRIBE];
//    self.houseDes = [NSString stringWithFormat:@"%@ %@ %@",desObj[YEARS_DES],desObj[WATCH_DES],desObj[DECORATE_DES]];
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
    self.tag1Frame = CGRectMake(lx, CGRectGetMaxY(self.subFrame)+subY, tag1Size.width+4, tag1Size.height+2);
    
    if (self.houseTag2) {
        CGSize tag2Size = [self.houseTag2 sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
        self.tag2Frame = CGRectMake(CGRectGetMaxX(self.tag1Frame)+5, CGRectGetMaxY(self.subFrame)+subY, tag2Size.width+4, tag2Size.height+2);
    }
    if (self.houseTag3) {
        CGSize tag3Size = [self.houseTag3 sizeWithMaxSize:CGSizeMake(dWidth-cellX*3-IMG_WIDTH, MAXFLOAT) fontSize:SUB_FONT];
        self.tag3Frame = CGRectMake(CGRectGetMaxX(self.tag2Frame)+5, CGRectGetMaxY(self.subFrame)+subY, tag3Size.width+4, tag3Size.height+2);
    }
    
    //总价
    self.totalPrice = [NSString stringWithFormat:@"%@万",object[HOUSE_TOTAL_PRICE]];
    CGSize totalSize = [self.totalPrice sizeWithMaxSize:CGSizeMake((dWidth-cellX*3-IMG_WIDTH)/2, MAXFLOAT) fontSize:TOTAL_FONT];
    self.totalFrame = CGRectMake(lx, CGRectGetMaxY(self.tag1Frame)+subY, totalSize.width+5, totalSize.height);
    
    //单价
    self.unitPrice = [NSString stringWithFormat:@"%@元/平",object[HOUSE_UNIT_PRICE]];
    CGSize unitSize = [self.unitPrice sizeWithMaxSize:CGSizeMake((dWidth-cellX*3-IMG_WIDTH)/2, MAXFLOAT) fontSize:TOTAL_FONT];
    self.unitFrame = CGRectMake(CGRectGetMaxX(self.totalFrame)+ subY, CGRectGetMaxY(self.tag1Frame)+subY, unitSize.width, unitSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.totalFrame)+cellY;
    
}

@end
