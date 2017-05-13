//
//  CT_TableViewPrensenter.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJTbViewProtocol.h"
#import "AJTbViewPresenterProtocol.h"
typedef NS_ENUM(NSInteger,RequestStateModal) {
    RequestSuccessModal,    //请求成功
    RequestTimeOutModal,    //请求超时
    RequestFailModal,       //请求失败
    NetworkHaveProblom,     //网络错误
};

@interface AJTbViewPresenter : NSObject<AJTbViewPresenterProtocol>

@property (weak, nonatomic) id <AJTbViewProtocol,AJTbViewDataSourceProtocol,AJTbViewDelegateProtocol> tbViewVC;

@property (assign, nonatomic) RequestStateModal requestState;
@end
