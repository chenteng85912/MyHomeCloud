//
//  CT_TableViewPrensenter.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYKYTableviewProtocol.h"
#import "TYKYTableViewPresenterProtocol.h"
#import "TYKYTableViewRepository.h"
#import "TYKYTableViewModel.h"


@interface TYKYTableViewPresenter : NSObject<TYKYTableViewPresenterProtocol>

@property (weak, nonatomic) id <TYKYTableViewProtocol,TYKYTableViewDelegateProtocol,TYKYTableViewDataSourceProtocol> tbViewVC;

//列表数据初始化任务分发
@property (strong, nonatomic) TYKYTableViewRepository *tableViewRepository;

//列表对应的数据模型
@property (strong, nonatomic) TYKYTableViewModel <TYKYTableViewModelProtocol>*tableViewData;

@end
