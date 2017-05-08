//
//  CT_TableViewDelegateObj.h
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/14.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^selectCell) (NSIndexPath *indexPath);

@interface CTDelegateObj : NSObject<UITableViewDelegate>

/**
 *  创建代理对象实例，并将数据列表传进去
 *  代理对象将消息传递出去，是通过block的方式向外传递消息的
 *  @return 返回实例对象
 */
+ (instancetype)createTableViewDelegateWithSetRowHeight:(CGFloat)rowHeight
                                            headerHeight:(CGFloat)hHeight
                                           footerHeight:(CGFloat)fHeight
                                        selectBlock:(selectCell)selectBlock;
@end
