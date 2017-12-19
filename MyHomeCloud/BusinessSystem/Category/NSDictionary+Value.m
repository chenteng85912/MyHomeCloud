

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)

- (id)valueForKey:(NSString *)key{
    
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self[key];
}
- (id)objectForKey:(NSString *)key{
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self[key];
}

@end
