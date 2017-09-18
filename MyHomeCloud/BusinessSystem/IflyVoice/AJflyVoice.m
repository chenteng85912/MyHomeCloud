//
//  TYKYIflyVoice.m
//  TYKYWallBaseSDK
//
//  Created by tjsoft on 2017/9/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJflyVoice.h"
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>

@interface AJflyVoice ()<IFlyRecognizerViewDelegate>

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;

@property (nonatomic, strong) NSString *resultStr;//语音识别结果

@property (weak, nonatomic) id<AJflyVoiceDelegate> delegate;

@end

@implementation AJflyVoice

- (id)initIflyVoiceWithDelegate:(id<AJflyVoiceDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _resultStr = @"";
        [self initiFlyView];
    }
    return self;
}

- (void)initiFlyView{
   
    /**
     语音识别文字
     */
    // 初始化语音识别控件
    self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(dWidth/2, dHeight/2)];
    
    // 设置代理
    self.iflyRecognizerView.delegate = self;
    
    //设置听写模式
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //设置前端点检测时间为6000ms
    [self.iflyRecognizerView setParameter: @"6000" forKey:[IFlySpeechConstant VAD_BOS]];
    //设置后端点检测时间为700ms
    [self.iflyRecognizerView setParameter: @"700" forKey:[IFlySpeechConstant VAD_EOS]];
    //设置采样率为16000
    [self.iflyRecognizerView setParameter: @"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //网络等待时间
    [self.iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    //设置为返回结果中不包含标点符号
    [self.iflyRecognizerView setParameter: @"0" forKey:[IFlySpeechConstant ASR_PTT]];
    //设置语言
    [self.iflyRecognizerView setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    
    //设置音频来源为麦克风
    [self.iflyRecognizerView setParameter:@"1" forKey:@"audio_source"];
    //设置听写结果格式为json
    [self.iflyRecognizerView setParameter: @"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [self.iflyRecognizerView setParameter: @"temp.asr" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置自定义的参数
    [self.iflyRecognizerView setParameter: @"custom" forKey:[IFlySpeechConstant PARAMS]];
    
}
- (void)startIfly{
    [self.iflyRecognizerView start];
}

#pragma mark - 讯飞语音听写代理方法
/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
// 成功
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic){
        [resultString appendString:key];
    }
    _resultStr = [NSString stringWithFormat:@"%@%@",_resultStr,resultString];
    if (isLast) {
        if ([self.delegate respondsToSelector:@selector(sendVoiceText:)]) {
            [self.delegate sendVoiceText:_resultStr];
            _resultStr = @"";
        }
    }
}

// 失败
- (void)onError: (IFlySpeechError *) error {
 
//    [TOPVC.view showTips:@"语音识别错误，请重试" withState:TYKYHUDModeFail complete:nil];
    debugLog(@"语音识别错误%@", error);
}
@end
