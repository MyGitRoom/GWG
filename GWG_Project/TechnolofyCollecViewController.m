//
//  TechnolofyCollecViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TechnolofyCollecViewController.h"
#import "DataBaseUtil.h"
#import "ReadCollectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Technology.h"
#import "TechnologyTableViewCell.h"
#import "TechnologyDetailsViewController.h"
#import "TecCollectionTableViewCell.h"


@interface TechnolofyCollecViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL flag;//判断cell的点击模式
    BOOL  times;//按钮删除状态
    BOOL all;//全选监控状态
}
@property(nonatomic,strong)UITableView * tab;
@property (nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSMutableArray * deleteArray; //删除的数组
@property (nonatomic,strong)UIView * deleteV;//底部删除视图
@end

@implementation TechnolofyCollecViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    _dataArray = [NSArray array];
    _dataArray =  [[DataBaseUtil shareDataBase]selectTechnologyTable];
    [_tab reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"数字生活";
    self.navigationController.navigationBarHidden = NO;
    _deleteArray = [NSMutableArray array];
    [self creatTabView];
    [self creatPopViewToDelete];
    [self creatBtnTo];
}
#pragma -mark 导航栏按钮
-(void)creatBtnTo
{
    //返回按钮
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    
    //删除按钮
    UIImage * rightImage = [UIImage imageNamed:@"clear11"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:rightImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 20, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchDown];
}
#pragma -mark 选择cell跳转模式
-(void)selectType
{
    if (flag == 0) {
        flag = 1;
        [UIView animateWithDuration:0.5 animations:^{
            _deleteV.frame = CGRectMake(0, KScreenHeight-50, KScreenWidth, 50);
        }];
        
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _deleteV.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 50);
        }];
        flag =0;
    }
    [_tab reloadData];
    NSLog(@"cell点击状态%d",flag);
}

#pragma -mark 添加返回上一层按钮
- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  -mark 建表
-(void)creatTabView
{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _tab.delegate  =self;
    _tab.dataSource = self;
    _tab.showsVerticalScrollIndicator = NO;
    _tab.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tab];
}

#pragma  Tab DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    TecCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TecCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     Technology* tec = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = tec.title;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:tec.pic_url] placeholderImage:nil ];
    if (flag == 1) {
        if (all ==0) {
            cell.deleteno.image = [UIImage imageNamed:@"delete"];
        }else
        {
            cell.deleteno.image = [UIImage imageNamed:@"deleteyes"];
        }
        
    }
    else if (flag == 0)
    {
        cell.deleteno.image = [UIImage imageNamed:@""];//移除cell上的删除按钮。
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  (KScreenWidth-10)*0.518;
}
#pragma -mark cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TechnologyDetailsViewController * tecD =[[TechnologyDetailsViewController alloc]init];
    Technology * tec = [_dataArray objectAtIndex:indexPath.row];
    if (flag == 0) {
        tecD.tec = tec;
    [self.navigationController pushViewController:tecD animated:YES];
    }
    else{
        TecCollectionTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (times ==0) {//按钮删除状态
            [_deleteArray addObject:tec];//删除数组
            cell.deleteno.image = [UIImage imageNamed:@"deleteyes"];
            times =1;
        }else if (times ==1)
        {
            [_deleteArray removeObject:tec];
            cell.deleteno.image = [UIImage imageNamed:@"delete"];
            times =0;
        }
    }
}
#pragma -mark 创建下方弹出窗口删除
-(void)creatPopViewToDelete
{
    _deleteV= [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 50)];
    _deleteV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_deleteV];
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [leftBtn addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchDown];
    [leftBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_deleteV addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-50, 0, 50, 50)];
    [rightBtn addTarget:self action:@selector(deleteSelectCell) forControlEvents:UIControlEventTouchDown];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteV addSubview:rightBtn];
    
}

#pragma  -mark 全选删除按钮
-(void)selectAll
{
    if ( all == 0) {
        all =1;
        for (Technology * tec in _dataArray) {
            [_deleteArray addObject:tec];
        }
    }
    else
    {
        [_deleteArray removeAllObjects];
        all=0;
    }
    [_tab reloadData];
    
    
}
#pragma  -mark 删除按钮
-(void)deleteSelectCell
{
    
    for ( Technology * tec in _deleteArray) {
        NSLog(@"%@",tec.title);
        [[DataBaseUtil shareDataBase]deleteTeconologyWithName:tec.title];
    };
    _dataArray =  [[DataBaseUtil shareDataBase]selectTechnologyTable];
    NSLog(@"%@",_dataArray);
    [_tab reloadData];
    
}

@end
