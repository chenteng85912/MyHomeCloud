//
//  PreviewUpLoadCollectionViewCell.m
//  BaoAnTong
//
//  Created by 腾 on 16/8/29.
//  Copyright © 2016年 深圳太极云软技术股份有限公司. All rights reserved.
//

#import "PreviewUpLoadCollectionViewCell.h"
#import "AJUploadPicModel.h"


#define circleWidth dWidth==320?40:50
#define successColor [UIColor colorWithRed:28.0/255.0 green:175.0/255.0 blue:53.0/255.0 alpha:1]
#define failColor   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]
#define waitColor   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

@interface PreviewUpLoadCollectionViewCell ()<AJUploadPicModelDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet UIView *backView;//蒙版
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//上传状态
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;//上传进度
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;//刷新按钮
@property (strong, nonatomic) TJCircleView *circleView;//贝塞尔曲线

@end

@implementation PreviewUpLoadCollectionViewCell

- (void)setModal:(AJUploadPicModel *)modal{

    _modal = modal;
    
    //读取本地图片
    NSString *filePath = [CTTool imagePathWithImageName:modal.picFile.name];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    _imgView.image = [UIImage imageWithData:imgData];

    modal.delegate = self;
    _percentLabel.text = [NSString stringWithFormat:@"%ld%%",(long)modal.percent];
    self.circleView.progressValue = modal.percent/100.0;
}

- (void)refreshUploadProgress:(NSInteger)progress{
    _percentLabel.text = [NSString stringWithFormat:@"%ld%%",(long)progress];
    self.circleView.progressValue = progress/100.0;
    _percentLabel.backgroundColor = waitColor;
    _progressLabel.text = @"上传中";

}
- (void)uploadSuccess:(BOOL)success{
    _refreshBtn.hidden = success;

    if (success) {
        _progressLabel.text = @"已上传";
        _percentLabel.backgroundColor = successColor;
        _percentLabel.hidden = YES;
        self.circleView.hidden = YES;
        self.circleView.progressValue  =0;
        
    }else{
        _progressLabel.text = @"上传失败";
        _percentLabel.backgroundColor = failColor;

    }
}
- (IBAction)reUploadPictureAction:(UIButton *)sender {

    _refreshBtn.hidden = YES;

    [self.modal startUpload];


}
- (TJCircleView *)circleView{
    if (_circleView ==nil) {
        _circleView = [[TJCircleView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth) progessColor:NavigationBarColor progressTrackColor:[UIColor lightGrayColor] progressStrokeWidth:3.0];
        _circleView.center  = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
        [self addSubview:_circleView];
    }
    return _circleView;
}
- (void)awakeFromNib {
    [super awakeFromNib];

}

@end
