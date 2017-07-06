//
//  UITableView+NoMoreDataInFooter.m
//
//

#import "UITableView+NoMoreDataInFooter.h"

#define DEVICE_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define DEVICE_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define FOOTER_HEIGHT 44.0

@implementation UITableView (NoMoreDataInFooter)

- (void)noticeNoMoreData{
    if (self.contentSize.height<self.frame.size.height) {
        return;
    }
    self.tableFooterView = [self noMoreDataTips];
}

-(UIView *)noMoreDataTips{
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, FOOTER_HEIGHT)];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:bottomLine.frame];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = [UIColor darkGrayColor];
    tip.font = [UIFont systemFontOfSize:12];
    tip.text = @"没有更多数据啦";
    CGFloat tipW = [tip.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH, FOOTER_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:tip.font} context:nil].size.width;
    tip.frame = CGRectMake(DEVICE_WIDTH/2-tipW/2, 0, tipW, FOOTER_HEIGHT);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(20, FOOTER_HEIGHT/2, CGRectGetMinX(tip.frame)-25, 0.5)];
    leftView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tip.frame)+5, FOOTER_HEIGHT/2, CGRectGetMinX(tip.frame)-25, 0.5)];
    rightView.backgroundColor = [UIColor lightGrayColor];
    
    [bottomLine addSubview:tip];
    [bottomLine addSubview:leftView];
    [bottomLine addSubview:rightView];
    return bottomLine;
}
@end
