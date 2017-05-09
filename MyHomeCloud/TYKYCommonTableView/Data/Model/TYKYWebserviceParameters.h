//
//  TYKYWebserviceParameters.h
//  MVPProject
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYKYWebserviceParameters : NSObject

@property (strong, nonatomic) NSString *webserviceName;

@property (strong, nonatomic) NSString *methodName;//方法名称
@property (strong, nonatomic) NSString *childUrl;  //子类方法
@property (strong, nonatomic) NSString *soapMethod;//soap方法名称

@end
