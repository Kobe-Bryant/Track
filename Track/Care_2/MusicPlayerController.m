//
//  MusicPlayerController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-30.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MusicPlayerController.h"

#define _PlayDuration 30

@implementation MusicPlayerController

static MusicPlayerController *_instance = nil;

+(MusicPlayerController *)Instance
{
    static MusicPlayerController *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[MusicPlayerController alloc] init];
        }
        return _instance;
    }
    return nil;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        mpc = [MPMusicPlayerController applicationMusicPlayer];
    }
    return self;
}

-(void)setQueueWithItemCollection:(MPMediaItemCollection *)itemCollection {
    
    [mpc setQueueWithItemCollection:itemCollection];
}

-(void)playWithMusicItem:(NSObject *)item isStop:(BOOL)isStop {
    
    NSLog(@"item=%@",item);
    if (item==nil || item==NULL) {
        NSLog(@"未找到音乐。。。。。");
        return;
    }

    
//    [self stop];
    
    if ([item isKindOfClass:[MPMediaItem class]]) {

        NSLog(@"play phone music");
//        [mpc setNowPlayingItem:(MPMediaItem *)item];
//        [mpc play];
        
        avAudioPlayer = nil;
        avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:((MPMediaItem *)item).assetURL error:nil];
        [avAudioPlayer play];
        
    } else if ([item isKindOfClass:[NSDictionary class]]){
        
        NSLog(@"play APP music");
        avAudioPlayer = nil;
        NSString *mp3Path = ((NSDictionary *)item)[@"mp3Path"];
        NSLog(@"mp3Path =%@", mp3Path);
        if (mp3Path && ![mp3Path isEqualToString:@""]) {
            NSURL *url = [NSURL URLWithString:mp3Path];
            avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            NSLog(@"url =%@, avAudioPlayer =%@", url, avAudioPlayer);
            [avAudioPlayer play];
        }
    }
    
    if (isStop) {
        [self performSelector:@selector(stop) withObject:nil afterDelay:_PlayDuration];
    }
    
}
-(void)play {
    
}

-(void)stop {
    [mpc stop];
    [avAudioPlayer stop];
}
@end
