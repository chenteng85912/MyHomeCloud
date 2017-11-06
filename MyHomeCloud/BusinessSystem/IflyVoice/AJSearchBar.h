//
//  TYKYSearchBar.h
//  TYKYWallBaseSDK
//
//  Created by tjsoft on 2017/9/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJSearchBarDelegate <NSObject>

- (void)showIflyView;

@end

@interface AJSearchBar : UISearchBar

@property (weak, nonatomic) id<AJSearchBarDelegate> flyDelegate;

@end
