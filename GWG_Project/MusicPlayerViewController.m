//
//  MusicPlayerViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController ()<GYPlayerDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray * settings;
@property (nonatomic, strong) UIImageView * albumView;
@property (nonatomic, strong) UIImageView * imageV;
/*
@property (nonatomic, strong) UISlider * musicProgress; //当前音乐播放进度条
@property (nonatomic, strong) UILabel * currentTimeLabel; //当前播放了多长时间
@property (nonatomic, strong) UILabel * remainTimeLabel; //还剩多长时间
*/
@end

@implementation MusicPlayerViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =NO;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
}
#pragma mark- 懒加载
- (NSMutableArray *) settings
{
    if (!_settings)
    {
        self.settings = [NSMutableArray array];
    }
    return _settings;
}

-(UIImageView *)albumView
{
    if (!_albumView)
    {
        self.albumView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 80, KScreenWidth-100, KScreenWidth-100)];
        //设置圆形的半径
        self.albumView.layer.cornerRadius = (KScreenWidth - 100)/2;
        self.albumView.layer.masksToBounds = YES;
        [self.scrollView addSubview:_albumView];
    }
    return _albumView;
}

/*
-(UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel)
    {
        self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTimeLabelMargin, kControlBarOriginY+20, kTimeLabelWidth, kTimeLabelHeight)];
        _currentTimeLabel.text =@"0:00";
        _currentTimeLabel.font = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_currentTimeLabel];
    }
    return _currentTimeLabel;
}

-(UILabel *)remainTimeLabel
{
    if (!_remainTimeLabel)
    {
        self.remainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth-kTimeLabelMargin-kTimeLabelWidth, kControlBarOriginY + 20, kTimeLabelWidth, kTimeLabelHeight)];
        _remainTimeLabel.font = [UIFont systemFontOfSize:14];
        _remainTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_remainTimeLabel];
    }
    return _remainTimeLabel;
}
*/

#pragma mark- 加载视图
- (void) loadView
{
    //创建背景视图并且设置毛玻璃效果
    self.imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _imageV;
    self.view.userInteractionEnabled = YES;
    //毛玻璃效果
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualView.frame = self.view.frame;
    [self.view addSubview:visualView];
    
    //创建切换的srcolView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kControlBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*2, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
//    UIImageView * imageV = [[UIImageView alloc]init];
//    imageV.frame = CGRectMake(0, kControlBarOriginY, KScreenWidth, kControlBarHeight);
//    imageV.image = [UIImage imageNamed:@"controlbar.jpg"];
//    [self.view addSubview:imageV];
    
    UIVisualEffectView * eView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    eView.frame = CGRectMake(0, kControlBarOriginY, KScreenWidth, kControlBarHeight);
    [self.view addSubview:eView];
    
//    NSLog(@"%@",self.detailMod.sound_url);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    self.currentIndex = self.detailMod.model_flag;
//    [self creatPopView];
    
    //初始化返回的按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(16, 24, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    backBtn.layer.cornerRadius = 10;
    backBtn.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(handleDismissAction:) forControlEvents:UIControlEventTouchDown];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 30, 30);
    [_btn addTarget:self action:@selector(PopViewToCollect:) forControlEvents:UIControlEventTouchDown];
    [_btn setImage:[UIImage imageNamed:@"orangeNotLike"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    
    //创建音乐播放的进度条
    /*
    self.musicProgress = [[UISlider alloc]initWithFrame:CGRectMake(0, kControlBarOriginY, KScreenWidth, 40)];
    
    self.musicProgress.minimumTrackTintColor=kHLColor(200, 150, 100);
    self.musicProgress.maximumTrackTintColor = [UIColor grayColor];
    
    [self.musicProgress setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x.png"] forState:UIControlStateNormal];
    [self.musicProgress addTarget:self action:@selector(handleProgressChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.musicProgress];
     */
    
    [self setControlButton];
    [self setNameAndAlbumLabel];
    [self creatDataBank];
    
    
    
    //添加一个观察者，观察我们的应用程序有没有计入后台，一旦进入后台系统就会自动给我们发送一个通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadVolume) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [self firstReloadMusic];
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
//滑动音乐进度条执行的方法
-(void)handleProgressChangeAction:(UISlider *)sender
{
    [[GYPlayer sharedplayer] seekToTime:sender.value];
}

#pragma mark- 处理时间格式的方法
-(NSString *)timeWithInterVal:(float)interVal
{
    int minute = interVal / 60;
    int second = (int)interVal % 60;
    return [NSString stringWithFormat:@"%d:%02d",minute,second];
}
 */

//点击返回按钮时执行的方法
-(void)handleDismissAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNameAndAlbumLabel
{
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    button.frame = CGRectMake(0, 0, 20, 20);
//    button.center = CGPointMake(KScreenWidth/1.1, kControlBarCenterY-50);
//    UIImage * image = [UIImage imageNamed:@"down"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [button setImage:image forState:UIControlStateNormal];
//    [self.view addSubview:button];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.tag = 20086;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.center = CGPointMake(KScreenWidth/2, kControlBarCenterY-120);
    nameLabel.text = self.detailMod.title;
    [self.view addSubview:nameLabel];
    
    UILabel *albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    albumLabel.center = CGPointMake(KScreenWidth/2, kControlBarCenterY-70);
    albumLabel.tag = 20010;
    albumLabel.font = [UIFont systemFontOfSize:15];
    albumLabel.textAlignment = NSTextAlignmentCenter;
    
    albumLabel.text = [self.detailMod.user objectForKey:@"nick"];
    [self.view addSubview:albumLabel];
}

#pragma mark-创建暂停播放等按钮的
-(void)setControlButton
{
    //创建播放按钮
    UIButton *playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    playPauseButton.frame = CGRectMake(0, 0, 30, 30);
    playPauseButton.center = CGPointMake(kControlBarCenterX, kControlBarCenterY);
    
    [playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [playPauseButton setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    [playPauseButton addTarget:self action:@selector(handlePlayPauseAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playPauseButton];
    
    //创建上一首的按钮
    UIButton *rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rewindButton.frame = CGRectMake(0, 0, 30, 30);
    rewindButton.center = CGPointMake(kControlBarCenterX-kButtonOffSetX, kControlBarCenterY);
    [rewindButton setImage:[UIImage imageNamed:@"rewind.png"] forState:UIControlStateNormal];
    [rewindButton setImage:[UIImage imageNamed:@"rewind_h.png"] forState:UIControlStateHighlighted];
    [rewindButton addTarget:self action:@selector(handleRewindAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rewindButton];
    
    //创建下一首音乐的按钮
    UIButton *forwordButton =[UIButton buttonWithType:UIButtonTypeCustom];
    forwordButton.frame = CGRectMake(0, 0, 30, 30);
    forwordButton.center = CGPointMake(kControlBarCenterX+kButtonOffSetX, kControlBarCenterY);
    [forwordButton setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [forwordButton setImage:[UIImage imageNamed:@"forward_h.png"] forState:UIControlStateHighlighted];
    [forwordButton addTarget:self action:@selector(handleForwordAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:forwordButton];
    
}

#pragma mark-播放器的协议方法(0.1s就会调用一次)
-(void)audioPlayer:(GYPlayer *)player didPlayingWithProgress:(float)progress
{
    /*
    //主要处理播放过程中需要持续性改变的都写在这里面，因为这个方法，会每隔0.1s就会被调用一次
    //设置音乐播放的进度条
    self.musicProgress.value = progress;
    //设置当前播放多少秒的label的值
    self.currentTimeLabel.text = [self timeWithInterVal:self.musicProgress.value];
    float remainTime = self.musicProgress.maximumValue - self.musicProgress.value;
    self.remainTimeLabel.text = [self timeWithInterVal:remainTime];
     */
    //让图片进行旋转
    self.albumView.transform = CGAffineTransformRotate(self.albumView.transform, M_PI/360);
}

//点击下一首执行的方法
-(void)handleForwordAction:(UIButton *)sender
{
    self.currentIndex++;
    GYPlayer *player = [GYPlayer sharedplayer];
    [player stop];
    //切换音乐
    [self reloadMusic];
    
}

//播放完成后执行的方法
-(void)audioPlayerDidFinishPlaying:(GYPlayer *)player
{
    [self handleForwordAction:nil];
}

//点击上一首按钮执行的方法
-(void)handleRewindAction:(UIButton *)sender
{
    self.currentIndex--;
    if (self.currentIndex == -1)
    {
        self.currentIndex = 0;
    }
    
//    NSLog(@"%ld",self.currentIndex);
    [self reloadMusic];
}

//每次切换歌曲的时候把页面的元素全部换成该歌曲的内容
-(void)reloadMusic
{
    DataDetailModel * model = [self.passDataArray objectAtIndex:self.currentIndex];
    //改变旋转大图的背景
    [self.albumView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    /*
    self.musicProgress.maximumValue = model.sound_url.floatValue/1000;
    //设置一个已经播放了多久的时间
    self.currentTimeLabel.text = @"0:00";
    //剩余时间的label
    self.remainTimeLabel.text = [self timeWithInterVal:self.musicProgress.maximumValue];
     */
    //更新title和电台
    [(UILabel *)[self.view viewWithTag:20086] setText:model.title];
    [(UILabel*)[self.view viewWithTag:20010] setText:[model.user objectForKey:@"nick"]];
    //保证每次切换新歌的时候旋转的图片都从正上方看是旋转
    self.albumView.transform  = CGAffineTransformMakeRotation(0);
    //更换音乐播放器，让音乐播放器，播放当前的音乐
    GYPlayer *player = [GYPlayer sharedplayer];
    player.delegate = self;
    [player pause];
    [player setPlayerWithUrl:model.sound_url];
    [player play];
}

- (void) firstReloadMusic
{
    [_imageV sd_setImageWithURL:[NSURL URLWithString:self.detailMod.cover_url]];
    //改变旋转大图的背景
    [self.albumView sd_setImageWithURL:[NSURL URLWithString:self.detailMod.cover_url]];
    //更新歌名和专辑名字
    [(UILabel *)[self.view viewWithTag:20086] setText:self.detailMod.title];
    [(UILabel*)[self.view viewWithTag:20010] setText:[self.detailMod.user objectForKey:@"nick"]];
    //保证每次切换新歌的时候旋转的图片都从正上方看是旋转
    self.albumView.transform  = CGAffineTransformMakeRotation(0);
    GYPlayer *player = [GYPlayer sharedplayer];
    
    player.delegate = self;
    [player pause];
    [player setPlayerWithUrl:self.detailMod.sound_url];
    [player play];
}

//点击播放按钮时执行的方法
-(void)handlePlayPauseAction:(UIButton *)sender
{
    GYPlayer *player = [GYPlayer sharedplayer];
    if ([player isPlaying])
    {
        [player pause];
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"play_h.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [player play];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    }
}

#pragma  -mark  数据库的建立
-(void)creatDataBank
{
//    NSLog(@"%@",NSHomeDirectory());
    BOOL result = [[DataBaseUtil shareDataBase]createDataDetailModelTable];
    if (result) {
        NSLog(@"建立电台列表成功");
    }
    NSArray * array = [[DataBaseUtil shareDataBase]selectRadioTable];
    DataDetailModel * de  =[[DataDetailModel alloc]init];
    //    NSLog(@"%@",array);
    for (de in array) {
        if ([de.title isEqualToString:_detailMod.title]) {
            _btn.selected = YES;
        }
    }
    //    NSLog(@"%d",_btn.selected);
    
    
}

- (void) PopViewToCollect:(UIButton *)btn
{
    
    if (_btn.selected == NO) {
        [[DataBaseUtil shareDataBase]insertObjectOfRadio:_detailMod];
        _btn.selected = YES;
        [self popToPrompt:@"收藏成功"];
        
        
    }else
    {
        [[DataBaseUtil shareDataBase]deleteRadioWithName:_detailMod.title];
        [self popToPrompt:@"取消收藏"];
        _btn.selected = NO;
        
    }
}
#pragma -mark 弹出提示框
-(void)popToPrompt:(NSString*)str
{
    UIAlertController * alertController =  [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DismissTheAlert) userInfo:nil repeats:NO];
    
}

-(void)DismissTheAlert
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
