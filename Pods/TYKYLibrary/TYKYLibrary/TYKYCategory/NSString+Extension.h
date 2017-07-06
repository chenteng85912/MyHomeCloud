

#import <UIKit/UIKit.h>

@interface NSString (Extension)

//计算字符串宽带 高度
- (CGSize)sizeWithMaxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

//替换空字符
- (NSString *)resplaceSpace;

//过滤网址
- (NSString *)resplaceUrlStr;

@end
