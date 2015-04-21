//
//  AudioTest.h
//  Audio
//
//  Created by wlpiaoyi on 14-9-29.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface AudioTest : UIView<EZMicrophoneDelegate,EZOutputDataSource>
/**
 The microphone component
 */
@property (nonatomic,strong) EZMicrophone *microphone;
/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,strong) EZAudioPlot *audioPlot;
/**
 The recorder component
 */
@property (nonatomic,strong) EZRecorder *recorder;



@end
