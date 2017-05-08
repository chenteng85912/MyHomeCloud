//
//  LocationViewController.h
//
//  Created by Apple on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTLocationViewControllerDelegate <NSObject>

- (void)sendCityName:(NSString *)cityName;

@end

@interface CTLocationViewController : UIViewController

@property (weak, nonatomic) id<CTLocationViewControllerDelegate>delegate;
@end
