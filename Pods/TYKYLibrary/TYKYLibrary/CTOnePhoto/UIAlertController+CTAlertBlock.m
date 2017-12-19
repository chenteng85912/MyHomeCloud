//
//  UIAlertController+TYKYAlertBlock.m
//

#import "UIAlertController+CTAlertBlock.h"

@implementation UIAlertController (CTAlertBlock)

+ (void)alertWithTitle:(NSString *)title
             message:(NSString *)message
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles
      preferredStyle:(UIAlertControllerStyle)alertStyle
               block:(TouchBlock)block{
    
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    if (cancelButtonTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }]];
    }
    
    for (int i=0; i<otherButtonTitles.count; i++) {
        NSString *title = otherButtonTitles[i];
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (i==0) {
            style = UIAlertActionStyleDestructive;
        }
        [alert addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            block(i+1);
        }]];
    }
    
    UIViewController *rootVC = [self getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
    if (rootVC) {
        [rootVC presentViewController:alert animated:YES completion:nil];
    }

}
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end
