//
//  SimpleAVAudioPlayer.h
//  Audio
//
//  Created by wlpiaoyi on 14-10-9.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

//默认声音大小
extern float DEFAULT_VOLUME;
//默认循环次数
extern unsigned int DEFAULT_NUMBEROFLOOPS;
//默认进度
extern float DEFAULT_PROGRESS;

@interface SimpleAVAudioPlayer : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,strong,readonly) AVAudioPlayer *player;
//播放文件的index
@property (nonatomic) unsigned int indexPlay;
//播放文件列表
@property (nonatomic,strong,readonly) NSMutableArray *arrayAudiosURL;
//当前文件信息
@property (nonatomic,strong,readonly) NSDictionary *audioInfo;
/**
 添加音频播放文件URL
 */
- (void) addAudioUrl:(NSURL*) url;
/**
 添加音频播放文件名称
 */
- (void) addAudioName:(NSString*) name ofType:(NSString*) ext;
/**
 开始播放
 */
- (void) play;
/**
 从指定的位置播放 
 @progress 0-1
 */
- (void) playProgress:(float) progress;
/**
 暂停
 */
- (void) pause;
/**
 停止
 */
- (void) stop;
/**
 下一个
 */
- (void) next;
/**
 上一个
 */
- (void) previous;
/**
 遥控事件
 */
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent;
/**
 文件信息
 */
+(NSDictionary*) getAudioInfoByUrl:(NSURL*) url;
@end
