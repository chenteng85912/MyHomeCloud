//
//  AJHomeDataProtocol.h
//  MyHomeCloud
//
//  Created by 腾 on 2017/6/10.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestBlock) (BOOL success, NSArray *returnValue);

@protocol AJHomeDataProtocol <NSObject>

@optional

//二手房数据
- (void)fetchSecondHouseDataCompleteHander:(RequestBlock)afterRequest;

//出租房数据
- (void)fetchLetHouseDataCompleteHander:(RequestBlock)afterRequest;

//新房数据
- (void)fetchNewHouseDataCompleteHander:(RequestBlock)afterRequest;

//保存浏览记录
- (void)addRecordData:(AVObject *)object recordClassName:(NSString *)recordClassName;

//添加收藏
- (void)addFavoriteData:(AVObject *)object favClassName:(NSString *)favClassName complete:(RequestBlock)afterRequest;

@end
