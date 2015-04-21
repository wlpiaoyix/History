//
//  AudioTest3.m
//  Audio
//
//  Created by wlpiaoyi on 14-10-9.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "AudioTest3.h"
#import "SynOperate.h"
@interface AudioTest3()
@end
@implementation AudioTest3
-(void) aa{
    NSError *e;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"]] error:&e]; //使用本地URL创建
    player.volume = 0.4; //0.0-1.0之间
    player.numberOfLoops = 1;//循环播放次数
    NSTimeInterval duration = player.duration;//获取采样的持续时间
    player.currentTime = duration*0.01;//播放位置
    NSUInteger channels = player.numberOfChannels;//声道数,只读属性
    player.delegate = self;
    [player prepareToPlay];
    [player play];
    SynOperate *so = [SynOperate initWIthCallBack:^(SynOperate *so) {
        [player updateMeters];//更新仪表读数
        while (true) {
            [player updateMeters];//更新仪表读数
            for(int i = 0; i<player.numberOfChannels;i++){
                float power = [player averagePowerForChannel:i];
                float peak = [player peakPowerForChannel:i];
                printf("power:%f-",peak);
            }
            printf("\n\n");
            [NSThread sleepForTimeInterval:0.2f];
        }
    } CallBackStart:^(SynOperate *so) {
        
        player.meteringEnabled = YES;//开启仪表计数功能
    } CallBackEnd:^(SynOperate *so) {
        player.meteringEnabled = NO;
    }];
    [so start];
    
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}
@end
