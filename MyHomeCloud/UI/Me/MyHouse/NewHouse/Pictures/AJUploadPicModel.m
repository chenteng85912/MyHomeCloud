//
//  AJUploadPicModel.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/21.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUploadPicModel.h"

@implementation AJUploadPicModel

- (void)setPicFile:(AVFile *)picFile{
    _picFile = picFile;
//    [self startUpload];
}
- (void)startUpload{
    WeakSelf;
    [self.picFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if ([self.delegate respondsToSelector:@selector(uploadSuccess:)]) {
                [self.delegate uploadSuccess:YES];
            }
           
            weakSelf.state  =@2;
        }else{
            if ([self.delegate respondsToSelector:@selector(uploadSuccess:)]) {
                [self.delegate uploadSuccess:NO];
            }
            weakSelf.state  =@3;

        }
    } progressBlock:^(NSInteger percentDone) {
        weakSelf.percent = percentDone;
        weakSelf.state = @1;
        if ([self.delegate respondsToSelector:@selector(refreshUploadProgress:)]) {
            [self.delegate refreshUploadProgress:percentDone];
        }
    }];
}
@end
