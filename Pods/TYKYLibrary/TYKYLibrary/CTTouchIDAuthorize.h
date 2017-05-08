//
//  Created by 腾 on 16/8/11.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CT_TouchID_Delegate <NSObject>
//必须实现的两个代理方法:
@required
/**
 *
 *  验证成功
 */
- (void)CT_TouchID_AuthorizeSuccess;
/**
 *
 *  验证失败
 */
- (void)CT_TouchID_AuthorizeFailure;

//选择实现的代理方法:
@optional

/**
 *
 *  取消了验证（点击了取消）
 */
- (void)CT_TouchID_AuthorizeUserCancel;

/**
 *
 *  在TouchID对话框点击输入密码按钮
 */
- (void)CT_TouchID_AuthorizeUserFallBack;

/**
 *
 *   在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
 */
- (void)CT_TouchID_AuthorizeSystemCancel;

/**
 *
 *  无法使用TouchID,设备没有设置密码
 */
- (void)CT_TouchID_AuthorizePasswordNotSet;

/**
 *
 *  没有录入TouchID,无法使用
 */
- (void)CT_TouchID_AuthorizeTouchIDNotSet;

/**
 *
 *  该设备的TouchID无效
 */
- (void)CT_TouchID_AuthorizeTouchIDNotAvailable;

/**
 *
 *  多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
 */
- (void)CT_TouchID_AuthorizeTouchIDNotLockOut;

/**
 *
 *  当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
 */
- (void)CT_TouchID_AuthorizeTouchIDAppCancel;

/**
 *
 *  当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
 */
- (void)CT_TouchID_AuthorizeTouchIDInvalidContext;

/**
 *
 *  当前设备不支持指纹识别
 */
- (void)CT_TouchID_AuthorizeNotSupport;

@end

@interface CTTouchIDAuthorize : NSObject

@property (nonatomic, weak) id<CT_TouchID_Delegate> delegate;
/**
 *
 *  发起指纹验证：
 */
- (void)startCT_TouchID_WithMessage:(NSString *)message FallBackTitle:(NSString *)fallBackTitle Delegate:(id<CT_TouchID_Delegate>)delegate;

@end
