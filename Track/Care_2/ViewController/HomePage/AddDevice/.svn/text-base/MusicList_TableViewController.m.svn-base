//
//  MusicList_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-30.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MusicList_TableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface musicModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSURL *url;

@end

@implementation musicModel

@end


@interface MusicList_TableViewController () {
    UITableView *_tableView;
    NSMutableArray *items;
    
    UILabel *msgLabel;
    
    int selectIndex;
    
    AVAudioPlayer *avAudioPlayer;
}

@end

@implementation MusicList_TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"选择铃声", nil);
    [self setBackButton];
    [self setSubmitButton];
    _tableView = (UITableView *)self.view;
    _tableView.backgroundColor = _Color_background;
    
    items = [NSMutableArray array];
    selectIndex = -1;
    [self initMusicItems];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[MusicPlayerController Instance] stop];
    
    //设置播放列表
    NSMutableArray *devItems = [NSMutableArray array];
    for (DeviceModel *devObj in [UserData Instance].deviceDic.allValues) {
        if (devObj.musicItem) {
            [devItems addObject:devObj.musicItem];
        }
    }
    if (devItems.count) {
        MPMediaItemCollection *mic = [[MPMediaItemCollection alloc] initWithItems:devItems];
        [[MusicPlayerController Instance] setQueueWithItemCollection:mic];
    }
}

_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), @selector(onSubmitButtonPressed), _StringWidth(NSLocalizedString(@"保存", nil)))

-(void)onSubmitButtonPressed {
    if (selectIndex < 0) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有选择铃声", nil)];
        [alertView show];
        return;
    }
    
    self.dev.musicItem = items[selectIndex];
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存成功", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}

#pragma mark - Private Method
-(void)initMusicItems{
//    musicModel *model1 = [[musicModel alloc] init];
//    model1.name = @"music1";
//    model1.url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"]];
//    [items addObject:model1];
//    
//    
//    musicModel *model2 = [[musicModel alloc] init];
//    model2.name = @"music2";
//    model2.url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"music2" ofType:@"mp3"]];
//    [items addObject:model2];
//    
//    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
//    NSArray *itemsFromGenericQuery = [everything items];
//    for (MPMediaItem *song in itemsFromGenericQuery) {
//        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//        musicModel *model = [[musicModel alloc] init];
//        model.name = songTitle;
//        model.url = song.assetURL;
//        [items addObject:model];
//    }

    
    
    NSString *mp3Path;
    mp3Path = [[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"music1", @"title", mp3Path, @"mp3Path", nil]];
    mp3Path = [[NSBundle mainBundle] pathForResource:@"music2" ofType:@"mp3"];
    [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"music2", @"title", mp3Path, @"mp3Path", nil]];
    

    
    //获得query，用于请求本地歌曲集合
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    //循环获取得到query获得的集合
    for (MPMediaItemCollection *conllection in query.collections) {
        //MPMediaItem为歌曲项，包含歌曲信息
        for (MPMediaItem *item in conllection.items) {
            [items addObject:item];
        }
    }
    
    
    if (items.count) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //通过歌曲items数组创建一个collection
        MPMediaItemCollection *mic = [[MPMediaItemCollection alloc] initWithItems:items];
        //设置播放的集合
        [[MusicPlayerController Instance] setQueueWithItemCollection:mic];
    } else {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (!msgLabel) {
            msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 150)];
            msgLabel.numberOfLines = 0;
            msgLabel.text = NSLocalizedString(NSLocalizedString(@"没有找到音乐", nil), nil);
            msgLabel.textColor = [UIColor grayColor];
            msgLabel.font = [UIFont systemFontOfSize:15];
            msgLabel.textAlignment = NSTextAlignmentCenter;
            [_tableView addSubview:msgLabel];
        }
    }
    msgLabel.hidden = (items.count ? YES:NO);
     
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MusicCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = _Color_background;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    }
    
//    musicModel *model = items[indexPath.row];
//    cell.textLabel.text = model.name;
    
    NSObject *item = items[indexPath.row];
    if ([item isKindOfClass:[MPMediaItem class]]) {
        cell.textLabel.text = [(MPMediaItem *)item valueForProperty:MPMediaItemPropertyTitle];         //歌曲名称
        cell.detailTextLabel.text = [(MPMediaItem *)item valueForProperty:MPMediaItemPropertyArtist];  //歌手名称
    } else if ([item isKindOfClass:[NSDictionary class]]){
        cell.textLabel.text = ((NSDictionary *)item)[@"title"];
        cell.detailTextLabel.text = @"";
    }
    

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = (int)indexPath.row;
    //设置播放选中的歌曲;
//    musicModel *model = items[indexPath.row];
//    
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:model.name, @"title",[NSString stringWithContentsOfURL:model.url encoding:NSUTF8StringEncoding error:nil],@"mp3Path", nil];
//    [[MusicPlayerController Instance] playWithMusicItem:dic isStop:NO];
    
//    [[MusicPlayerController Instance] playWithMusicItem:items[indexPath.row] isStop:NO];
    
   //app本地音乐播放器
    

    
    if ([items[indexPath.row] isKindOfClass:[MPMediaItem class]]) {
        
//        [mpc setNowPlayingItem:(MPMediaItem *)items[indexPath.row]];
//        [mpc play];
        avAudioPlayer = nil;
        avAudioPlayer.numberOfLoops = -1;
        [avAudioPlayer prepareToPlay];
        
        avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:((MPMediaItem *)items[indexPath.row]).assetURL error:nil];
        [avAudioPlayer play];
        
    } else if ([items[indexPath.row] isKindOfClass:[NSDictionary class]]){
        
        avAudioPlayer = nil;
        NSString *mp3Path = ((NSDictionary *)items[indexPath.row])[@"mp3Path"];
        if (mp3Path && ![mp3Path isEqualToString:@""]) {
            NSURL *url = [NSURL URLWithString:mp3Path];
            avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [avAudioPlayer play];
        }
    }
}


@end
