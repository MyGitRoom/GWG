//
//  SettingViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "SettingViewController.h"
#import "SDImageCache.h"
#import "LazyFadeInView.h"
@interface SettingViewController ()


@property (nonatomic ,strong) UIButton *btn ; //清楚缓存按钮
@property (nonatomic ,strong) UIImageView *imageV ; //背景视图

@property (nonatomic ,strong) UIBlurEffect *blur ; //毛玻璃模糊层
@property (nonatomic ,strong) UIVisualEffectView *Visual ;//毛玻璃视图

@property (nonatomic ,strong) LazyFadeInView *lazyView ; //文字渐变视图

@property (nonatomic ,assign) float tmpSize ;//计算缓存的大小
@property (nonatomic ,strong)UIAlertController *alert ;//提示框

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    self.navigationController.navigationBarHidden = NO ;
    
    //判断缓存为0时,将毛玻璃效果的透明度变0
    if (self.tmpSize == 0) {
        self.Visual.alpha = 0 ;

    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
//  NSLog(@"-->%@",NSHomeDirectory());
    
    [self createReturnBtn];

    [self createVisual];
    
    [self createClearCacheBtn] ;
    
    

}

#pragma mark - 创建返回键
-(void)createReturnBtn {
   
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];


}

#pragma mark - 导航栏返回方法
- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建毛玻璃效果
-(void)createVisual{

    //    计算缓存大小
    self.tmpSize =  [[SDImageCache sharedImageCache] checkTmpSize] ;
    
    NSString *clearCacheName = self.tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",self.tmpSize] : [NSString stringWithFormat:@"%.2fK",self.tmpSize * 1024];
    NSString *str  = [NSString stringWithFormat:@"你面前的世界出现%@缓存,不清理一下,你怎能将美景尽收眼底.",clearCacheName];

    //   创建文字渐变视图
    self.lazyView = [[LazyFadeInView alloc]initWithFrame:CGRectMake(35, 150,  80, KScreenHeight-150)];
    self.lazyView.text = str;

    
    
    //毛玻璃效果
    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    self.Visual = [[UIVisualEffectView alloc]initWithEffect:self.blur];
    self.Visual.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.Visual.alpha = 0.9 ;
    
    //背景图片
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.imageV.image = [UIImage imageNamed:@"settingBg.jpg"];
    
    
    
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.Visual];
    [self.Visual addSubview:self.lazyView];
    
}


#pragma mark - 创建清楚缓存按钮

-(void)createClearCacheBtn{
 
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 0, 80, 30) ;
    self.btn.titleLabel.font = [UIFont systemFontOfSize:8];
    [self.btn setTitle:@"清除缓存" forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"cache_trash"] forState:
     UIControlStateNormal];
    [self.btn setImageEdgeInsets:UIEdgeInsetsMake(-15, 43, 0, 0)];
    [self.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -30, -18)];
    
    [self.btn addTarget:self action:@selector(clearCaches) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
   
    [self.view addSubview:self.btn];

}

-(void)clearCaches{


    if (self.tmpSize!=0.0) {
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            NSLog(@"缓存清除完毕");
            [UIView animateWithDuration:2 animations:^{
                //            self.view.backgroundColor = [UIColor lightGrayColor];
                self.Visual.alpha = 0 ;
            }];
        }];
        
    }else{
        self.Visual.alpha = 0 ;
        self.alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"缓存已清空" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:self.alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    }
    
    
   

}

//取消警告提示
-(void)dismiss{
  
    [self dismissViewControllerAnimated:self.alert completion:nil];
    
}
@end
