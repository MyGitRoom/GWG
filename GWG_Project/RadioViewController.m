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
#import "RadioTableViewCell.h"

@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;//记录页数
}
@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * loadMoreArray;
@property (nonatomic, assign) BOOL isPlay;

@property (nonatomic ,assign) BOOL flag ;
@property (nonatomic ,assign) NSInteger i;

@end

@implementation RadioViewController

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
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    RadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RadioTableViewCell" owner:self options:nil]lastObject];
    }
    //设置cell无点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    DataModel * datmo = [_dataArray objectAtIndex:indexPath.row];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:datmo.cover_url]];
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
    return 80;
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
   
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        [UIView animateWithDuration: 1 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
          
        }];

}

                 




-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
//    self.isPlay = YES;
}



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

    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timeStopP) userInfo:nil repeats:NO];
}

- (void) timeStopP
{
    [_tab.mj_footer endRefreshing];
}

#pragma  -mark 下拉刷新的方法
-(void)creatHeaderRefresh
{
    _tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData
{
    [self requestData:RADIOURL];
    

    [_tab  reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeStopPP) userInfo:nil repeats:NO];
}
-(void)timeStopPP
{
    [_tab.mj_header  endRefreshing];
}


@end
