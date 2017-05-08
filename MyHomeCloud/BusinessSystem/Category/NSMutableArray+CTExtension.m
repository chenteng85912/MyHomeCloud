//
//  NSMutableArray+CTExtension.m
//  FacePk
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "NSMutableArray+CTExtension.h"
#import <objc/runtime.h>
@implementation NSMutableArray (CTExtension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL systemSel = @selector(addObject:);
        SEL addSel = @selector(CT_addObject:);
        
        Method systemMethod = class_getClassMethod(self, @selector(addObject:));
        Method addMethod = class_getClassMethod(self, @selector(CT_addObject:));

        BOOL add = class_addMethod(self, addSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        if (add) {
            //如果成功 说明不存在该方法
            class_addMethod(self, systemSel, method_getImplementation(addMethod), method_getTypeEncoding(addMethod));
        }else{
            method_exchangeImplementations(systemMethod, addMethod);

        }
       
    });
}

- (void)CT_addObject:(id)object{
    if (object) {
        [self CT_addObject:object];
    }else
    {
        NSLog(@"object is nil");
    }
//    @try {
//        [self CT_addObject:object];
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"异常名称:%@   异常原因:%@",exception.name, exception.reason);
//    }
//    @finally {
//    }
   
}

@end
