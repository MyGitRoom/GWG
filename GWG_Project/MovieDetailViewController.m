 //
//  MovieDetailViewController.m
//  GWG_Project
//
//  Created by 关振发 on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "NetWorkRequestManager.h"
#import "MBProgressHUD.h"
#import "DataBaseUtil.h"
@interface MovieDetailViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) MBProgressHUD *mbHUD ;

@property (nonatomic ,strong) UIButton *btn ;//创建收藏按钮

@property (nonatomic ,assign) NSInteger flag ;//判断收藏状态
@end

@implementation MovieDetailViewController

-(void)viewWillAppear:(BOOL)animated {
  
    self.navigationController.navigationBarHidden = NO ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //一加载创建收藏表
    [[DataBaseUtil shareDataBase]createMovieModelTable];
    
//    NSLog(@"%@",self.movie.name);
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    

    self.view.backgroundColor =  [UIColor colorWithRed:1.000 green:0.922 blue:0.850 alpha:1.000];

    self.wed = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-2)];
    self.wed.scrollView.bounces = NO ;
    self.wed.delegate = self ;
    [self getData];
    [self.view addSubview:self.wed];


    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    
    //添加收藏按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 30, 30);
    [_btn addTarget:self action:@selector(collectMovie:) forControlEvents:UIControlEventTouchDown];
    [_btn setImage:[UIImage imageNamed:@"orangeNotLike"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];


}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -实现收藏电影类型

-(void)collectMovie:(UIButton *)btn
{
    
    if (btn.selected == NO) {
        
       BOOL result = [[DataBaseUtil shareDataBase]insertObjectOfTypeOfMovie:self.movie];
        if (result) {
            btn.selected = YES;
            [self popToPrompt:@"收藏成功"];
            NSLog(@"收藏成功");
        }else{
            NSLog(@"收藏失败");
        }
        
        
        
    }else
    {
       BOOL result = [[DataBaseUtil shareDataBase]deleteMovieWithName:self.movie.name];
        if (result) {
            [self popToPrompt:@"取消收藏"];
            btn.selected = NO;
            NSLog(@"取消成功");
        }else{
        
            NSLog(@"取消失败");
        }
        
        
        
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

-(void)getData{

    
    self.view.backgroundColor = [UIColor colorWithRed:0.173 green:0.380 blue:0.208 alpha:1.000];
    self.mbHUD = [[MBProgressHUD alloc]initWithView:self.wed];
    [self.mbHUD show:YES];
    [self.wed addSubview:self.mbHUD];
   [NetWorkRequestManager requestWithType:POST urlString:@"http://mark.intlime.com/singles/detail" ParDic:self.dic finish:^(NSData *data) {

       NSDictionary *datadic = [NSDictionary dictionary];
       datadic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//       NSLog(@"%@",data);
       NSDictionary *dict = [datadic objectForKey:@"data"];
       NSString *HtmlStr = [dict objectForKey:@"content"];
//       NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"查看详情"];
//       NSString *str3 = [HtmlStr stringByTrimmingCharactersInSet:set];
       NSString *str = [HtmlStr stringByReplacingOccurrencesOfString:@"由Mark重新编辑整理发布" withString:@""];
       NSString *str2 = [str stringByReplacingOccurrencesOfString:@"想看" withString:@""];
//       NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"查看详情" withString:@""];
       NSString *str4 = [str2 stringByReplacingOccurrencesOfString:@"class=\"btn-movie notadded\""withString:@""];
       NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"class=\"icon icon-ok\"" withString:@""];
//        NSString *str6 = [str5 string];
              dispatch_async(dispatch_get_main_queue(), ^{
                  
           [self.wed loadHTMLString:str5 baseURL:nil];
                
           
           [self.view reloadInputViews];
                 
            [self.mbHUD hide:YES];
       });
   } err:^(NSError *error) {
       
   }];
    

 }

-(void)webViewDidFinishLoad:(UIWebView *)webView{
        [_wed stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.backgroundColor='rgb(225,207,191)'"];
//    NSString *string = @"<script type=\"text/javascript\" src=\"http://mark.intlime.com/Public/js/singledetail.js?v=15\"></script>";
//   NSString *string2 =@"<script> var MOVIES=eval('(' +'[{\"movie_id\":\"19920\",\"db_num\":19971387,\"name\":\"\u6234\u5b89\u5a1c\",\"img_url\":\"https:\/\/img1.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p2043239543.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"30837\",\"db_num\":3073073,\"name\":\"\u7b80\u7231\",\"img_url\":\"https:\/\/img3.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p1590560080.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"30847\",\"db_num\":3073158,\"name\":\"\u94c1\u5a18\u5b50\uff1a\u575a\u56fa\u67d4\u60c5\",\"img_url\":\"https:\/\/img1.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p1223336524.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"42208\",\"db_num\":3236520,\"name\":\"\u9999\u5948\u513f\",\"img_url\":\"https:\/\/img1.doubanio.com\/lpic\/s3372469.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"52143\",\"db_num\":1866264,\"name\":\"\u5973\u738b\",\"img_url\":\"https:\/\/img1.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p664458467.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"60617\",\"db_num\":1433990,\"name\":\"\u98ce\u96e8\u54c8\u4f5b\u8def\",\"img_url\":\"https:\/\/img1.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p2184507337.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"65794\",\"db_num\":1293050,\"name\":\"\u6c38\u4e0d\u59a5\u534f\",\"img_url\":\"https:\/\/img1.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p643400568.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"70970\",\"db_num\":1295804,\"name\":\"\u8d1d\u9686\u592b\u4eba\",\"img_url\":\"https:\/\/img3.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p1576766113.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"73323\",\"db_num\":1293818,\"name\":\"\u94a2\u7434\u8bfe\",\"img_url\":\"https:\/\/img3.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p764799071.jpg\",\"is_done\":\"-1\"},{\"movie_id\":\"96264\",\"db_num\":1482072,\"name\":\"\u7a7f\u666e\u62c9\u8fbe\u7684\u5973\u738b\",\"img_url\":\"https:\/\/img3.doubanio.com\/view\/movie_poster_cover\/lpst\/public\/p735379215.jpg\",\"is_done\":\"-1\"}]'+ ')'); </script>" ;
//    
//    [self.wed stringByEvaluatingJavaScriptFromString:string];
//    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
