//
//  TYKYSearchBar.m
//  TYKYWallBaseSDK
//
//  Created by tjsoft on 2017/9/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJSearchBar.h"

@interface AJSearchBar ()

@property (strong, nonatomic) UIToolbar *toolBar;

@end

@implementation AJSearchBar

- (void)drawRect:(CGRect)rect{
    
    self.inputAccessoryView = self.toolBar;

}

- (void)comfirnAction{
    [super resignFirstResponder];
    
    [self resignFirstResponder];
    if ([self.flyDelegate respondsToSelector:@selector(showIflyView)]) {
        [self.flyDelegate showIflyView];
    }
}


- (UIToolbar *)toolBar{
    if (_toolBar ==nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dWidth, 44)];
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"点击 说出您想搜索的关键词" style:UIBarButtonItemStylePlain target:self action:@selector(comfirnAction)];
        
         UIBarButtonItem *voice =[[UIBarButtonItem alloc] initWithImage:LOADIMAGE(@"voice") style:UIBarButtonItemStylePlain target:nil action:nil];
        
        doneBtn.tintColor = [UIColor blackColor];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [_toolBar setItems:@[space,voice,doneBtn,space]];
    }
    return _toolBar;
}


@end
