

#import "UIView+SDXIBExtension.h"

//类别中 手动实现get set方法
@implementation UIView (SDXIBExtension)
// setter for corner Radius
- (void) setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}
- (CGFloat) cornerRadius
{
    return self.layer.cornerRadius;
}
// setter for borderColor
- (void) setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}
- (UIColor *) borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
// setter for borderWidth
- (void) setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}
- (CGFloat) borderWidth
{
    return self.layer.borderWidth;
}

@end
