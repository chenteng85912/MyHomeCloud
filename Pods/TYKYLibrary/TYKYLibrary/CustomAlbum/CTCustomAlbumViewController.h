//
//  GroupAlbumViewController.h
//
//  Created by 腾 on 15/9/15.
//
//

#import <UIKit/UIKit.h>

@protocol CTCustomAlbumViewControllerDelegate <NSObject>

@optional
/**
 传出图片字典
 @param imageDic key为图片名称，value为对应的图片 图片顺序和选择顺序可能不同
 */
- (void)sendImageDictionary:(NSDictionary <NSString*,UIImage*> *)imageDic;

//传出图片数组
- (void)sendImageArray:(NSMutableArray <UIImage *> *)imgArray;

@end
/**
 *  调用自定义相册
 *1、模态弹出，请初始化导航栏控制器
 */
@interface CTCustomAlbumViewController : UIViewController


+ (void)showCustomeAlbumWithDelegate:(id <CTCustomAlbumViewControllerDelegate>)rootVC
                        oldImagesDic:(NSDictionary <NSString*,UIImage*> *)imagesDic
                       totalImageNum:(NSInteger)totalNum;

@end
