//
//  AudioTest2.h
//  Audio
//
//  Created by wlpiaoyi on 14-9-29.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface AudioTest2 : UIView<EZAudioFileDelegate,EZOutputDataSource>

/**
 The EZAudioFile representing of the currently selected audio file
 */
@property (nonatomic,strong) EZAudioFile *audioFile;

/**
 The CoreGraphics based audio plot
 */
@property (nonatomic,strong) EZAudioPlotGL *audioPlot;

@end
