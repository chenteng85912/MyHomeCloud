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
    [self startUpload];
}
- (void)startUpload{
    WeakSelf;
    [self.picFile uploadWithProgress:^(NSInteger number) {
        weakSelf.percent = number;
        weakSelf.state = @1;
        if ([weakSelf.delegate respondsToSelector:@selector(refreshUploadProgress:)]) {
            [weakSelf.delegate refreshUploadProgress:number];
        }
    } completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            
            NSString *filePath = [AJLocalDataCenter imagePathWithImageName:weakSelf.picFile.name];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//                [weakSelf.picFile.getData writeToFile:filePath atomically:YES];
                
            }
            
            weakSelf.objId = weakSelf.picFile.objectId;
            weakSelf.picUrl = weakSelf.picFile.url;
            weakSelf.state  =@2;
            [weakSelf saveFileData];
        }else{
            
            weakSelf.state  =@3;
            
        }
        if ([weakSelf.delegate respondsToSelector:@selector(uploadSuccess:)]) {
            [weakSelf.delegate uploadSuccess:succeeded];
        }
    }];

}


- (void)saveFileData{
    if (self.isHome) {
        AVObject *homeHeadObj = [AVObject objectWithClassName:AJCLOUD_INFO];
        
        [homeHeadObj setObject:self.objId   forKey:HOME_IMAGE_ID];
        [homeHeadObj setObject:self.picUrl  forKey:HOME_IMAGE_URL];
        [homeHeadObj setObject:@"test"      forKey:HOME_IMAGE_CONTENT];
        [homeHeadObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                debugLog(@"首页图片保存成功:%@",self.objId);
            }
        }];

    }
}
@end
