//
//  TJCustomCamera.m
//
//  Created by Apple on 2016/12/9.
//

#import "CTCustomCameraSuperViewController.h"
#import "CTSavePhotos.h"

@interface CTCustomCameraSuperViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIGestureRecognizerDelegate>

/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
@property (nonatomic, strong) UIImage *resultImg;//确认图片
@property (assign, nonatomic) float effectiveScale;//焦距
@property (assign, nonatomic) float beginGestureScale;//起始焦距
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;//缩放手势

@end

@implementation CTCustomCameraSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //缩放手势
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    self.pinchRecognizer = pinchRecognizer;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self setupCamera];
    
    if (_session) {
        [_session startRunning];
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_session) {
        [_session stopRunning];
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

}
//初始化摄像机
- (void)setupCamera
{
    _effectiveScale = 1.0;
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = self.sessionPreset?self.sessionPreset:AVCaptureSessionPreset1920x1080;
    
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasFlash]) {
    
        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        [device lockForConfiguration:nil];
        //设置闪光灯为自动
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device unlockForConfiguration];
        
    }
    _device = device;

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  
    UIView *tempView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tempView];
    _templateView = tempView;
    _previewLayer.frame = self.view.frame;

    [_templateView.layer addSublayer:_previewLayer];
    
    [self.view sendSubviewToBack:_templateView];
    [self switchCamera];
    
}

//拍摄照片
- (void )takePhotoComplete:(void(^)(UIImage *image))afterTake{
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    [stillImageConnection setVideoScaleAndCropFactor:_effectiveScale];
    
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        //此部分代码不能加入到主线程中
        [_session stopRunning];
        
        if (!imageDataSampleBuffer) {
            return;
        }
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:jpegData];
            self.resultImg = [self image:img rotation:UIImageOrientationRight];
            if (img&&afterTake) {
                afterTake(self.resultImg);
                NSLog(@"图片大小:%@",NSStringFromCGSize(img.size));
                
            }
        });
        
    }];

}
//取消拍摄
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];

    }];

}
//切换摄像头
- (void)switchCamera{
    AVCaptureDevicePosition desiredPosition;
    if (!self.isFrontCamera){
        desiredPosition = AVCaptureDevicePositionBack;
        [self.view addGestureRecognizer:self.pinchRecognizer];
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
        [self.view removeGestureRecognizer:self.pinchRecognizer];
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            if ([d supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
                self.previewLayer.session.sessionPreset = AVCaptureSessionPreset1920x1080;
                
            }else if ([d supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]){
                self.previewLayer.session.sessionPreset = AVCaptureSessionPreset1280x720;
                
            }
            [self.previewLayer.session addInput:input];
            
            [self.previewLayer.session commitConfiguration];
            
            break;
        }
    }
    
    self.isFrontCamera = !self.isFrontCamera;

}
//确认照片
- (void)confirmPhoto:(UIImage *)image{
   
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendPicture:andImageName:)]) {
            if (!image) {
                NSLog(@"拍摄图片失败");
                return;
            }
            [self.delegate sendPicture:image andImageName:[NSString stringWithFormat:@"%.f",[[NSDate new] timeIntervalSince1970]]];
        }
        if ([CTSavePhotos checkAuthorityOfAblum]) {
            //存入相册
            [CTSavePhotos saveImageIntoAlbum:image];
        }

    }];
    
}

//缩放手势 用于调整焦距 相机支持的焦距是1.0~67.5
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.templateView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"焦距-----------：%f",self.effectiveScale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"最大焦距--------:%f",maxScaleAndCropFactor);//67.5
        maxScaleAndCropFactor = 30.0;
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

//旋转图片
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
//设备方向
- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
            break;
        default:
            return AVCaptureVideoOrientationPortrait;
            
            break;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
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
