//
//  TechnologyDetailsViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=view&aid=14338&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8

#import "TechnologyDetailsViewController.h"
#import "NetWorlRequestManager.h"
@interface TechnologyDetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
//Web//
@property(nonatomic,strong)UIWebView *techWebView;
//html 字符串//
@property(nonatomic,strong)NSString *strHtml;
//Collect//
@property(nonatomic,strong)UIButton *btn;
@end

@implementation TechnologyDetailsViewController

-(void)viewWillAppear:(BOOL)animated//设置导航栏效果 
{
    self.navigationController.navigationBarHidden =NO;
     [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData:_tec.aid];
    [self creatCollection];
    [self creatDatabank];
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  -mark 建立webView
-(void)creatWebView
{
    _techWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _techWebView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _techWebView.backgroundColor = [UIColor whiteColor];
    _techWebView.delegate =self;
    _techWebView.scrollView.delegate = self;
    #pragma 消除黑条
    _techWebView.opaque = NO;//初始化设置 view透明 来消除加载webview时出现的底部64黑条
    [self.view addSubview:_techWebView];
    NSString * strHTML = [self reSizeImageWithHTMLNoHead:_strHtml];
//    NSLog(@"%@",strHTML);
    [_techWebView loadHTMLString:strHTML baseURL:nil];
}
//给网页中的图片加 header ，方便控制固定的宽度
- (NSString *)reSizeImageWithHTMLNoHead:(NSString *)html {
  
    return [NSString stringWithFormat:@"<head><style>img{width:%fpx !important;}</style></head>%@",KScreenWidth-20, html];
}
#pragma -mark 处理接口数据
-(void)loadData:(NSInteger)aid
{
    [NetWorlRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=view&aid=%ld&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8",aid] ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dic1 = [dic objectForKey:@"returnData"];
        NSDictionary *  dic2 = [dic1 objectForKey:@"article_content"];
        _strHtml = [dic2 objectForKey:@"content"];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self creatWebView];
            
        });
    } error:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    

}
#pragma -mark 监听网页滚动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = _techWebView.scrollView.contentOffset.y +_techWebView.scrollView.contentInset.top;
    CGFloat panTranslationY =[_techWebView.scrollView.panGestureRecognizer translationInView:_techWebView].y;
    if (offsetY>30) {
        if (panTranslationY>0) {//下滑
          [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else//上滑
        {
          [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}
#pragma -mark 收藏按钮的创建
-(void)creatCollection
{
    _btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_btn setImage:[UIImage imageNamed:@"未收藏star"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"收藏star"] forState:UIControlStateSelected];
    [_btn addTarget:self action:@selector(CollectOfBtn) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    
}
#pragma -mark 收藏按钮点击方法
-(void)CollectOfBtn
{
    if (_btn.selected == NO) {
        [[DataBaseUtil shareDataBase]insertObjectOfTech:_tec];
        
        _btn.selected = YES;
        [self popToPrompt:@"收藏成功"];
    }else
    {
        [[DataBaseUtil shareDataBase]deleteTeconologyWithName:_tec.title];
        [self popToPrompt:@"取消收藏"];
        _btn.selected = NO;
    }
}
#pragma -mark 弹出提示框
-(void)popToPrompt:(NSString*)str
{
    UIAlertController * alertController =  [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(DismissTheAlert) userInfo:nil repeats:NO];
}
-(void)DismissTheAlert
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark 数据库
-(void)creatDatabank{

//    NSLog(@"%@",NSHomeDirectory());
    BOOL result = [[DataBaseUtil shareDataBase]createTechnologyTable];
    if (result) {
        NSLog(@"建立数字列表成功");
    }
    NSArray * array = [[DataBaseUtil shareDataBase]selectTechnologyTable];
    Technology * tech = [[Technology alloc]init];
    //    NSLog(@"%@",array);
    for (tech in array) {
        if ([tech.title isEqualToString:_tec.title]) {
            _btn.selected = YES;
        }
    }
    //    NSLog(@"%d",_btn.selected);
    
}

@end
