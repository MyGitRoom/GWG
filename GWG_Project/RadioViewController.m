//
//  RadioViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioViewController.h"
#import "MJRefresh.h"
#import "MJRefreshAutoFooter.h"

@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;//记录页数
}
@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * loadMoreArray;

@end

@implementation RadioViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =NO;
}
#pragma mark- 懒加载
- (NSMutableArray *) dataArray
{
    if (!_dataArray)
    {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *) loadMoreArray
{
    if (!_loadMoreArray)
    {
        self.loadMoreArray = [NSMutableArray array];
    }
    return _loadMoreArray;
}


#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    [self requestData:RADIOURL];
    [self createTableView];
    [self creatFooterRefresh];
    [self creatHeaderRefresh];
}

#pragma mark- 创建tableview
- (void) createTableView
{
//    CGRect frame = [UIScreen mainScreen].bounds;
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
}

#pragma -mark tableview代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //设置cell无点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    DataModel * datmo = [_dataArray objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:datmo.cover_url]];
    cell.titleLab.text = datmo.title;
    cell.introLab.text = datmo.intro;
    if ([datmo.count_play integerValue]/10000>0)
    {
        NSString * string = [NSString stringWithFormat:@"%.2f万人收听",[datmo.count_play integerValue]/10000.0];
        cell.countLab.text = string;
//        NSLog(@"%@",string);
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel * dat = [_dataArray objectAtIndex:indexPath.row];
    RadioDetaillViewController * detail = [[RadioDetaillViewController alloc]init];
    detail.passId = dat.identifier;
    [self.navigationController pushViewController:detail animated:YES];
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
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
*/

#pragma mark- 请求数据
- (void) requestData:(NSString *)string
{

    [NetWorlRequestManager requestWithType:GET urlString:string  ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
//        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = [dic objectForKey:@"data"];
        for (NSDictionary * dic in dataArray)
        {
            DataModel * dat = [[DataModel alloc]init];
            [dat setValuesForKeysWithDictionary:dic];
            dat.identifier = [dic objectForKey:@"id"];
            [self.dataArray addObject:dat];
        }
//        NSLog(@"%@",self.dataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tab reloadData];
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
}

#pragma  mark- 上拉加载的方法
- (void) creatFooterRefresh
{
    _tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void) loadMoreData
{
    ++page;
    [self.loadMoreArray addObject:[@"http://www.duole.fm/api/recommend/collect?app_version=2.0.5&device=iphone&limit=10&sort=3&visitor_uid=0" stringByAppendingFormat:@"&page=%d",page]];
    [self requestData:[self.loadMoreArray lastObject]];
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
    [self requestData:RADIOURL];
    [_tab  reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeStopPP) userInfo:nil repeats:NO];
}
-(void)timeStopPP
{
    [_tab.header endRefreshing];
}


@end
