//
//  TJUserRepository.m
//  MVPProject
//
//  Created by tjsoft on 2017/1/19.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import "TYKYTableViewRepository.h"
#import "TYKYTableViewRemoteData.h"
#import "TYKYTableViewLocalData.h"

@implementation TYKYTableViewRepository


- (TYKYTableViewLocalData *)localDataSource{
    if (!_localDataSource) {
        _localDataSource = [TYKYTableViewLocalData new];
    }
    return _localDataSource;
}
- (TYKYTableViewRemoteData *)remoteDataSource{
    if (!_remoteDataSource) {
        _remoteDataSource = [TYKYTableViewRemoteData new];
    }
    return _remoteDataSource;
}
//远程数据
- (void)fetchDataWithUrlStr:(NSString *)urlString
             bodyParameters:(NSMutableDictionary *)params
                   complete:(void(^)(NSError *error, id objectDic))afterRequest{
    
    [self.remoteDataSource fetchDataWithUrlStr:urlString
                                bodyParameters:params
                                      complete:^(NSError *error, id objectDic) {
                                          if (afterRequest) {
                                              afterRequest(error,objectDic);
                                          }
    }];
     
    
}

//本地数据
- (NSArray *)readLocalData:(NSString *)localDataKey{
    
    return  [self.localDataSource readLocalData:localDataKey];
}
//检测本地数据 时效性
- (BOOL)checkLocalData:(NSString *)localKey{
   return [self.localDataSource checkLocalData:localKey];
}
- (void)saveLocalData:(NSMutableArray *)dataArray forKey:(NSString *)localDataKey{
    [self.localDataSource saveLocalData:dataArray forKey:localDataKey];
}
@end
