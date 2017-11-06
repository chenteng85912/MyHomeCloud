//
//  TYKYIflyVoice.h
//  TYKYWallBaseSDK
//
//  Created by tjsoft on 2017/9/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AJflyVoiceDelegate <NSObject>

- (void)sendVoiceText:(NSString *)content;

@end

@interface AJflyVoice : NSObject


- (id)initIflyVoiceWithDelegate:(id<AJflyVoiceDelegate>)delegate;

//开始语音识别
- (void)startIfly;

@end
