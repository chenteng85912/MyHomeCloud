//
//  GroupAlbumViewController.h
//
//  Created by 腾 on 15/9/15.
//
//

#import <UIKit/UIKit.h>

@protocol CTCustomAlbumViewControllerDelegate <NSObject>

//传出图片字典，key为图片名称，value为对应的图片
- (void)sendImageDictionary:(NSDictionary <NSString*,UIImage*> *)imageDic;

@end
/**
 *  调用自定义相册
 *1、正常PUSH
 *2、模态弹出，请初始化导航栏控制器
 */
@interface CTCustomAlbumViewController : UIViewController

@property (nonatomic,strong) NSMutableDictionary <NSString*,UIImage*> *picDataDic;//已经选中的图片字典

@property (nonatomic,assign) NSInteger totalNum;//照片最大选择张数

@property (nonatomic,weak) id <CTCustomAlbumViewControllerDelegate> delegate;

@end
