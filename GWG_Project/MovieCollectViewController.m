//
//  MovieCollectViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieCollectViewController.h"
#import "MovieCollectTableViewCell.h"
#import "DataBaseUtil.h"
#import "TypeOfMovieModel.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailViewController.h"
@interface MovieCollectViewController ()<UITableViewDataSource ,UITableViewDelegate>


@property (nonatomic , strong) UITableView *tab ; //建立tableview来展示收藏列表

@property (nonatomic ,strong) NSArray *array ; //建立一个数组接收查询的数据

@property (nonatomic ,strong) TypeOfMovieModel *type_movie;//创建一个电影类型Model

@property (nonatomic ,strong) UIButton *settingBtn ; //设置按钮
@end

@implementation MovieCollectViewController

//懒加载
-(NSArray *)array {
    if (!_array) {
        _array = [NSArray array] ;
    }
    return _array ;
//    return self.array;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    
    self.array = [[DataBaseUtil shareDataBase] selectMovieTable];
    NSLog(@"--->%ld",self.array.count);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self creataReturnBtn];
    
    [self createTabelView] ;
    
    [self creatSettingBtn];
   
    
}

#pragma  mark - 创建导航返回键

-(void)creataReturnBtn{
  
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];

}
//执行导航栏返回键的方法
- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -创建设置按钮

-(void)creatSettingBtn {
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    self.settingBtn.frame = CGRectMake(0, 0, 30, 30);
    [self.settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [self.settingBtn addTarget:self action:@selector(editMovie) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.title = @"电影收藏";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.settingBtn];
    

}

#pragma mark - 实现设置按钮的方法

-(void)editMovie{





}

#pragma mark - 创建tableview

-(void)createTabelView {

    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain] ;

    //获取授权
    self.tab.delegate = self ;
    self.tab.dataSource = self ;
    
    self.tab.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];
    //取消下滑线
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    //注册cell
    [self.tab registerClass:[MovieCollectTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tab];
}


#pragma  mark - 实现tableview的代理方法

//返回cell的个数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
//    return  10 ;
//    NSLog(@">>>%ld",_array.count);
    return _array.count ;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifer = @"cell" ;
    MovieCollectTableViewCell *moviecell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    
    if (moviecell == nil) {
       
        moviecell = [[MovieCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        
    }
    moviecell.selectionStyle = UITableViewCellSelectionStyleNone ;
    self.type_movie = [[TypeOfMovieModel alloc]init];
    self.type_movie = _array[indexPath.row];
    moviecell.titleLabel.text = self.type_movie.name ;
    [moviecell.imageV sd_setImageWithURL:[NSURL URLWithString:self.type_movie.img_url]];
    return  moviecell ;
}


//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   return  (KScreenWidth-10)*0.518 ;

}

//点击cell进行跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MovieDetailViewController *movieVc = [[MovieDetailViewController alloc]init];
    
    movieVc.movie = self.array [indexPath.row];

    NSDictionary *dic = [NSDictionary dictionary];
    
    dic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"id":movieVc.movie.identifier} ;
    movieVc.dic = dic;
//        NSLog(@"%@",movieVc.movie.identifier);
    [self.navigationController pushViewController:movieVc animated:YES];
  
    

}

@end
