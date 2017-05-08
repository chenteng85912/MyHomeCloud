//
//  NSMutableDictionary+IHateNil.m
//  webhall
//
//  Created by Apple on 2016/12/13.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "NSMutableDictionary+IHateNil.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (IHateNil)

+ (void)load{
    Method orginalMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(CT_setObject:forKey:));
    
    //方法替换
    method_exchangeImplementations(orginalMethod, newMethod);
}

- (void)CT_setObject:(id)object forKey:(id)key{
    
    if (!key) {
        NSLog(@"施主，您设置的字典KEY为空啊");

    }else{
        if (object) {
            [self CT_setObject:object forKey:key];
        }else{
            NSLog(@"施主，您设置的字典VALUE为空啊");
        }
    }
   
}
@end
