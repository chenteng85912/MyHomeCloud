//
//  TJUserRepository.h
//  MVPProject
//
//  Created by tjsoft on 2017/1/19.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYKYTableViewDataProtocol.h"

@class TYKYTableViewRemoteData;
@class TYKYTableViewLocalData;

//用户信息的数据仓库类，这里可以调用网络或者本地数据操作类
@interface TYKYTableViewRepository : NSObject<TYKYTableViewDataProtocol>

//本地数据操作
@property (strong, nonatomic) TYKYTableViewLocalData *localDataSource;


//网络数据操作
@property (strong, nonatomic) TYKYTableViewRemoteData *remoteDataSource;

@end
