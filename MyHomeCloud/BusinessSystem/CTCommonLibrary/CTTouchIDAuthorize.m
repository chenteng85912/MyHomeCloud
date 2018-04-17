//
//  Created by 腾 on 16/8/11.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTTouchIDAuthorize.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface CTTouchIDAuthorize ()
@property (nonatomic, weak) id<CT_TouchID_Delegate> delegate;

@end
static CTTouchIDAuthorize *touchId = nil;

@implementation CTTouchIDAuthorize

+ (void)sigtonTouchId
{
    @synchronized(self){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            touchId = [[self alloc] init];
            
        });
    }
}
+ (void)startCT_TouchID_WithMessage:(NSString *)message FallBackTitle:(NSString *)fallBackTitle Delegate:(id<CT_TouchID_Delegate>)delegate
{
    if (!delegate) {
        return;
    }
    [self sigtonTouchId];
    // 1. 判断iOS8.0及以上版本  从iOS8.0开始才有的指纹识别
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        NSLog(@"当前系统暂不支持指纹识别");
        return;
    }
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = fallBackTitle;
    
    NSError *error = nil;
    touchId.delegate = delegate;
    //判断是否支持指纹识别
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //使用context对象对识别的情况进行评估
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {
            //识别成功:
            if (success) {
                if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeSuccess)]) {
                    //必须回到主线程执行,否则在更新UI时会出错！以下相同
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [touchId.delegate CT_TouchID_AuthorizeSuccess];

                    });
                    
                }
            }
            //识别失败（对应代理方法的每种情况,不实现对应方法就没有反应）
            else if (error)
            {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeFailure)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeFailure];
                                
                            });
                        }
                        break;
                    }
                    case LAErrorUserCancel:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeUserCancel)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeUserCancel];
                                
                            });
                           
                        }
                        break;
                    }
                    case LAErrorUserFallback:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeUserFallBack)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeUserFallBack];
                                
                            });
                            
                        }
                        break;
                    }
                    case LAErrorSystemCancel:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeSystemCancel)]) {
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeSystemCancel];
                                
                            });
                        }
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeTouchIDNotSet)]) {
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeTouchIDNotSet];
                                
                            });
                            
                        }
                        break;
                    }
                    case LAErrorPasscodeNotSet:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizePasswordNotSet)]) {
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizePasswordNotSet];
                                
                            });
                            
                        }
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeTouchIDNotAvailable)]) {
                          
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeTouchIDNotAvailable];
                                
                            });
                        }
                        break;
                    }
                    case LAErrorTouchIDLockout:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeTouchIDNotLockOut)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeTouchIDNotLockOut];
                                
                            });
                        }
                        break;
                    }
                    case LAErrorAppCancel:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeTouchIDAppCancel)]) {
                    
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeTouchIDAppCancel];
                                
                            });
                        }
                        break;
                    }
                    case LAErrorInvalidContext:{
                        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeTouchIDInvalidContext)]) {
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [touchId.delegate CT_TouchID_AuthorizeTouchIDInvalidContext];
                                
                            });
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
        }];
    }
    //设备不支持指纹识别
    else
    {
        if ([touchId.delegate respondsToSelector:@selector(CT_TouchID_AuthorizeNotSupport)]) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [touchId.delegate CT_TouchID_AuthorizeNotSupport];
                
            });
        }
    }

}
@end
