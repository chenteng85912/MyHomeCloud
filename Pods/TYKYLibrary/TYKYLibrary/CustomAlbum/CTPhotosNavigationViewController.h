//
//  CTPhotosNavigationViewController.h
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CTPhotosConfig.h"
#import "CTPhotoManager.h"

@interface CTPhotosNavigationViewController : UINavigationController

+ (instancetype)initWithDelegate:(id <CTSendPhotosProtocol>)delegate;

@end
