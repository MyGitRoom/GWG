//
//  ReadCollectionViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "ReadCollectionViewController.h"
#import "DataBaseUtil.h"
#import "Reading.h"
#import "ReadCollectionTableViewCell.h"
#import "ReadingDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ReadCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL flag;//判断cell的点击模式
    NSInteger  times;
    BOOL all;//全选监控状态
}
@property(nonatomic,strong)UITableView * tab;
@property (nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSMutableArray * deleteArray; //删除的数组
@property (nonatomic,strong)UIButton * btn;//删除按钮；
@property (nonatomic,strong)UIView * deleteV;//底部删除视图
@end

@implementation ReadCollectionViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    _dataArray = [NSArray array];
    _dataArray =  [[DataBaseUtil shareDataBase]selectReadingTable];
    [_tab reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    _deleteArray = [NSMutableArray array];
    [self creatTabView];
    [self creatPopViewToDelete];
    self.view.backgroundColor = [UIColor lightGrayColor];
    

    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectType)];
}
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
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    ReadCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ReadCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    Reading * read = [_dataArray objectAtIndex:indexPath.row];
    cell.title.text = read.title;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:read.thumbnail] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {     
    }];
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
    return 100;
}
#pragma -mark cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReadingDetailViewController * readD =[[ReadingDetailViewController alloc]init];
    Reading * read = [_dataArray objectAtIndex:indexPath.row];
    if (flag == 0) {
        readD.read = read;
        readD.modalTransitionStyle = UIModalPresentationCurrentContext;
        [self presentViewController:readD animated:YES completion:nil];
    }
    else{
        
        ReadCollectionTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (times ==0) {//按钮删除状态
            [_deleteArray addObject:read];//删除数组
             cell.deleteno.image = [UIImage imageNamed:@"deleteyes"];
            times =1;
        }else if (times ==1)
        {
            [_deleteArray removeObject:read];
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
        for (Reading*read in _dataArray) {
            [_deleteArray addObject:read];
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
    
    for ( Reading * read in _deleteArray) {
        NSLog(@"%@",read.title);
        [[DataBaseUtil shareDataBase]deleteReadingWithName:read.title];
    };
     _dataArray =  [[DataBaseUtil shareDataBase]selectReadingTable];
    NSLog(@"%@",_dataArray);
    [_tab reloadData];

}

@end
