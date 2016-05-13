//
//  RadioCollectViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioCollectViewController.h"

@interface RadioCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL flag;//判断cell的点击模式
    BOOL  times;//按钮删除状态
    BOOL all;//全选监控状态
}
@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSArray * collectionArray;//收藏数组
@property (nonatomic, strong) UIView * vi;
@property (nonatomic, strong) UIView * placeHolderView;//占位图

@property (nonatomic,strong) NSMutableArray * deleteArray;//删除的数组
@property (nonatomic,strong)UIView * deleteV;//底部删除视图

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
    _deleteArray = [NSMutableArray array];
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
    [button addTarget:self action:@selector(touchClear) forControlEvents:UIControlEventTouchDown];
    
    
    [self createTable];
      [self creatPopViewToDelete];
    
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    //显示隐藏导航栏
    self.navigationController.navigationBarHidden = NO ;
    self.collectionArray = [[DataBaseUtil shareDataBase]selectRadioTable];
    if (self.collectionArray.count == 0)
    {
        self.placeHolderView = [[[NSBundle mainBundle]loadNibNamed:@"PlaceHolderView" owner:self options:nil]lastObject];
        self.placeHolderView.frame = self.view.bounds;
        [self.view addSubview:_placeHolderView];
    }
    else
    {
        [self.placeHolderView removeFromSuperview];
    }
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
//    _tab.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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
    cell.deleteImg.alpha = 0.8;
    if (flag == 1) {
        if (all ==0) {
            cell.deleteImg.image = [UIImage imageNamed:@"delete"];
        }else
        {
            cell.deleteImg.image = [UIImage imageNamed:@"deleteyes"];
        }
        
    }
    else if (flag == 0)
    {
        cell.deleteImg.image = [UIImage imageNamed:@""];//移除cell上的删除按钮。
    }
    
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
    if (flag == 0) {
        player.detailMod = model;
        player.passArray = (NSMutableArray *)self.collectionArray;
        [self.navigationController pushViewController:player animated:YES];
    }
    else{
        RadioCollectionTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (times ==0) {//按钮删除状态
            [_deleteArray addObject:model];//删除数组
            cell.deleteImg.image = [UIImage imageNamed:@"deleteyes"];
            
            times =1;
        }else if (times ==1)
        {
            [_deleteArray removeObject:model];
            cell.deleteImg.image = [UIImage imageNamed:@"delete"];
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
#pragma -mark 点击删除选项按钮
- (void) touchClear
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


#pragma  -mark 全选删除按钮
-(void)selectAll
{
    if ( all == 0) {
        all =1;
        for (DataDetailModel * radio in _collectionArray) {
            [_deleteArray addObject:radio];
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
    NSLog(@"删除数组%@",_deleteArray);
    for ( DataDetailModel * radio in _deleteArray) {
        NSLog(@"%@",radio.title);
        [[DataBaseUtil shareDataBase]deleteRadioWithName:radio.title];
    };
    _collectionArray =  [[DataBaseUtil shareDataBase]selectRadioTable];
//    NSLog(@"%@",_collectionArray);
    [_tab reloadData];
    
}






@end
