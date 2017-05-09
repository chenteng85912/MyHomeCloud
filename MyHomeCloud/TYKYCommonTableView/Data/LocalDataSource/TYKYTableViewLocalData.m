//
//  TYKYTableViewLocalData.m
//  MVPProject
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import "TYKYTableViewLocalData.h"
#import "TYKYLocalDataCenter.h"

@implementation TYKYTableViewLocalData

- (NSArray *)readLocalData:(NSString *)localDataKey{
    
    return  (NSArray *)[TYKYLocalDataCenter readLocalData:localDataKey];
    
}

- (void)saveLocalData:(NSMutableArray *)dataArray forKey:(NSString *)localDataKey{
    [TYKYLocalDataCenter saveLocalData:dataArray forKey:localDataKey];
   
}


- (BOOL)checkLocalData:(NSString *)localKey{
    
    return  [TYKYLocalDataCenter checkLocalData:localKey];

}
@end
