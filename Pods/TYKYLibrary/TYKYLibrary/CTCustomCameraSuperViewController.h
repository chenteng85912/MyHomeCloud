//
//  TJCustomCamera.h
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol TJCameraViewDelegate <NSObject>

//传出图片和图片名称，图片名称为时间戳生成的名称
- (void)sendPicture:(UIImage *)img andImageName:(NSString *)imgName;

@end

@interface CTCustomCameraSuperViewController : UIViewController
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  预览图层
 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) UIView *templateView;//摄像头界面模板

@property (weak, nonatomic)id <TJCameraViewDelegate>delegate;
@property (assign, nonatomic) BOOL isFrontCamera;//是否前置摄像头

//拍摄照片
- (void )takePhotoComplete:(void(^)(UIImage *image))afterTake;
//取消拍摄
- (void)backAction;
//切换摄像头
- (void)switchCamera;
//确认照片
- (void)confirmPhoto;
//旋转图片
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
