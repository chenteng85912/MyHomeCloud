//
//  TYKYLocation.m
//  webhall
//
//  Created by tjsoft on 2017/6/12.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJLocation.h"

@implementation AJLocation

-(id)initWithCoordinate:(CLLocationCoordinate2D)coor andTitle:(NSString*)t{
    self = [super init];
    if(self){
        _coordinate = coor;
        _title = t;
    }
    return self;
}
@end
