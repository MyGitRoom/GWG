//
//  CollectionSelectViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "CollectionSelectViewController.h"
#import "ReadCollectionViewController.h"
#import "TechnolofyCollecViewController.h"
#import "MovieCollectViewController.h"
#import "RadioCollectViewController.h"
@interface CollectionSelectViewController ()
@property (nonatomic,strong)UIImageView * imageV;
@property (nonatomic,strong)UIImageView * typeImageV;
@property (nonatomic,strong)UILabel * wordLabel;

@end
@implementation CollectionSelectViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    [self setBackgrandImage];    //建立背景主色调
     [self setTagImage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏类型";
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
     [_typeImageV removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark 建立背景主色调
-(void)setBackgrandImage
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    _imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _imageV.image = [UIImage imageNamed:@"net1"];
    [self.view addSubview:_imageV];
}


#pragma  -mark 建立标签视图
-(void)setTagImage
{
    _typeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(-KScreenWidth/2+40, KScreenHeight/8,  KScreenWidth/4*3, 80)];
    _typeImageV.image = [UIImage imageNamed:@"tagleft"];
    [_imageV addSubview:_typeImageV];
    _wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight/6.5+5, 100, 40)];
//    wordLabel.center = typeImageV.center;
    _wordLabel.textAlignment = NSTextAlignmentCenter;
    _wordLabel.text = @"The Type ";
//    wordLabel.backgroundColor = [UIColor redColor];
    [_imageV addSubview:_wordLabel];
    
    
    //reading
    UIButton * btnReading = [[UIButton alloc]initWithFrame:CGRectMake(-10, KScreenHeight/5+50, KScreenWidth/4*3, 80)];
    [btnReading setBackgroundImage:[UIImage imageNamed:@"tagleft"] forState:UIControlStateNormal];
    [btnReading setTitle:@"Reading文章阅读" forState:UIControlStateNormal];
    btnReading.titleLabel.font = [UIFont systemFontOfSize:20];
    btnReading.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [btnReading setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReading addTarget:self action:@selector(jumpToReadingCollection:) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnReading];
    
    //technology
    UIButton * btnTec = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/4, KScreenHeight/5+150, KScreenWidth/4*3, 80)];
    [btnTec setBackgroundImage:[UIImage imageNamed:@"tagright"] forState:UIControlStateNormal];
    [btnTec setTitle:@"Digital life 科技资讯" forState:UIControlStateNormal];
    btnTec.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnTec addTarget:self action:@selector(jumpToTecCollection:) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnTec];

    //movie
    UIButton * btnMovie = [[UIButton alloc]initWithFrame:CGRectMake(-10, KScreenHeight/5+250, KScreenWidth/4*3, 80)];
    [btnMovie setBackgroundImage:[UIImage imageNamed:@"tagleft"] forState:UIControlStateNormal];
    [btnMovie setTitle:@"Radio电台播放" forState:UIControlStateNormal];
    btnMovie.titleLabel.font = [UIFont systemFontOfSize:20];
    btnMovie.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [btnMovie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMovie addTarget:self action:@selector(jumpToMovieCollection:) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnMovie];
    

    //radio
    UIButton * btnRadio = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/4, KScreenHeight/5+350, KScreenWidth/4*3, 80)];
    [btnRadio setBackgroundImage:[UIImage imageNamed:@"tagright"] forState:UIControlStateNormal];
    [btnRadio  setTitle:@"Movie电影精选" forState:UIControlStateNormal];
    btnRadio .titleLabel.font = [UIFont systemFontOfSize:20];
    [btnRadio  addTarget:self action:@selector(jumpToRadioCollection:) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnRadio];
    _imageV.userInteractionEnabled = YES;//开启交互
    
    
}


#pragma -mark 跳转方法
-(void)jumpToReadingCollection:(UIButton * )btn
{
    
    ReadCollectionViewController *read = [[ReadCollectionViewController alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        btn.frame = CGRectMake(-KScreenWidth/4*3, KScreenHeight/5+50, KScreenWidth/4*3, 80);
    
    } completion:^(BOOL finished) {
        
        [self.navigationController pushViewController:read animated:YES];
        [btn removeFromSuperview];
    }];
    
    
    
}

-(void)jumpToTecCollection:(UIButton * )btn
{
    TechnolofyCollecViewController *collec= [[TechnolofyCollecViewController alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        btn.frame = CGRectMake(KScreenWidth, KScreenHeight/5+150, KScreenWidth/4*3, 80);
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:collec animated:YES];
        [btn removeFromSuperview];
    }];
    
    
}
-(void)jumpToMovieCollection:(UIButton * )btn
{
  RadioCollectViewController *radio = [[RadioCollectViewController alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        btn.frame = CGRectMake(-KScreenWidth/4*3, KScreenHeight/5+250, KScreenWidth/4*3, 80);
    } completion:^(BOOL finished) {
      [self.navigationController pushViewController:radio animated:YES];
        [btn removeFromSuperview];
    }];
}

-(void)jumpToRadioCollection:(UIButton * )btn
{
    
    MovieCollectViewController *mov = [[MovieCollectViewController alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        btn.frame = CGRectMake(KScreenWidth, KScreenHeight/5+350, KScreenWidth/4*3, 80);
    } completion:^(BOOL finished) {
        
         [self.navigationController pushViewController:mov animated:YES];
        [btn removeFromSuperview];
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_imageV removeFromSuperview];
   
    [_wordLabel removeFromSuperview];
    self.navigationController.navigationBarHidden=NO;
}

@end
