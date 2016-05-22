//
//  ReadingDetailViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//http://static.owspace.com/wap/292017.html?device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&version=iOS_1.1.0&client=iOS

#import "ReadingDetailViewController.h"
#import "DataBaseUtil.h"

@interface ReadingDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
{
    NSInteger flag;//判断标签是否出现
}
//网页//
@property(nonatomic,strong)UIWebView * webView;
//收藏按钮//
@property(nonatomic,strong)UIButton * btn;
@end

@implementation ReadingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatWebView];
    [self creatPopView];
    [self creatDataBank];
    

  
    
}
#pragma -mark 建立webview
-(void)creatWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -64, KScreenWidth, KScreenHeight+64+600)];
    NSURL * url = [NSURL URLWithString:_read.share];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.backgroundColor = [UIColor lightGrayColor];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.delegate = self;
    _webView.delegate =self;
    [self.view addSubview:_webView];
    
}
#pragma -mark 弹出视图
-(void)creatPopView
{
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-40-5, 0, 40, 40)];
    [_btn addTarget:self action:@selector(PopViewToCollect) forControlEvents:UIControlEventTouchDown];
    [_btn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateSelected];
    
    [self.view addSubview:_btn];
}
#pragma -mark 收藏按钮
-(void)PopViewToCollect
{
    
    if (_btn.selected == NO) {
   [[DataBaseUtil shareDataBase]insertObjectOfReading:_read];

        _btn.selected = YES;
        [self popToPrompt:@"收藏成功"];
        
        
    }else
        {
            [[DataBaseUtil shareDataBase]deleteReadingWithName:_read.title];
            
            
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
#pragma -mark 监听网页滚动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = _webView.scrollView.contentOffset.y +_webView.scrollView.contentInset.top;
    CGFloat panTranslationY =[_webView.scrollView.panGestureRecognizer translationInView:_webView].y;
    if (offsetY>30) {
        if (panTranslationY>0) {//下滑
            if (flag==0) {
                _btn.alpha = 0;
                [UIView animateWithDuration:1 animations:^{
                   _btn.alpha = 1;//设置出现
                } completion:^(BOOL finished) {
                }];
                flag=1;
            }
        }else//上滑
        {
            [UIView animateWithDuration:1 animations:^{
                _btn.alpha = 0;//设置隐藏
            } completion:^(BOOL finished) {
            }];
            [self prefersStatusBarHidden];//设定状态栏
            flag =0;
        }
    }
}
//隐藏状态栏目
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma  -mark  数据库的建立
-(void)creatDataBank
{
    NSLog(@"%@",NSHomeDirectory());
    BOOL result = [[DataBaseUtil shareDataBase]creatReadingTable];
    if (result) {
        NSLog(@"建立阅读列表成功");
    }
    NSArray * array = [[DataBaseUtil shareDataBase]selectReadingTable];
    Reading * read = [[Reading alloc]init];
    for (read in array) {
        if ([read.title isEqualToString:_read.title]) {
            _btn.selected = YES;
        }
    }
  
    
}

@end
