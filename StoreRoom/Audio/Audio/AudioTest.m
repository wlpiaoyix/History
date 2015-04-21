//
//  AudioTest.m
//  Audio
//
//  Created by wlpiaoyi on 14-9-29.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "AudioTest.h"

@implementation AudioTest

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin.x = frame.origin.y = 0;
        self.audioPlot = [[EZAudioPlot alloc] initWithFrame:frame];
        [self addSubview:self.audioPlot];
        // Plot type
        self.audioPlot.plotType = EZPlotTypeBuffer;
        self.audioPlot.plotType = EZPlotTypeRolling;
        self.audioPlot.shouldFill = YES;
        self.audioPlot.shouldMirror = YES;
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        self.microphone = [EZMicrophone microphoneWithDelegate:self];
        /*
         Start the microphone
         */
        [self.microphone startFetchingAudio];
    }
    return self;
}
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    printf("%f,%d\n",*buffer[0],bufferSize);
    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
    // Here's a print function to allow you to inspect it a little easier
    [EZAudio printASBD:audioStreamBasicDescription];
}
-(void)    microphone:(EZMicrophone*)microphone
        hasBufferList:(AudioBufferList*)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels{
}

-(void)output:(EZOutput*)output
callbackWithActionFlags:(AudioUnitRenderActionFlags*)ioActionFlags
  inTimeStamp:(const AudioTimeStamp*)inTimeStamp
  inBusNumber:(UInt32)inBusNumber
inNumberFrames:(UInt32)inNumberFrames
       ioData:(AudioBufferList*)ioData{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
