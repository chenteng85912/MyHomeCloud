//
//  CTImageScrollView.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/11/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVBAR_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height+44)

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@protocol CTImageScrollViewDelegate <NSObject>

- (void)singalTapAction;

@end
@interface CTImageScrollView : UIScrollView

+ (instancetype)initWithFrame:(CGRect)frame
                        image:(id)imageData;

@property (nonatomic,weak) id <CTImageScrollViewDelegate> scrolDelegate;

- (void)refreshShowImage:(UIImage *)img;

@end
