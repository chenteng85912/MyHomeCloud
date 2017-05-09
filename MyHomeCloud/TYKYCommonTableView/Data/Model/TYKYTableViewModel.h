//
//  CT_TableViewModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYKYTableViewModelProtocol.h"
#import "TYKYTableViewModel.h"



typedef NS_ENUM(NSInteger,RequesetStateModal) {
    RequestSuccessModal,    //请求成功
    RequestTimeOutModal,    //请求超时
    RequestFailModal,       //请求失败
    NetworkHaveProblom,     //网络错误
    
};

@class TYKYTableViewCellModel;

@interface TYKYTableViewModel : NSObject<TYKYTableViewModelProtocol>

@property (strong, nonatomic) NSString *code;   //状态码
@property (strong, nonatomic) NSString *error;  //网络反馈信息
@property (strong, nonatomic) NSString *message;//网络反馈信息
//自定义单元格模型类名
@property (strong, nonatomic) NSString *customeCellModelName;
//表视图数据源,数据更新后复制给列表VC的dataArray;
@property (strong, nonatomic) NSMutableArray <TYKYTableViewCellModel *> *dataSourceArray;
//从本地读取或者存储到本地的数据;
@property (strong, nonatomic) NSMutableArray  *saveLocalDataArray;
//请求状态
@property (assign, nonatomic) RequesetStateModal requestState;

@end
