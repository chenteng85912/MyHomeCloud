//
//  TJMessageControllerCell.h
//  TYKYTwoLearnOneDo
//
//  Created by TJ-iOS on 16/5/11.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJMessageBean;
@interface TJMessageControllerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) AJMessageBean *messageBean;

@end
