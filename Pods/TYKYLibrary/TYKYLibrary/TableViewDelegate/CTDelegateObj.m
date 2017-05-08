//
//  CT_TableViewDelegateObj.m
//  CT_TableViewDelegateDemo
//
//  Created by 腾 on 16/8/14.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTDelegateObj.h"

@interface CTDelegateObj ()
@property (nonatomic, copy)   selectCell selectBlock;
@property (nonatomic, strong) NSMutableArray   *dataList;
@property (nonatomic, assign) CGFloat  rowHeight;
@property (nonatomic, assign) CGFloat  headerHeight;
@property (nonatomic, assign) CGFloat  footerHeight;
@property (nonatomic, assign) CGSize  itemSize;


@end
@implementation CTDelegateObj

+ (instancetype)createTableViewDelegateWithSetRowHeight:(CGFloat)rowHeight
                                           headerHeight:(CGFloat)hHeight
                                           footerHeight:(CGFloat)fHeight
                                            selectBlock:(selectCell)selectBlock{
    
    return [[[self class] alloc] initTableViewDelegateAndSetRowHeight:rowHeight headerHeight:hHeight footerHeight:fHeight selectBlock:selectBlock];
}

- (instancetype)initTableViewDelegateAndSetRowHeight:(CGFloat)rowHeight
                                         headerHeight:(CGFloat)hHeight
                                         footerHeight:(CGFloat)fHeight
                                          selectBlock:(selectCell)selectBlock{
    self = [super init];
    if (self) {
        self.selectBlock = selectBlock;
        self.rowHeight = rowHeight;
        self.headerHeight = hHeight;
        self.footerHeight = fHeight;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return !self.rowHeight?50:self.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return !self.headerHeight?0.01:self.headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return !self.footerHeight?0.01:self.footerHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 将点击事件通过block的方式传递出去
    self.selectBlock(indexPath);
}


@end
