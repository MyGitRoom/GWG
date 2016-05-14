//
//  MovieViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCollectionViewCell.h"
#import  "UIImageView+WebCache.h"
#import  "NetWorkRequestManager.h"
#import "MovieModel.h"
#include "TypeOfMovieViewController.h"
#import "XRCarouselView.h"
#import "MBProgressHUD.h"
@interface MovieViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate ,XRCarouselViewDelegate>

@property (nonatomic ,strong)UICollectionView *collectView ;
@property (nonatomic ,strong)NSMutableArray<MovieModel*>  *array ;

@property (nonatomic ,strong) XRCarouselView *scrollView ;
@property (nonatomic ,strong) MBProgressHUD *mbHUD ;

@end

@implementation MovieViewController
//懒加载
-(NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return  _array ;
}

-(void)viewWillAppear:(BOOL)animated{
  
    self.navigationController.navigationBarHidden = NO ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    
    //调用创建collectionView 的方法

    [self createCollectView];
    [self getData];
   
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    
}
- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}


//获取数据
-(void)getData {
    
    self.mbHUD = [[MBProgressHUD alloc]initWithView:self.collectView];
    [self.mbHUD show:YES];
    [self.collectView addSubview:self.mbHUD];


  [NetWorkRequestManager requestWithType:GET urlString:@"http://114.215.104.21/v130/singles/groupcat" ParDic:nil finish:^(NSData *data) {
      
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      NSArray *arr = [dic objectForKey:@"data"];
      
      NSDictionary *dict = arr [0];
      NSDictionary *dataArr = [dict objectForKey:@"cat"];
//      NSLog(@"%@",dataArr);
      for (NSDictionary *dict in dataArr) {
          MovieModel *Movie = [[MovieModel alloc]init];
          [Movie setValuesForKeysWithDictionary:dict];
          Movie.identifier = [dict objectForKey:@"id"]; //id是关键字要单独赋值
          [self.array addObject:Movie];
      }
       NSLog(@"%ld",self.array.count);
      dispatch_async(dispatch_get_main_queue(), ^{
          [self.collectView reloadData];
          [self.mbHUD hide:YES];
      });
      
      
  } err:^(NSError *error) {
      
  }];
    

}



//点击返回按钮的方法
-(void)back:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//创建collectView
-(void)createCollectView{
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //最小间距
    flowLayout.minimumInteritemSpacing = 10 ;
    flowLayout.minimumLineSpacing = 10 ;
    //边沿距离
    flowLayout.sectionInset  = UIEdgeInsetsMake(2, 10, 10, 10);
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
//    self.collectView.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
        self.collectView.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];
    
    self.collectView.delegate = self ;
    self.collectView.dataSource = self ;
    
    //注册collectionViewCell

    [self.collectView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //注册分区头
    [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:self.collectView];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.array.count  ;
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((KScreenWidth-45)/3,(KScreenWidth-45)/3/0.92);

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(KScreenWidth, KScreenHeight/3) ;
}

//设置collectionView 头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    [[headerView.subviews lastObject] removeFromSuperview] ;
    
    //网络图片
    NSArray *arr2 = @[@"http://pic6.qiyipic.com/image/20150511/1d/b9/v_109142000_m_601_480_270.jpg", @"http://img32.mtime.cn/up/2013/03/10/235922.90710072_o.jpg", @"http://photocdn.sohu.com/20090519/Img264054148.jpg"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/3)];
    
    self.scrollView = [XRCarouselView carouselViewWithImageArray:arr2];
    self.scrollView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight/3-40);
    self.scrollView.time = 2 ;
    self.scrollView.delegate = self ;
    
    //设置分页控件的frame
    CGFloat width = arr2.count * 30;
    CGFloat height = 20;
    CGFloat x = (_scrollView.frame.size.width - width )/2;
    CGFloat y = _scrollView.frame.size.height - height - 3;
    _scrollView.pageControl.frame = CGRectMake(x, y, width, height);
//    _scrollView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _scrollView.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,KScreenHeight/3-35,KScreenWidth , 30)];
        titleLabel.text = @"电影类型" ;
//    titleLabel.backgroundColor = [UIColor yellowColor];
        titleLabel.textColor = [UIColor whiteColor ];
        titleLabel.font = [UIFont systemFontOfSize:18];
    
        [view addSubview:self.scrollView];
        [view addSubview:titleLabel];
        [headerView addSubview:view];
    
    return headerView ;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.titleLabel.text = self.array[indexPath.item].name;
    

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.item].img_url]];
    return cell ;

}

//点击item进行跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{@"Content-Type":@"application/x-www-form-urlencoded",@"start":@"0",@"count":@"15",@"id":self.array[indexPath.item].identifier,} ;
    TypeOfMovieViewController *typeMovie = [[TypeOfMovieViewController alloc]init];
  
    typeMovie.dic = dict ;
//    NSLog(@"%@",typeMovie.dic);
//    [self presentViewController:typeMovie animated:YES completion:nil];
    [self.navigationController pushViewController:typeMovie animated:YES];
   
    
    


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
