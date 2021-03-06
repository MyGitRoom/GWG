//
//  TypeOfMovieViewController.m
//  GWG_Project
//
//  Created by 关振发 on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TypeOfMovieViewController.h"
#import "TypeOfMovieTableViewCell.h"
#import "NetWorkRequestManager.h"
#import "UIImageView+WebCache.h"
#import "TypeOfMovieModel.h"
#import "MovieDetailViewController.h"
#import "MBProgressHUD.h"
//@interface TypeOfMovieViewController ()<UITableViewDataSource,UITableViewDelegate,isLike>
@interface TypeOfMovieViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSMutableArray <TypeOfMovieModel*>*array ;//建一个数组接收解析数据
@property (nonatomic,strong) UITableView *tab ;
@property (nonatomic,strong) MBProgressHUD *mbHUD;
@property (nonatomic,strong) UIButton *likeBtn ;

@end

@implementation TypeOfMovieViewController

//懒加载
-(NSMutableArray*)array {
        if (!_array) {
            self.array = [NSMutableArray array];
        }
        
        return _array ;
    }
    


- (void)viewDidLoad {
        [super viewDidLoad];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    self.navigationController.navigationBarHidden = NO ;
    
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth,KScreenHeight) style:UITableViewStylePlain];
    
        self.tab.delegate = self ;
        self.tab.dataSource = self ;
    
        self.tab.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
        //注册cell
        [self.tab registerClass:[TypeOfMovieTableViewCell class] forCellReuseIdentifier:@"cell"];
    
      self.tab.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];

    self.view.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];

      [self.view addSubview:self.tab];
    
        [self getData];
    
//    self.likeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.likeBtn setImage:[UIImage imageNamed:@"orangelike"] forState:UIControlStateNormal];
//    [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected ];
//    self.likeBtn.frame =  CGRectMake(KScreenWidth-50, 10, 32, 32);
//    [self.view addSubview:self.likeBtn];
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}
    //获取数据
-(void)getData{
//        NSLog(@"%@",self.dic);
        self.mbHUD = [[MBProgressHUD alloc]initWithView:self.tab];
        [self.mbHUD show:YES];
        [self.tab addSubview:self.mbHUD];
        [NetWorkRequestManager requestWithType:POST urlString:@"http://114.215.104.21/v130/singles/catlist" ParDic:self.dic finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dataDic in arr) {
                TypeOfMovieModel *modle = [[TypeOfMovieModel alloc]init];
                [modle setValuesForKeysWithDictionary:dataDic];
                modle.identifier = [dataDic objectForKey:@"id"];//id作为特殊字段要单独赋值
                [self.array addObject:modle];
//                NSLog(@"%ld",self.array.count);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程刷新
                [self.tab reloadData];
                [self.mbHUD hide: YES];
            });
            
        } err:^(NSError *error) {
            
        }];
        
        
    }
    
    
#pragma mark tableview 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.array.count;
    }
    
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
        TypeOfMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    TypeOfMovieTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TypeOfMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
    
//    cell.isLikeDelegate = self ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.titleLabel.text = self.array[indexPath.row].name ;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.row].img_url]];
        
        
        return cell;
        
    }
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return  (KScreenWidth-10)*0.618 ;
    }

//点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MovieDetailViewController *movieDeatilVc = [[MovieDetailViewController alloc]init];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    dic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"id":self.array[indexPath.row].identifier} ;
    movieDeatilVc.dic = dic;
    
    movieDeatilVc.movie  = self.array[indexPath.row];
    
//    [self presentViewController:movieDeatilVc animated:YES completion:nil];
    [self.navigationController pushViewController:movieDeatilVc animated:YES];



}


#pragma mark  - 实现收藏按钮的方法

-(void)like:(UIButton *)btn{

    [btn setImage:[UIImage imageNamed:@"orangeNotLike"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
  
    if (btn.selected == NO) {
        btn.selected = YES;
    }else
    {
        btn.selected = NO;
    }
   
    
}


//tabelView执行动画效果

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransform3D rotation;
            rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
            rotation.m34 = 1.0/ -600;
            
            cell.layer.shadowColor = [[UIColor blackColor]CGColor];
            cell.layer.shadowOffset = CGSizeMake(10, 10);
            cell.alpha = 0;
            cell.layer.transform = rotation;
            cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            
            [UIView beginAnimations:@"rotation" context:NULL];
            [UIView setAnimationDuration:0.5];
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            [UIView commitAnimations];
            
            
            
        });
    }
    
}
/*
//给cell添加动画
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.5, 1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    CGFloat offsetY = scrollView.contentOffset.y + _tab.contentInset.top;//注意
//    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.tab].y;
//    
//    if (offsetY > 64) {
//        if (panTranslationY > 0) { //下滑趋势，显示
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//        else {  //上滑趋势，隐藏
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//        }
//    }
//    else {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.navigationController.navigationBarHidden = YES ;
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    self.navigationController.navigationBarHidden = NO ;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
