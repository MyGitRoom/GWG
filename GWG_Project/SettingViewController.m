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


@property (nonatomic ,strong) UIButton *btn ;

@property (nonatomic ,strong) UIImageView *imageV ;

@property (nonatomic ,strong) UIBlurEffect *blur ;
@property (nonatomic ,strong) UIVisualEffectView *Visual ;

@property (nonatomic ,strong) LazyFadeInView *lazyView ;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    self.navigationController.navigationBarHidden = NO ;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.view.backgroundColor = [UIColor darkGrayColor];
    
//    NSLog(@"-->%@",NSHomeDirectory());
    
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
    
    self.lazyView = [[LazyFadeInView alloc]initWithFrame:CGRectMake(35, 150,  80, KScreenHeight-150)];
    
    NSString *string = @"你面前的世界出现雾霾,不清理一下,你怎能将美景尽收眼底.";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
//    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:15] range:NSMakeRange(0, string.length)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, string.length)];
    self.lazyView.text = [attribut string] ;
    
 
//    float f =  [[SDImageCache sharedImageCache] checkTmpSize] ;
//    NSLog(@"%f",f);
    
//    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth, KScreenHeight,64, 64)];
//    self.imageV.image = [UIImage imageNamed:@"plan"];
    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    self.Visual = [[UIVisualEffectView alloc]initWithEffect:self.blur];
    self.Visual.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.Visual.alpha = 0.9 ;
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.imageV.image = [UIImage imageNamed:@"settingBg.jpg"];
    
    
    
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.Visual];
    [self.Visual addSubview:self.lazyView];

     [self.view addSubview:self.btn];
}



-(void)clearCaches{

/*
//    [UIView animateWithDuration:3 animations:^{
    
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable() ;
        //指定self.vi 的中心为起点
        //        CGPathMoveToPoint(path, NULL,self.vi.frame.origin.x, self.vi.frame.origin.y);
        CGPathMoveToPoint(path, NULL,self.imageV.frame.origin.x, self.imageV.frame.origin.y);
        //        CGPathMoveToPoint(path, NULL, KScreenWidth/2-KScreenWidth/1.3/2, KScreenHeight/2-KScreenHeight/1.3/2-40);
    CGPathAddLineToPoint(path, NULL, KScreenWidth/2, 0);
//    CGPathAddLineToPoint(path, NULL, KScreenWidth, 0);
//        CGPathAddLineToPoint(path, NULL, 30,30);
        //设置时间
        [keyAnimation setDuration:2];
        
        //设置path
        [keyAnimation setPath:path];
        
        //设置动画执行完毕后，不删除动画
//        keyAnimation.removedOnCompletion=NO;
        //设置保存动画的最新状态
//        keyAnimation.fillMode=kCAFillModeForwards;
        
        [self.imageV.layer addAnimation:keyAnimation forKey:@"position"];
//    }];
    
 */
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        NSLog(@"缓存清除完毕");
        [UIView animateWithDuration:2 animations:^{
//            self.view.backgroundColor = [UIColor lightGrayColor];
            self.Visual.alpha = 0 ;
        }];
    }];
    
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    
    NSLog(@"%@",clearCacheName);
//    [configDataArray replaceObjectAtIndex:2 withObject:clearCacheName];
//    
//    [configTableView reloadData];
   

}

@end
