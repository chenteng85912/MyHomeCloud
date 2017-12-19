//
//  NSMutableDictionary+IHateNil.m
//

#import "NSMutableDictionary+IHateNil.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (IHateNil)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL systemSel = @selector(setObject:forKey:);
        SEL addSel = @selector(CT_setObject:forKey:);
        
        Method orginalMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(CT_setObject:forKey:));
        
        BOOL add = class_addMethod(self, addSel, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod));
        if (add) {
            //如果成功 说明不存在该方法
            class_addMethod(self, systemSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        }else{
            method_exchangeImplementations(orginalMethod, newMethod);
            
        }
        
    });
}

- (void)CT_setObject:(id)object forKey:(id)key{
    
    if (!key) {
        NSLog(@"您设置的字典KEY为空");

    }else{
        if (object) {
            [self CT_setObject:object forKey:key];
        }else{
            NSLog(@"key:%@",key);
            NSAssert(NO, @"您设置的字典VALUE为空");

        }
    }
   
}
@end
