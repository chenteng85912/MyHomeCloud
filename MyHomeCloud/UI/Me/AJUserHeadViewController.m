//
//  AJUserHeadViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/20.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJUserHeadViewController.h"

@interface AJUserHeadViewController ()<CTONEPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) UIImageView *headImageView;

@end

@implementation AJUserHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的头像";
    [self.scrView addSubview:self.headImageView];

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseUserHead)];

    
}
#pragma mark 设置预览图片的大小
- (UIImageView *)headImageView{
    if (_headImageView==nil) {
        CGSize imageSize = self.headImg.size;
        CGFloat scaleW = imageSize.width/dWidth;
        CGFloat picHeight = imageSize.height/scaleW;
        
        CGFloat picW;
        CGFloat picH;
        
        if (picHeight>dHeight-64) {
            CGFloat scaleH = picHeight/(dHeight-64);
            picW = dWidth/scaleH;
            picH = dHeight-64;
        }else{
            picW = dWidth;
            picH = picHeight;
        }
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picW, picH)];
        _headImageView.center = CGPointMake(dWidth/2, (dHeight-64)/2);
        _headImageView.image = self.headImg;
    }
  
    return _headImageView;
    
}
#pragma mark 图片放大缩小后位置校正
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
 
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.headImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark 手势放大图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)tmpScrollView
{
    
    return self.headImageView;
}
#pragma mark 双击放大缩小
-(void)doubleTap:(UITapGestureRecognizer *)gestureRecognize {
    
    if (self.scrView.zoomScale==1.0) {
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            self.scrView.zoomScale = 3.0;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            self.scrView.zoomScale = 1.0;
            
        }];
    }
    
}

- (void)chooseUserHead{
    WeakSelf;
    [UIAlertController alertWithTitle:@"更换头像" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册选取",@"保存头像"] preferredStyle:UIAlertControllerStyleActionSheet block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [CTONEPhoto shareSigtonPhoto].delegate = weakSelf;
            [[CTONEPhoto shareSigtonPhoto] openCamera:weakSelf editModal:YES];
        }else if (buttonIndex==2){
            [CTONEPhoto shareSigtonPhoto].delegate = weakSelf;
            [[CTONEPhoto shareSigtonPhoto] openAlbum:weakSelf editModal:YES];
        }else if (buttonIndex==3){
            if ([[CTSavePhotos new] checkAuthorityOfAblum]) {
                //存入相册
                [[CTSavePhotos new] saveImageIntoAlbum:weakSelf.headImg];
                [self.view showTips:@"保存成功" withState:TYKYHUDModeSuccess complete:nil];
            }
        }
    }];

}
#pragma mark - CTONEPhotoDelegate
- (void)sendOnePhoto:(UIImage *)image withImageName:(NSString *)imageName;{
    [self saveUserHeadImage:[CTTool imageCompressForWidth:image targetWidth:600]];
    
}
#pragma mark 上传用户头像
- (void)saveUserHeadImage:(UIImage *)image{
    self.headImageView.image = image;

    NSData *imgData = UIImageJPEGRepresentation(image, 0.8);
    AVFile *file = [AVFile fileWithName:[AVUser currentUser].mobilePhoneNumber data:imgData];
    
    [CTTool showKeyWindowHUD:@"正在上传..."];
    WeakSelf;
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [CTTool removeKeyWindowHUD];
        if (!succeeded) {
            [[UIApplication sharedApplication].keyWindow showTips:@"上传失败，请重试" withState:TYKYHUDModeSuccess complete:nil];
            return;
        }
        
        if ([weakSelf.delegate respondsToSelector:@selector(uploadSuccess:)]) {
            [weakSelf.delegate uploadSuccess:image];
        }

        [[UIApplication sharedApplication].keyWindow showTips:@"上传成功" withState:TYKYHUDModeSuccess complete:^{
            [weakSelf backToPreVC];
        }];

        //删除旧头像文件
        [AJSB deleteFile:[AVUser currentUser][USER_HEAD_IMG_ID] complete:nil];
        
        //保存新头像地址
        [[AVUser currentUser] setObject:file.url forKey:HEAD_URL];
        [[AVUser currentUser] setObject:file.objectId forKey:USER_HEAD_IMG_ID];
        [[AVUser currentUser] saveInBackground];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
