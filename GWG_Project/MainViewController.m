
//
//  MainViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MainViewController.h"
#import "DBSphereView.h"
#import "ReadingViewController.h"
#import "TechnologyViewController.h"
#import "RadioViewController.h"
#import "MovieViewController.h"
#import "UIImageView+WebCache.h"
#import "LazyFadeInView.h"
#import "UNCView.h"
#import "CollectionSelectViewController.h"
#import "SettingViewController.h"
#import "MyViewController.h"

#define DAILYURL @"http://dict-mobile.iciba.com/interface/index.php?c=sentence&m=getsentence&client=1&type=1&field=1,2,3,4,5,6,7,8,9,10,11,12,13&timestamp=1434767570&sign=6124a62ff73a033a&uuid=3dd23ff24ea543c1bdca57073d0540e1&uid="
@interface MainViewController ()<btnjump>
{
    BOOL  Flag;//监听按钮是否创建
}
@property (nonatomic ,strong)DBSphereView *sphereView ;
@property (nonatomic ,strong)UIImageView *imagev ;
@property (nonatomic ,assign) NSInteger i ;

@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UIView * vi;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) NSMutableArray * msgArray;
@property (nonatomic, strong) NSString * tagMP3; //音频的URL
@property (nonatomic, strong) UIButton * mainBtn;
@property (nonatomic ,strong) NSTimer *Scaletimer ;//创建一个定时器控制按钮动画
@property (nonatomic,strong)UNCView *uncView;
//三个按钮控制跳转控制器；
@property(nonatomic,strong)UIButton * collectionBtn;
@property(nonatomic,strong)UIButton * setBtn;
@property(nonatomic,strong)UIButton * myBtn;
//两个渐变字效果
@property (nonatomic,strong) LazyFadeInView * fade;
@property (nonatomic,strong) LazyFadeInView * fadeC;


@end

@implementation MainViewController

#pragma mark- 懒加载
- (NSMutableArray *) msgArray
{
    if (!_msgArray)
    {
        self.msgArray = [NSMutableArray array];
    }
    return _msgArray;
}

- (AVPlayer *) player
{
    if (!_player)
    {
        self.player = [[AVPlayer alloc]init];
    }
    return _player;
}


#pragma mark- 隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES ;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    Message * ms = [_msgArray lastObject];
    //英文
    _fade = [[LazyFadeInView alloc]initWithFrame:CGRectMake(130, 430,  250, 100)];
    _fade.text = ms.content;
    [_imagev addSubview:_fade];
    //汉子
    _fadeC = [[LazyFadeInView alloc]initWithFrame:CGRectMake(10, 80,  250, 100)];
    _fadeC.text = ms.note;
    [_imagev addSubview:_fadeC];
}


#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    Flag = NO;//记录是否出现
    self.imagev = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.i = 1 ;
    self.imagev.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:self.imagev];
    //创建标签云
    [self createCloudTag] ;
    //加载数据
    [self requestData];
    //创建右上角按钮
    [self creatRunningBtn];
}


#pragma mark- 创建云标签
-(void)createCloudTag{
    self.sphereView = [[DBSphereView alloc]initWithFrame:CGRectMake(50, KScreenHeight-64-49-20, 100, 100)];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    NSArray *titleArr = [NSArray arrayWithObjects:@"Movie",@"Reading",@"Radio",@"Science", nil];
    for (NSInteger i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //根据tag标记进行跳转到那个页面
        btn.tag = i ;
        btn.frame = CGRectMake(0, 0, 120, 20);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        btn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:22];
        
        [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    
    [self.sphereView setCloudTags:array];
    [self.view addSubview:self.sphereView];
}



#pragma mark- 点击标签云按钮执行的方法
-(void)jump:(UIButton *)btn {
    //点击按钮定时器停止
    [self.sphereView timerStop];
    [_fade removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
        
    }];
    
    if(btn.tag == 0){
        MovieViewController *movieVc = [[MovieViewController alloc]init];
        [self.navigationController pushViewController:movieVc animated:YES];
    }else if (btn.tag ==1){
        ReadingViewController *readingVc = [[ReadingViewController alloc]init];
        [self.navigationController pushViewController:readingVc animated:YES];
    }else if (btn.tag == 2){
        RadioViewController *radioVc = [[RadioViewController alloc]init];
        [self.navigationController pushViewController:radioVc animated:YES];
    }else{
        TechnologyViewController *technoloVc =[[TechnologyViewController alloc]init];
        [self.navigationController pushViewController:technoloVc animated:YES];
    }
}
#pragma mark- 切换图片的方法
-(void)changePic{
    if (_i==5) {
        //    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
        //    if (_i==4) {
        _i=1;
    }
    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
    _i++ ;
}

#pragma mark- 请求数据
- (void) requestData
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * string = [formatter stringFromDate:date];
    [NetWorlRequestManager requestWithType:GET urlString:[DAILYURL stringByAppendingString:string] ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        //        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDic = [dic objectForKey:@"message"];
        //        NSLog(@"%@",dic);
        Message * msg = [[Message alloc]init];
        msg.content = [dataDic objectForKey:@"content"];
        msg.love = [dataDic objectForKey:@"love"];
        msg.note = [dataDic objectForKey:@"note"];
        msg.picture = [dataDic objectForKey:@"picture"];
        msg.title = [dataDic objectForKey:@"title"];
        msg.translation = [dataDic objectForKey:@"translation"];
        msg.tts = [dataDic objectForKey:@"tts"];
        [self.msgArray addObject:msg];
        //        NSLog(@"%@",[_msgArray objectAtIndex:0]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self loadTodayView];
            [self createControls];
            [self viewDidAppear:YES];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
}



#pragma mark- 添加视图
//创建视图上控件
- (void) createControls
{
    
    //取数据
    Message * msg = [self.msgArray lastObject];
    self.tagMP3 = msg.tts;
    //日期Label
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.vi.frame.size.width, 40)];
    dateLabel.text = msg.title;
    [self.vi addSubview:dateLabel];
    
    //图片
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, 230)];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:msg.picture]];
    _imageV.layer.cornerRadius = 3;
    _imageV.layer.shadowColor = [UIColor whiteColor].CGColor;
    _imageV.layer.shadowOffset = CGSizeMake(0,0);
    _imageV.layer.shadowOpacity = 1;
    _imageV.layer.shadowRadius = 5.0;//给imageview添加阴影和边框
    [self.imagev addSubview:self.imageV];
    
    //播放音频按钮
    self.mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mainBtn setImage:[UIImage imageNamed:@"listenToWords"] forState:UIControlStateNormal];
    _mainBtn.frame = CGRectMake(KScreenWidth-35,153,30,30);
    [_mainBtn addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventTouchUpInside];
    [_mainBtn setAlpha:0.5];
    [self.uncView addSubview:_mainBtn];
    
}


#pragma -mark 点击播放按钮
- (void) touchChange:(UIButton *)btn
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.tagMP3]];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.player play];
    //添加监听事件,监测音频是否播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    /*
     
     //    CMTime duration = playerItem.duration;
     //    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
     //
     //    _dSeconds = floor(dTotalSeconds % 3600 % 60);
     //     NSLog(@"%lu",(unsigned long)_dSeconds);
     
     ////
     //    NSLog(@"%lld",duration.value);
     //    NSLog(@"%d",duration.timescale);
     //    _dSeconds = self.player.currentTime.value /self.player.currentTime.timescale ;
     
     
     
     //    NSUInteger dHours = floor(dTotalSeconds / 3600);
     //    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
     //    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes,dSeconds];
     NSLog(@"%lu",(unsigned long)_dSeconds);
     
     
     //    [UIView animateWithDuration:1 animations:^{
     //        btn.layer.transform = CATransform3DMakeScale(1.2,1.2, 1);
     //    }];
     */
    btn.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.Scaletimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(AnimationScale) userInfo:nil repeats:YES];
}

#pragma mark--播放完成调用该方法
-(void)handleEndTimeNotification:(NSNotification *)sender
{
    //播放结束,释放定时器
    [self.Scaletimer invalidate];
}


#pragma  mark -Listen me 按钮的动画效果
-(void)AnimationScale{
    [UIView animateWithDuration:1 animations:^{
        _mainBtn.layer.transform = CATransform3DMakeScale(1.1,1.1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _mainBtn.layer.transform = CATransform3DMakeScale(1,1, 1);
        }];
    }];
}
#pragma -mark 建立设置按钮
-(void)creatRunningBtn
{
    _uncView = [[UNCView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    [self.view addSubview:_uncView];
    
    _uncView.bgColor = [UIColor clearColor];
    _uncView.custViewColor = [UIColor whiteColor];
    _uncView.uncBtnColor = [UIColor colorWithWhite:0.6 alpha:0.3];
    _uncView.btnjumpdelegate =self;
    
}
#pragma -mark 监听右上角按钮的方法
-(void)settingbtn
{
    if (Flag ==  NO) {
        Flag = YES;
        [self creatThirdBtn];
    }else
    {
        [_collectionBtn removeFromSuperview];
        [_setBtn removeFromSuperview];
        [_myBtn removeFromSuperview];
        Flag = NO;
    }
}
-(void)creatThirdBtn
{
    _collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/9*5   , KScreenHeight/20 , 43, 43)];
    _setBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/10*6.4, KScreenHeight/8, 43, 43)];
    _myBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/10*7.7, KScreenHeight/5.8, 43, 43)];
    //    _collectionBtn.backgroundColor = [UIColor lightGrayColor];
    //    _setBtn.backgroundColor = [UIColor darkGrayColor];
    //    _myBtn.backgroundColor = [UIColor cyanColor];
    
    [_collectionBtn addTarget:self action:@selector(jumpToCollection) forControlEvents:UIControlEventTouchDown];
    [_setBtn addTarget:self action:@selector(jumpToSet) forControlEvents:UIControlEventTouchDown];
    [_myBtn addTarget:self action:@selector(jumpToMy) forControlEvents:UIControlEventTouchDown];
    
    
    [_uncView addSubview:_collectionBtn];
    [_uncView addSubview:_setBtn];
    [_uncView addSubview:_myBtn];
    
}


#pragma  -mark 跳转到三个页面
-(void)jumpToCollection{
    
    CollectionSelectViewController * collectiong = [[CollectionSelectViewController alloc]init];
    [self.navigationController pushViewController:collectiong animated:YES];
    
}
-(void)jumpToSet{
    
    SettingViewController * setting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}
-(void)jumpToMy{
    
    MyViewController * my = [[MyViewController alloc]init];
    [self.navigationController pushViewController:my animated:YES];
    
    
}

 


@end
