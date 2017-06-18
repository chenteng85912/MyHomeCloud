//
//  AJEstateInfoModal.m
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/18.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJEstateInfoModal.h"

CGFloat const X = 20;
CGFloat const Y = 40;

@implementation AJEstateInfoModal
//kvc
- (instancetype)initValueWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cellInfo = dic;
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)calculateSizeConstrainedToSize{
    self.contentFone = 16;
    
    CGSize contentSize = [self.content sizeWithMaxSize:CGSizeMake(dWidth-X*2, MAXFLOAT) fontSize:self.contentFone];
    
    self.contentFrame = CGRectMake(X, Y, contentSize.width,contentSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.contentFrame)+10;
    
}
@end
