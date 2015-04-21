//
//  AudioTest2.m
//  Audio
//
//  Created by wlpiaoyi on 14-9-29.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "AudioTest2.h"

@implementation AudioTest2{
    BOOL eof;
}

double timexx;
- (id)initWithFrame:(CGRect)frame
{
    timexx = [[NSDate date] timeIntervalSince1970];
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin.x = frame.origin.y = 0;
        self.audioPlot = [[EZAudioPlotGL alloc] initWithFrame:frame];
        [self addSubview:self.audioPlot];
        // Background color
        self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.816 green: 0.349 blue: 0.255 alpha: 1];
        // Waveform color
        self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // Plot type
        self.audioPlot.plotType        = EZPlotTypeBuffer;
        // Fill
        self.audioPlot.shouldFill      = YES;
        // Mirror
        self.audioPlot.shouldMirror    = YES;
        [self openFileWithFilePathURL];
//        [self play:nil];
    }
    return self;
}

-(void)play:(id)sender {
    if( ![[EZOutput sharedOutput] isPlaying] ){
        if( eof ){
            [self.audioFile seekToFrame:0];
        }
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
    }
}

-(void)openFileWithFilePathURL{
    
    // Stop playback
    [[EZOutput sharedOutput] stopPlayback];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    self.audioFile                        = [EZAudioFile audioFileWithURL:[NSURL fileURLWithPath:url]];
    float totalDuration = self.audioFile.totalDuration;
    SInt64 totalFrames = self.audioFile.totalFrames;
    float time = totalFrames/totalDuration;
    self.audioFile.audioFileDelegate      = self;
    eof                              = NO;
    
    // Set the client format from the EZAudioFile on the output
    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.audioFile.clientFormat];
    
    // Plot the whole waveform
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
        [self play:nil];
    }];
    
}
#pragma mark - EZAudioFileDelegate
-(void)audioFile:(EZAudioFile *)audioFile
       readAudio:(float **)buffer
  withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        if( [EZOutput sharedOutput].isPlaying ){
            if( self.audioPlot.plotType     == EZPlotTypeBuffer &&
               self.audioPlot.shouldFill    == YES              &&
               self.audioPlot.shouldMirror  == YES ){
                self.audioPlot.shouldFill   = NO;
                self.audioPlot.shouldMirror = NO;
            }
            
            printf("%f,%f\n",*buffer[0],*buffer[1]);
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        }
    });
}
-(void)audioFile:(EZAudioFile *)audioFile
 updatedPosition:(SInt64)framePosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        double timex = [[NSDate date] timeIntervalSince1970];
        if (timex-timexx>50) {
            [self seekToFrame:self.audioFile.totalFrames*0.5];
            timexx = timex;
        }
    });
}


#pragma mark - EZOutputDataSource
-(void)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames
{
    if( self.audioFile )
    {
        UInt32 bufferSize;
        [self.audioFile readFrames:frames
                   audioBufferList:audioBufferList
                        bufferSize:&bufferSize
                               eof:&eof];
    }
    if (eof) {
        [self seekToFrame:0];
    }
}


-(AudioStreamBasicDescription)outputHasAudioStreamBasicDescription:(EZOutput *)output {
    return self.audioFile.clientFormat;
}



-(void)seekToFrame:(SInt64)sender {
    [self.audioFile seekToFrame:sender];
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
