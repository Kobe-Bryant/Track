//
//  MusicPlayerController.h
//  Q2_local
//
//  Created by Vecklink on 14-7-30.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerController : NSObject {
    MPMusicPlayerController *mpc;   //手机音乐播放器
    AVAudioPlayer *avAudioPlayer;   //app本地音乐播放器
}

+(MusicPlayerController *)Instance;

//设置mpc播放列表
-(void)setQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;

-(void)playWithMusicItem:(NSObject *)item isStop:(BOOL)isStop;
-(void)stop;

@end
