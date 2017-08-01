//
//  AJFinanceCellModel.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/8/1.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJFinanceCellModel.h"

CGFloat const CONTENT_FONT = 15.0;

@implementation AJFinanceCellModel

- (void)calculateSizeConstrainedToSize{
    
    CGFloat cellX = 10.0;
    
    self.imgFrame = CGRectMake(0, 0, dWidth, dWidth*0.6);
    _picUrl = self.objectData[HOME_IMAGE_URL];
    
    _content = [self addLineSpace:self.objectData[HOME_IMAGE_CONTENT]];
    
    CGSize houseSize = [_content boundingRectWithSize:CGSizeMake(dWidth-2*cellX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    self.contentFrame = CGRectMake(cellX, cellX+dWidth*0.6, houseSize.width, houseSize.height);
    
    self.cellHeight = CGRectGetMaxY(self.contentFrame) + cellX;
}
- (NSMutableAttributedString *)addLineSpace:(NSString *)text{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0;//行距
    paragraphStyle.firstLineHeadIndent = 30.f;//段首缩进
    
    NSDictionary *attribs = @{NSFontAttributeName:[UIFont systemFontOfSize:CONTENT_FONT],NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    
    return attributedString;
}
@end
