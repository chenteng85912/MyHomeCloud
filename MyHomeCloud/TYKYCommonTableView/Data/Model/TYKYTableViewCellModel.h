//
//  CT_TableViewCellModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYKYTableViewCellModelProtocol.h"

@interface TYKYTableViewCellModel : NSObject<TYKYTableViewCellModelProtocol>

@property (strong, nonatomic) NSMutableDictionary *cellInfo;    //单元格原始数据

@property (assign, nonatomic) CGFloat cellHeight;

@end
