//
//  LazyImageView.m
//  FacePk
//
//  Created by 腾 on 16/6/26.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTLazyImageView.h"
#import "CTDownloadWithSession.h"
#import "CTDownloadGCDOperation.h"

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface CTLazyImageView ()<TJSessionDownloadToolDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *vwIndView;
@property (nonatomic, strong) UILabel *progressLabel;//下载进度
@property (nonatomic, strong) UIButton *reFreshBtn;//重新下载按钮
@property (nonatomic, strong) NSString *urlStr;//下载地址

@end
@implementation CTLazyImageView


#pragma mark 加载网络图片
- (void)loadImageFromURLString:(NSString*)imageURLString{
    self.image = nil;

    self.urlStr = imageURLString;
    
    NSString *filePath  = [self getImagePathWithURLstring:imageURLString];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath ])
    {
        UIImage *savedImage = [UIImage imageWithContentsOfFile:filePath ];
        if (savedImage) {
            self.image = savedImage;
            self.frame = [self makeImageViewFrame:savedImage];
        }
       
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Device_width/2-30, Device_height/2-10, 60, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.progressLabel = label;
    
    self.vwIndView = [UIActivityIndicatorView new];
    self.vwIndView.hidesWhenStopped = YES;
    self.vwIndView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.vwIndView.center = CGPointMake(Device_width/2, Device_height/2-20);
    [self.vwIndView startAnimating];
    [self addSubview:self.vwIndView];
  
    CTDownloadWithSession *request = [self getDownloadToolFromTempArray:imageURLString];
    request.delegate = self;
    
    label.text = request.percentStr;

}
- (CTDownloadWithSession *)getDownloadToolFromTempArray:(NSString *)urlStr{
    
    CTDownloadWithSession *request = [[CTDownloadGCDOperation Instance].downloadingArray valueForKey:urlStr];
    if (!request) {
        request = [[CTDownloadGCDOperation Instance].prepareDownloadArray valueForKey:urlStr];
    }
    
    //新的下载工具
    if (!request) {
        NSString *filePath  = [self getImagePathWithURLstring:urlStr];

        request = [[CTDownloadWithSession alloc] initWithDownloadUrlStr:urlStr];
        request.filePath = filePath;
        [[CTDownloadGCDOperation Instance].prepareDownloadArray setObject:request forKey:urlStr];
        [[CTDownloadGCDOperation Instance] startDownload];
        
    }
    return request;
}
#pragma mark 获取图片地址
- (NSString *)getImagePathWithURLstring:(NSString *)imageURL{
    NSString *fileName = [imageURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *imgPath = [[self documentPath] stringByAppendingPathComponent:fileName];
    
    return imgPath;
}

#pragma mark 获取图片根目录
- (NSString*)documentPath
{
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];

    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:executableFile];
    
    BOOL isDir = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir];
    if(!isExist || !isDir)
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return cachePath;
}

#pragma mark 根据图片大小设置imageview的frame
- (CGRect)makeImageViewFrame:(UIImage *)image{
    
    CGSize imageSize = image.size;
    CGFloat scaleW = imageSize.width/Device_width;
    CGFloat picHeight = imageSize.height/scaleW;
    
    CGFloat picW;
    CGFloat picH;
    
    if (picHeight>Device_height) {
        CGFloat scaleH = picHeight/(Device_height);
        picW = Device_width/scaleH;
        picH = Device_height;
    }else{
        picW = Device_width;
        picH = picHeight;
    }
    
    CGRect newFrame = CGRectMake(Device_width/2-picW/2, Device_height/2-picH/2, picW, picH);
    return  newFrame;
}

#pragma mark 添加警示标语
- (UIButton *)addWarningLabel{
  
    UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 140, 35)];
    downBtn.layer.masksToBounds = YES;
    downBtn.layer.cornerRadius = 5.0;
    downBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    downBtn.layer.borderWidth = 1.0;
    downBtn.center = self.center;
    [downBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [downBtn addTarget:self action:@selector(downloadImageAgain) forControlEvents:UIControlEventTouchUpInside];
    
    return downBtn;

}
#pragma mark 重新下载
- (void)downloadImageAgain{
    
    [self.vwIndView startAnimating];
    self.reFreshBtn.hidden = YES;
    self.progressLabel.hidden = NO;
    
    [[CTDownloadGCDOperation Instance] downLoadAgain:self.urlStr];
}

#pragma mark CTRequestDelegate
- (void)changeProgressValue:(NSString *)progress{
    
    self.progressLabel.text = progress;
    
}
- (void)downLoadedSuccessOrFail:(BOOL)state withUrl:(NSString *)urlStr{
    
    self.progressLabel.hidden = YES;
    [self.vwIndView stopAnimating];
    
    if (state) {//下载成功
        self.transform = CGAffineTransformMakeScale(0.01,0.01);
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            self.transform = CGAffineTransformMakeScale(1.0,1.0);
            
        }];
        [self loadImageFromURLString:urlStr];

        self.userInteractionEnabled = YES;

        if (self.reFreshBtn) {
            self.reFreshBtn.hidden = YES;
        }
        
    }else{
        //下载失败
        if (!self.reFreshBtn) {
            self.reFreshBtn = [self addWarningLabel];
            if (self.superview&&[self.superview isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scr = (UIScrollView *)self.superview;
                scr.maximumZoomScale = 1.0;
                [scr addSubview:self.reFreshBtn];
            }
        }
        
        self.reFreshBtn.hidden = NO;
    }
}

@end
