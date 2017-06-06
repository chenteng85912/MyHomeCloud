//
//  TYKYUILibrary.m
//  webhall
//
//  Created by tjsoft on 2017/3/24.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "CTTool.h"
#import "NSString+Extension.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation CTTool

//生成带边框的按钮
+ (UIButton *)makeCustomRightBtn:(NSString *)title target:(id)target sel:(SEL)actionName{
    CGFloat width = [title sizeWithMaxSize:CGSizeMake(200, 25) fontSize:15].width;
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+8, 25)];
    [right setTitle:title forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    right.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    right.layer.masksToBounds = YES;
    right.layer.cornerRadius = 5.0;
    right.layer.borderWidth = 1;
    right.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [right addTarget:target action:actionName forControlEvents:UIControlEventTouchUpInside];
    return right;
}

//等待提示
+ (void)showKeyWindowHUD:(NSString *)msg{
    //风火轮颜色修改
   
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.bezelView.color = [UIColor blackColor];
        hud.label.textColor = [UIColor whiteColor];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = msg;
        hud.removeFromSuperViewOnHide = YES;
    }
    
}
//移除提示
+ (void)removeKeyWindowHUD{
  
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud) {
        [hud hideAnimated:YES];
    }
}

+ (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
//    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
//    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    
    return header;
}

//应用图标
+ (UIImage *)iconImage{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *iconStr = [[infoDic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:iconStr];
}
//裁剪图片
+ (UIImage *)scaleImage:(UIImage *)img toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [img drawInRect:imageRect];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}
//按宽度裁剪图片
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//手机号合法验证
+ (BOOL)isValidateMobile:(NSString *)mobile{
    
    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,1709,145,176,177
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56]|4[5]|7[6]|7[7])\\d|709)\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,1700
     */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:mobile];
    BOOL res2 = [regextestcm evaluateWithObject:mobile];
    BOOL res3 = [regextestcu evaluateWithObject:mobile];
    BOOL res4 = [regextestct evaluateWithObject:mobile];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//根据文件ID删除文件
+ (void)deleteFile:(NSString *)fileId complete:(void(^)(void))completeHandle{
    NSString *delCql = [NSString stringWithFormat:@"delete from _File where objectId = '%@'",fileId];
    [AVQuery doCloudQueryInBackgroundWithCQL:delCql callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            if (completeHandle) {
                completeHandle();
            }
            debugLog(@"文件删除成功");
        }
        
    }];
    
}
@end
