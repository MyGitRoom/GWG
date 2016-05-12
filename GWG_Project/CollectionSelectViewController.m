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
@end
@implementation CollectionSelectViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //建立背景主色调
    [self setBackgrandImage];
    [self setTagImage];
    
   
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
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
    UIImageView * tagReading =[[UIImageView alloc]initWithFrame:CGRectMake(-10, KScreenHeight/5+50, KScreenWidth/4*3, 80)];
    tagReading.image = [UIImage imageNamed:@""];
    [_imageV addSubview:tagReading];
    UIButton * btnReading = [[UIButton alloc]initWithFrame:tagReading.frame];
    [btnReading setBackgroundImage:[UIImage imageNamed:@"tagleft"] forState:UIControlStateNormal];
    
    [btnReading setTitle:@"Reading" forState:UIControlStateNormal];
    btnReading.titleLabel.font = [UIFont systemFontOfSize:20];
    btnReading.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [btnReading setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReading addTarget:self action:@selector(jumpToReadingCollection) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnReading];
    
    UIImageView * tagTec =[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/4, KScreenHeight/5+150, KScreenWidth/4*3, 80)];
    tagTec.image = [UIImage imageNamed:@"tagrit"];
    [_imageV addSubview:tagTec];
    
    UIButton * btnTec = [[UIButton alloc]initWithFrame:tagTec.frame];
    [btnTec setBackgroundImage:[UIImage imageNamed:@"tagright"] forState:UIControlStateNormal];
    [btnTec setTitle:@"Technology" forState:UIControlStateNormal];
    btnTec.titleLabel.font = [UIFont systemFontOfSize:20];
    btnTec.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    [btnTec setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTec addTarget:self action:@selector(jumpToTecCollection) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnTec];

    UIImageView * tagMovie =[[UIImageView alloc]initWithFrame:CGRectMake(-10, KScreenHeight/5+250, KScreenWidth/4*3, 80)];
    tagMovie.image = [UIImage imageNamed:@"tagleft"];
    [_imageV addSubview:tagMovie];
    
    UIButton * btnMovie = [[UIButton alloc]initWithFrame:tagMovie.frame];
    [btnMovie setTitle:@"Movie" forState:UIControlStateNormal];
    btnMovie.titleLabel.font = [UIFont systemFontOfSize:20];
    btnMovie.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [btnMovie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMovie addTarget:self action:@selector(jumpToMovieCollection) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnMovie];
    
    UIImageView * tagRadio =[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/4, KScreenHeight/5+350, KScreenWidth/4*3, 80)];
    tagRadio.image = [UIImage imageNamed:@"tagright"];
    [_imageV addSubview:tagRadio];
    
    UIButton * btnRadio = [[UIButton alloc]initWithFrame:tagRadio .frame];
    [btnRadio  setTitle:@"Radio" forState:UIControlStateNormal];
    btnRadio .titleLabel.font = [UIFont systemFontOfSize:20];
    btnRadio .contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    [btnRadio  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRadio  addTarget:self action:@selector(jumpToRadioCollection) forControlEvents:UIControlEventTouchDown];
    [_imageV addSubview:btnRadio];
    
    _imageV.userInteractionEnabled = YES;//开启交互
    
    
}


#pragma -mark 跳转方法
-(void)jumpToReadingCollection
{
    ReadCollectionViewController *read = [[ReadCollectionViewController alloc]init];
    [self.navigationController pushViewController:read animated:YES];
    
}

-(void)jumpToTecCollection
{
    ReadCollectionViewController *read = [[ReadCollectionViewController alloc]init];
    [self.navigationController pushViewController:read animated:YES];
}
-(void)jumpToMovieCollection
{
   MovieCollectViewController *mov = [[MovieCollectViewController alloc]init];
    [self.navigationController pushViewController:mov animated:YES];
}
-(void)jumpToRadioCollection
{
    RadioCollectViewController *radio = [[RadioCollectViewController alloc]init];
    [self.navigationController pushViewController:radio animated:YES];
    
}

@end
