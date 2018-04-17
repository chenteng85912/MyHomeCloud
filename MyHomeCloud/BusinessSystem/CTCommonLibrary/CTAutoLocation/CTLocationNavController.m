//
//  CTLocationNavController.m
//  CTLibraryDemo
//
//  Created by 陈腾 on 2018/4/13.
//  Copyright © 2018年 CHENTENG. All rights reserved.
//

#import "CTLocationNavController.h"

#define KNAVBAR_HEIGHT     ([[UIApplication sharedApplication] statusBarFrame].size.height+44)

@interface CTLocationNavController ()

@end

@implementation CTLocationNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[self imageFromColor:[UIColor blackColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, KNAVBAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];

}

- (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

@end
