//
//  CTPhotosNavigationViewController.m
//  TYKYLibraryDemo
//
//  Created by tjsoft on 2017/12/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CTPhotosNavigationViewController.h"
#import "CTAlbumGroupController.h"

@interface CTPhotosNavigationViewController ()

@end

@implementation CTPhotosNavigationViewController

+ (instancetype)initWithDelegate:(id <CTSendPhotosProtocol>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}
- (instancetype)initWithDelegate:(id <CTSendPhotosProtocol>)delegate
{
    self = [super init];
    if (self) {
        [CTPhotoManager setDelegate:delegate];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewControllers = @[[CTAlbumGroupController new]];

}

@end
