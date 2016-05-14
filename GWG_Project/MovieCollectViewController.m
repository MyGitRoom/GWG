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

@property (nonatomic ,strong) NSMutableArray *deleteArray ; //删除数组

@property (nonatomic ,strong) NSArray *dataArray ;

@property (nonatomic ,assign) BOOL flag ;

@property (nonatomic ,assign) BOOL all ;

@property (nonatomic ,assign) BOOL times ;

@property (nonatomic ,strong) UIView *deleteV ;// 底部删除视图

@property (nonatomic ,assign) NSInteger i ;
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

//-(NSMutableArray*)deleteArray{
//
//    if (!_deleteArray) {
//        self.deleteArray = [NSMutableArray array];
//    }
//    
//    return _deleteArray ;
//    
//}


-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    
    self.array = [[DataBaseUtil shareDataBase] selectMovieTable];
    NSLog(@"--->%ld",self.array.count);
//    _dataArray = [NSArray array];
//    _dataArray =  [[DataBaseUtil shareDataBase]selectReadingTable];
    [_tab reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
   
    _deleteArray = [NSMutableArray array];
    [self creataReturnBtn];
    
    [self createTabelView] ;
    
    [self creatSettingBtn];
    
    [self creatPopViewToDelete];
    
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

    if (_flag == 0) {
        _flag = 1;
        [UIView animateWithDuration:0.5 animations:^{
            _deleteV.frame = CGRectMake(0, KScreenHeight-50, KScreenWidth, 50);
        }];
        
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _deleteV.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 50);
        }];
        _flag =0;
    }
    
    [_tab reloadData];
    NSLog(@"cell点击状态%d",_flag);



}

#pragma -mark 创建下方弹出窗口删除
-(void)creatPopViewToDelete
{
    _deleteV= [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 50)];
    _deleteV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_deleteV];
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
    [leftBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchDown];
    [leftBtn setImage:[UIImage imageNamed:@"selectallN"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_deleteV addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 0, 50, 50)];
    [rightBtn addTarget:self action:@selector(deleteSelectCell) forControlEvents:UIControlEventTouchDown];
//    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"deletecollect"] forState:UIControlStateNormal];
    [_deleteV addSubview:rightBtn];
    
}

#pragma mark - 删除和全选按钮方法
-(void)selectAll:(UIButton *)leftBtn{
    if ( _all == 0) {
        [leftBtn setImage:[UIImage imageNamed:@"selectallY"] forState:UIControlStateNormal];
        _all =1;
        for (TypeOfMovieModel *movie in _array) {
            
            [_deleteArray addObject:movie];
        }
    }
    else
    {
         [leftBtn setImage:[UIImage imageNamed:@"selectallN"] forState:UIControlStateNormal];
        [_deleteArray removeAllObjects];
        _all=0;
    }
    [_tab reloadData];

}

-(void)deleteSelectCell{

    for ( TypeOfMovieModel * movie in _deleteArray) {
//        NSLog(@"%@",movie.name);

        [[DataBaseUtil shareDataBase]deleteMovieWithName:movie.name];
    };
    _array =  [[DataBaseUtil shareDataBase]selectMovieTable];
    NSLog(@"%@",_array);
    [_tab reloadData];


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
    MovieCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    
    if (cell == nil) {
       
      cell = [[MovieCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    self.type_movie = [[TypeOfMovieModel alloc]init];
    self.type_movie = _array[indexPath.row];
   cell.titleLabel.text = self.type_movie.name ;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.type_movie.img_url]];
    if (_flag == 1) {
        if (_all ==0) {
            
            cell.deleteimageV.image = [UIImage imageNamed:@"deleteN"];
        }else
        {
            cell.deleteimageV.image = [UIImage imageNamed:@"deleteY"];
        }
        
    }
    else if (_flag == 0)
    {
        cell.deleteimageV.image = [UIImage imageNamed:@""];//移除cell上的删除按钮。
    }
    
    
    
    return  cell ;
}


//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   return  (KScreenWidth-10)*0.518 ;

}

//点击cell进行跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MovieDetailViewController *movieVc = [[MovieDetailViewController alloc]init];
    
    if (_flag == 0) {
        movieVc.movie = self.array [indexPath.row];
        
        NSDictionary *dic = [NSDictionary dictionary];
        
        dic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"id":movieVc.movie.identifier} ;
        movieVc.dic = dic;
        //        NSLog(@"%@",movieVc.movie.identifier);
        [self.navigationController pushViewController:movieVc animated:YES];
    }
    else{
        
        MovieCollectTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
       NSInteger  index = indexPath.row ;
        
        if (index == _i) {
            _i = index ;
            if (_times ==0) {//按钮删除状态
                [_deleteArray addObject:self.array[indexPath.row]];//删除数组
                cell.deleteimageV.image = [UIImage imageNamed:@"deleteY"];
                _times =1;
                NSLog(@"%ld",_deleteArray.count);
                //        }else if (_times ==1)
            }else
            {
                [_deleteArray removeObject:self.array[indexPath.row]];
                cell.deleteimageV.image = [UIImage imageNamed:@"deleteW"];
                _times =0;
                
                NSLog(@"%ld",_deleteArray.count);
                
            }
 
        }else{
//            _times = 0 ;
            _i = index ;
            if (_times ==0) {//按钮删除状态
                [_deleteArray addObject:self.array[indexPath.row]];//删除数组
                cell.deleteimageV.image = [UIImage imageNamed:@"deleteY"];
                _times =1;
                NSLog(@"%ld",_deleteArray.count);
                //        }else if (_times ==1)
            }else
            {
                [_deleteArray removeObject:self.array[indexPath.row]];
                cell.deleteimageV.image = [UIImage imageNamed:@"deleteW"];
                _times =0;
                
                NSLog(@"%ld",_deleteArray.count);
                
            }
 
        }
        
    }


}

@end
