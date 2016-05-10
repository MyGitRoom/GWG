 //
//  RadioDetaillViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioDetaillViewController.h"
#import "MJRefresh.h"
#import "MJRefreshAutoFooter.h"

@interface RadioDetaillViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;
}
@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSMutableArray * dataDetailArray;
@property (nonatomic, strong) NSMutableArray * introduceArray;
@property (nonatomic, strong) NSString * tagString;

@property (nonatomic, strong) UIView * introduceView;

@end

@implementation RadioDetaillViewController

#pragma mark- 懒加载
- (NSMutableArray *) dataDetailArray
{
    if (!_dataDetailArray)
    {
        self.dataDetailArray = [NSMutableArray array];
    }
    return _dataDetailArray;
}

- (NSMutableArray *) introduceArray
{
    if (!_introduceArray)
    {
        self.introduceArray = [NSMutableArray array];
    }
    return _introduceArray;
}

- (UIView *) introduceView
{
    if (!_introduceView)
    {
        self.introduceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 400)];
        self.introduceView = [[[NSBundle mainBundle]loadNibNamed:@"IntroduceView" owner:self options:nil]lastObject];
    }
    return _introduceView;
}

#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadMoreData];
    page = 1;
    NSDictionary * parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2.0.5",@"app_version",@"1",@"sort",@"1",@"page",@"0",@"visitor_uid", nil];
    self.tagString = [DETAILURL stringByAppendingPathComponent:[NSString stringWithFormat:@"&collect_id=%@",[self.passId stringValue]]];
    [self requestData:self.tagString parDic:parDic];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 请求数据
- (void) requestData:(NSString *)string parDic:(NSDictionary *)dic
{
    NSDictionary * headerDic = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
  
    
    [NetWorlRequestManager requestWithType:POST urlString:string ParDic:dic dicOfHeader:headerDic finish:^(NSData *data) {
//          NSLog(@"%@",dic);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        NSArray * dataArray = [dic objectForKey:@"data"];
        self.flag = 0;
//        NSLog(@"%@",dataArray);
        for (NSDictionary * dic in dataArray)
        {
            DataDetailModel * dade = [[DataDetailModel alloc]init];
            [dade setValuesForKeysWithDictionary:dic];
            dade.model_flag = self.flag;
            [self.dataDetailArray addObject:dade];
//            NSLog(@"%@",dic);
            
            self.flag++;
//            NSLog(@"%ld",(long)dade.model_flag);
//            NSLog(@"%@",dade.user);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tab reloadData];
            [self requestIntroduce];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
}

//请求描述内容
- (void) requestIntroduce
{
    NSDictionary * headerDic = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    NSDictionary * parDic = [NSDictionary dictionaryWithObject:@"2.0.5" forKey:@"app_version"];
    [NetWorlRequestManager requestWithType:POST urlString:[DETAILDURL stringByAppendingPathComponent:[NSString stringWithFormat:@"&collect_id=%@",[self.passId stringValue]]] ParDic:parDic dicOfHeader:headerDic finish:^(NSData *data) {
        //        NSLog(@"%@",data);
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dic = %@",dic);
        NSDictionary * dataDic = [dic objectForKey:@"data"];
        IntroduceModel * introduce = [[IntroduceModel alloc]init];
        [introduce setValuesForKeysWithDictionary:dataDic];
        [self.introduceArray addObject:introduce];
//                NSLog(@"url = %@",introduce.cover_url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tab reloadData];
            if (!_tag)
            {
                [self createTableView];
                [self creatFooterRefresh];
                [self creatHeaderRefresh];
            }
            
        });
    } error:^(NSError *error) {
        
    }];
}

#pragma mark- 创建tableview
- (void) createTableView
{
    _tag = YES;
//    [self requestIntroduce];
//    NSLog(@"%@",self.introduceArray);
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
//    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
    
    //添加headerview
    _tab.tableHeaderView = self.introduceView;
    IntroduceModel * model = [self.introduceArray lastObject];
//    NSLog(@"%@",model.title);
    
    //背景设置毛玻璃
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = self.introduceView.frame;
    [self.introduceView addSubview:imageV];
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualView.frame = imageV.frame;
    [imageV addSubview:visualView];
    
    //前景设置圆形图片
    UIImageView * picImageV = (UIImageView *)[self.introduceView viewWithTag:2];
    [self.introduceView bringSubviewToFront:picImageV];
    [picImageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    picImageV.layer.cornerRadius = 100;
    picImageV.layer.masksToBounds = YES;
    
    UILabel * tieLab = (UILabel *)[self.introduceView viewWithTag:3];
    [self.introduceView bringSubviewToFront:tieLab];
    for (int i = 0; i < model.tags.count; i++)
    {
        tieLab.text = [tieLab.text stringByAppendingFormat:@" %@",[model.tags[i] objectForKey:@"name"]];
    }
//    NSLog(@"%@",tieLab);
    
    UILabel * introLab = (UILabel *)[self.introduceView viewWithTag:4];
    [self.introduceView bringSubviewToFront:introLab];
    introLab.text = model.intro;
    
    UIImageView * tieV1 = (UIImageView *)[self.introduceView viewWithTag:10085];
    [self.introduceView bringSubviewToFront:tieV1];
    UIImageView * tieV2 = (UIImageView *)[self.introduceView viewWithTag:20086];
    [self.introduceView bringSubviewToFront:tieV2];
    UILabel * tieL1 = (UILabel *)[self.introduceView viewWithTag:1086];
    [self.introduceView bringSubviewToFront:tieL1];
    UILabel * tieL2 = (UILabel *)[self.introduceView viewWithTag:2086];
    [self.introduceView bringSubviewToFront:tieL2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
}

#pragma -mark tableview代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DataDetailModel * dataD = [self.dataDetailArray objectAtIndex:indexPath.row];
        cell.titleLab.text = dataD.title;
        cell.typeLab.text = [dataD.user objectForKey:@"nick"];
        [cell.picView sd_setImageWithURL:[NSURL URLWithString:dataD.cover_url]];
        cell.countLab.text = [NSString stringWithFormat:@"%@人收听",dataD.count_play];
        
        return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataDetailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self initMusicPlayerControllerWithIndex:indexPath.row];
}

//根据索引下标创建对应的音乐播放的视图控制器
-(void)initMusicPlayerControllerWithIndex:(NSInteger)index
{
    MusicPlayerViewController * musicPlay;
    if (!musicPlay)
    {
        musicPlay = [[MusicPlayerViewController alloc]init];
    }
    musicPlay.currentIndex = index;
    musicPlay.detailMod = [self.dataDetailArray objectAtIndex:index];
    musicPlay.passDataArray = self.dataDetailArray;
    [self.navigationController pushViewController:musicPlay animated:YES];
}


//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    
    //去除tableview与边缘的15像素的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  mark- 上拉加载的方法
- (void) creatFooterRefresh
{
    _tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void) loadMoreData
{
    ++page;
    NSDictionary * parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2.0.5",@"app_version",@"1",@"sort",[NSString stringWithFormat:@"%d",page],@"page",@"0",@"visitor_uid", nil];
//    NSLog(@"%@",parDic);
    [self requestData:self.tagString parDic:parDic];
    [_tab reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timeStopP) userInfo:nil repeats:NO];
}

- (void) timeStopP
{
    [_tab.mj_footer endRefreshing];
}

#pragma  -mark 下拉刷新的方法
-(void)creatHeaderRefresh
{
    _tab.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
-(void)loadNewData
{
    NSDictionary * parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"app_version",@"2.0.5",@"sort",@"1",@"visitor_uid",@"0",@"page",@"1", nil];
    [self requestData:self.tagString parDic:parDic];
    [_tab  reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeStopPP) userInfo:nil repeats:NO];
}
-(void)timeStopPP
{
    [_tab.header endRefreshing];
}











@end
