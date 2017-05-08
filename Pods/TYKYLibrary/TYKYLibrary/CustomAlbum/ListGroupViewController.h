//
//  AlbumViewController.h
//
//  Created by 腾 on 15/9/15.
//
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;
@protocol ListGroupViewControllerDelegate <NSObject>

- (void)initGroupDetailsData:(ALAssetsGroup *)group;

@end
@interface ListGroupViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *groupArray;//相册列表数组
@property (nonatomic,strong) UITableView *TbView;
@property (nonatomic,weak) id <ListGroupViewControllerDelegate>delegate;

@end
