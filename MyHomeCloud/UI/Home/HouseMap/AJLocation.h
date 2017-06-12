//
//  TYKYLocation.h
//  webhall
//
//  Created by tjsoft on 2017/6/12.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AJLocation : NSObject<MKAnnotation>
//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic,copy) NSString *title;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)coor andTitle:(NSString*)t;
@end
