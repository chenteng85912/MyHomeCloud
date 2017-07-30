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
typedef NS_ENUM(NSInteger,HouseShowModal) {
    AllHouseModal,          //所有房源
    MyHouseModal,           //我的房源
    UserFavoriteModal,      //我的收藏
    UserRecordModal,        //浏览记录
    SomeoneHouseModal,      //某个用户的房源
    SearchHouseModal,       //搜索
    UserFeedbackModal,      //用户反馈
    ReserverHouseModal,     //预约
    UserInclinationModal    //意向

};
@interface AJTbViewPresenter : NSObject<AJTbViewPresenterProtocol>

@property (weak, nonatomic) id <AJTbViewProtocol,AJTbViewDataSourceProtocol,AJTbViewDelegateProtocol> tbViewVC;

@property (assign, nonatomic) HouseShowModal showModal;

@property (assign, nonatomic) RequestStateModal requestState;

@end
