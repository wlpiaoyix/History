//
//  SimpleAVAudioPlayer.m
//  Audio
//
//  Created by wlpiaoyi on 14-10-9.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SimpleAVAudioPlayer.h"
#import "GraphicsContext.h"
#import "SynOperate.h"

//默认声音大小
float DEFAULT_VOLUME = 0.4f;
//默认循环次数
unsigned int DEFAULT_NUMBEROFLOOPS = 0;
//默认进度
float DEFAULT_PROGRESS = -1;

@interface SimpleAVAudioPlayer(){
@private id synplay;
    bool flagplay;
    NSTimeInterval timeclick;
    
    id synclick;
    bool flagclick;
}
@end
@implementation SimpleAVAudioPlayer
-(id) init{
    if (self=[super init]) {
        synplay = [NSObject new];
        synclick = [NSObject new];
        _arrayAudiosURL = [NSMutableArray new];
        //==>可以后台播放
        /*在info.plist里面添加
        <key>Required background modes</key>
        <array>
        <string>App plays audio</string>
        </array>
        即可。*/
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        //<==
        //注册远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}
-(void) addAudioUrl:(NSURL*) url{
    [self.arrayAudiosURL addObject:url];
}
-(void) addAudioName:(NSString*) name ofType:(NSString*) ext{
    NSString *stringPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSURL *url = [NSURL fileURLWithPath:stringPath];
    [self addAudioUrl:url];
}
-(void) play{
    [self playProgress:DEFAULT_PROGRESS];
}
-(void) playProgress:(float) progress{
    if (!self.player) {
        _indexPlay = MIN(_indexPlay, (unsigned int)([_arrayAudiosURL count]-1));
        _indexPlay = MAX(_indexPlay, 0);
        NSURL *url = [_arrayAudiosURL objectAtIndex:_indexPlay];
        if (url) {
            _audioInfo = [SimpleAVAudioPlayer getAudioInfoByUrl:url];
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            _player.volume = DEFAULT_VOLUME; //0.0-1.0之间
            _player.numberOfLoops = DEFAULT_NUMBEROFLOOPS;//循环播放次数
        }
    }
    if (!_player) {
        return;
    }
    NSTimeInterval duration = _player.duration*(_player.numberOfLoops+1);//获取采样的持续时间
    if (progress>=0.0f) {
        progress = MIN(progress, 1);
        progress = MAX(progress, 0);
        _player.currentTime = duration*progress;//播放位置
    }
    _player.delegate = self;
    [_player prepareToPlay];
    
    if (!self.player.isPlaying) {
        [self.player play];
        [self showPowerForChannel];
        [self configNowPlayingInfoCenter:nil];
        return;
    }
}
-(void) pause{
    flagplay = false;
    if (self.player) {
        [self.player pause];
    }
}
-(void) stop{
    flagplay = false;
    if (self.player) {
        [self.player stop];
        _player = nil;
    }
}
-(void) next{
    flagplay = false;
    [self stop];
    _indexPlay ++;
    if (_indexPlay<[self.arrayAudiosURL count]) {
        [self play];
    }
}
-(void) previous{
    flagplay = false;
    [self stop];
    if (!_indexPlay) {
        return;
    }
    _indexPlay --;
    [self play];
}
-(void) showPowerForChannel{
    flagplay = false;
    SynOperate *so = [SynOperate initWIthCallBack:^(SynOperate *so) {
        [_player updateMeters];//更新仪表读数
        @synchronized(synplay){
            while (flagplay) {
                [_player updateMeters];//更新仪表读数
                for(int i = 0; i<_player.numberOfChannels;i++){
//                    float power = [_player averagePowerForChannel:i];
//                    float peak = [_player peakPowerForChannel:i];
                }
                [NSThread sleepForTimeInterval:0.2f];
            }
        }
    } CallBackStart:^(SynOperate *so) {
        _player.meteringEnabled = YES;//开启仪表计数功能
    } CallBackEnd:^(SynOperate *so) {
        _player.meteringEnabled = NO;
    }];
    @synchronized(synplay){
        flagplay = true;
    }
    [so start];
}
+(NSDictionary*) getAudioInfoByUrl:(NSURL*) url{
    NSMutableDictionary *audioInfo = [NSMutableDictionary new];
    AudioFileID fileID = nil;
    OSStatus err = noErr;
    AudioFileOpenURL((__bridge CFURLRef) url, kAudioFileReadPermission, 0, &fileID);
    if( err != noErr ) {
        NSLog( @"AudioFileOpenURL failed" );
    }
    UInt32 id3DataSize = 0;
    err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL );
    
    if( err != noErr ) {
        NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );
    }
    UInt32 piDataSize = sizeof( audioInfo );
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &audioInfo );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary" );
    }
    CFDataRef albumPic= nil;
    UInt32 picDataSize = sizeof(picDataSize);
    err = AudioFileGetProperty(fileID, kAudioFilePropertyAlbumArtwork, &picDataSize, &albumPic);
    if( err != noErr ) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
        NSLog(@"Error: %@", [error description]);
    }else{
        [audioInfo setObject:[UIImage imageWithData:(__bridge NSData *)(albumPic)] forKey:MPMediaItemPropertyArtwork];
    }
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            //artwork这个key对应的value里面存的就是封面缩略图，其它key可以取出其它摘要信息，例如title - 标题
            if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyTitle]) { //歌曲名称
                NSString *title  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:title]) {
                    [audioInfo setObject:title forKey:MPMediaItemPropertyTitle];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyArtist]) {//演唱者
                NSString *artist  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:artist]) {
                    [audioInfo setObject:artist forKey:MPMediaItemPropertyArtist];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyAlbumTitle]) {//专辑名
                NSString *albumName  = (NSString*)metadataItem.value;
                if ([NSString isEnabled:albumName]) {
                    [audioInfo setObject:albumName forKey:MPMediaItemPropertyAlbumTitle];
                }
            }else if ([metadataItem.commonKey isEqualToString:MPMediaItemPropertyArtwork]) {//图片
                NSDictionary *artword = (NSDictionary*)metadataItem.value;
                NSData *data = [artword objectForKey:@"data"];
                [audioInfo setObject:[UIImage imageWithData:data] forKey:MPMediaItemPropertyArtwork];
            }
        }
    }
    return audioInfo;
}

#pragma start delegate AVAudioPlayerDelegate ==>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    _player = nil;
    [self next];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    flagplay = false;
    _player = nil;
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
    flagplay = false;
    _player = nil;
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
    flagplay = false;
    _player = nil;
}
#pragma end delegate AVAudioPlayerDelegate <==

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:{
                [self play];
            }
                break;
                
            case UIEventSubtypeRemoteControlPause:{
                [self pause];
            }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:{
                [self next];
//                dispatch_queue_t syn_queue;
//                NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
//                if (t-timeclick<0.4f) {
//                    @synchronized(synclick){
//                        float p = MIN(self.player.currentTime/_player.duration+0.05, 1);
//                        self.player.currentTime = p*self.player.duration;//播放位置
//                        flagclick = YES;
//                    }
//                }else{
//                    syn_queue = dispatch_queue_create("com.wlpiaoyi.syn.synchronize",nil);
//                    dispatch_async(syn_queue, ^{
//                        [NSThread sleepForTimeInterval:0.5f];
//                        @synchronized(synclick){
//                            if (!flagclick) {
//                                [self next];
//                            }
//                            flagclick = NO;
//                        }
//                    });
//                }
//                timeclick = t;
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:{
                [self previous];
//                dispatch_queue_t syn_queue;
//                NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
//                if (t-timeclick<0.4f) {
//                    @synchronized(synclick){
//                        float p = MAX(self.player.currentTime/_player.duration-0.05, 0);
//                        self.player.currentTime = p*self.player.duration;//播放位置
//                        flagclick = YES;
//                    }
//                }else{
//                    syn_queue = dispatch_queue_create("com.wlpiaoyi.syn.synchronize",nil);
//                    dispatch_async(syn_queue, ^{
//                        [NSThread sleepForTimeInterval:0.5f];
//                        @synchronized(synclick){
//                            if (!flagclick) {
//                                [self previous];
//                            }
//                            flagclick = NO;
//                        }
//                    });
//                }
//                timeclick = t;
            }
                break;
                
            default:
                break;
        }
        [self configNowPlayingInfoCenter:nil];
    }
}

//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter:(NSDictionary*) _audioDic{
    NSDictionary *audioDic = _audioDic;
    if (!audioDic) {
        audioDic = _audioInfo;
    }
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSString *title = [audioDic objectForKey:MPMediaItemPropertyTitle];
        NSString *artist = [audioDic objectForKey:MPMediaItemPropertyArtist];
        NSString *album = [audioDic objectForKey:MPMediaItemPropertyAlbumTitle];
        UIImage *image = [audioDic objectForKey:MPMediaItemPropertyArtwork];
        if (![NSString isEnabled:title]) {
            NSURL *url = [self.arrayAudiosURL objectAtIndex:_indexPlay];
            title = [url.absoluteString componentsSeparatedByString:@"/"].lastObject;
        }
        if (![NSString isEnabled:artist]) {
            artist = @"no artist";
        }
        if (![NSString isEnabled:album]) {
            album = [audioDic objectForKey:@"album"];
        }
        if (![NSString isEnabled:album]) {
            album = @"no album";
        }
        if (!image) {
            CGRect rect = CGRectMake(0.0f, 0.0f, 600.0f, 600.0f);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.8 green:1 blue:0.9 alpha:0.9] CGColor]);
            CGContextFillRect(context, rect);
            UIFont *f = [UIFont systemFontOfSize:rect.size.width/10];
            NSString *msg = @"NO IMAGE";
            CGSize s = CGSizeMake(998, 999);
            s = [Common getBoundingRectWithSize:msg font:f size:s];
            s.width = 999;
            s = [Common getBoundingRectWithSize:msg font:f size:s];
            CGPoint p = CGPointMake((rect.size.width-s.width)/2, (rect.size.height-s.height)/2);
            [GraphicsContext drawText:context Text:msg Font:f Point:p TextColor:[UIColor greenColor]];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名称
        [dict setObject:[title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:MPMediaItemPropertyTitle];
        
        //演唱者
        [dict setObject:artist forKey:MPMediaItemPropertyArtist];
        
        //专辑名
        [dict setObject:album forKey:MPMediaItemPropertyAlbumTitle];
        
        //专辑缩略图
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        //音乐剩余时长
        [dict setObject:[NSNumber numberWithDouble:self.player.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        //音乐当前播放时间 在计时器中修改
        [dict setObject:[NSNumber numberWithDouble:self.player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}
-(void) dealloc{
    flagplay = false;
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
@end
