//
//  RadioCollectViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioCollectViewController.h"

@interface RadioCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSArray * collectionArray;//收藏数组
@property (nonatomic, strong) UIView * vi;//占位图


@end

@implementation RadioCollectViewController

#pragma mark- 懒加载
- (NSArray *) collectionArray
{
    if (!_collectionArray)
    {
        self.collectionArray = [NSArray array];
    }
    return _collectionArray;
}

#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"收藏夹";
    
    self.collectionArray = [[DataBaseUtil shareDataBase]selectRadioTable];
//    NSLog(@"%@",self.collectionArray);
    if (self.collectionArray.count == 0)
    {
        NSLog(@"%@",self.collectionArray);
        [self createPlaceHolderView];
    }
    else
    {
        [self.vi removeFromSuperview];
    }
    //左侧返回视图
    UIImage * leftImage = [UIImage imageNamed:@"return"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    
    UIImage * rightImage = [UIImage imageNamed:@"clear11"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:rightImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 20, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self createTable];
    
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchClear
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //显示隐藏导航栏
    self.navigationController.navigationBarHidden = NO ;
    self.collectionArray = [[DataBaseUtil shareDataBase]selectRadioTable];
    [self.tab reloadData];
}

#pragma mark- 没有收藏时的占位图
- (void) createPlaceHolderView
{
    self.vi = [[[NSBundle mainBundle]loadNibNamed:@"PlaceHolderView" owner:self options:nil]lastObject];
    _vi.frame = CGRectMake(0, 100, KScreenWidth, 300);
    [self.view addSubview:_vi];
}

#pragma mark- 创建tableview
- (void) createTable
{
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
}

#pragma -mark tableview代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    RadioCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RadioCollectionTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString * string = [formatter stringFromDate:[NSDate date]];
    DataDetailModel * model = [self.collectionArray objectAtIndex:indexPath.row];
    cell.dateLab.text = string;
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    cell.titleLab.text = model.title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataDetailModel * model = [_collectionArray objectAtIndex:indexPath.row];
    RadioCollectionPlayerViewController * player = [[RadioCollectionPlayerViewController alloc]init];
    player.detailMod = model;
    player.passArray = (NSMutableArray *)self.collectionArray;
    [self.navigationController pushViewController:player animated:YES];
}












@end
