

#import <UIKit/UIKit.h>


@interface UIView (SDXIBExtension)

// IBInspectable makes the property to be inspected from nib. Use camel case for property name as nib would parse it and separate it into separate words for better readability

@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

@end
