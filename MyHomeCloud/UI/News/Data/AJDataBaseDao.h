//
//  TJDataBaseDao.h
//  TYKYTwoLearnOneDo
//
//  Created by tjsoft on 16/5/12.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface AJDataBaseDao : NSObject

+ (FMDatabaseQueue *)shareDatabaseQueue;

@end
