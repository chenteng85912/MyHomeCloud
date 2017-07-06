
#import "NSString+Extension.h"

@implementation NSString (Extension)

//计算字符串宽带 高度
- (CGSize)sizeWithMaxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

//替换空字符
- (NSString *)resplaceSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//过滤网址
- (NSString *)resplaceUrlStr{
    NSString *fileName = [self stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"." withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];

    return fileName;
    
}
@end
