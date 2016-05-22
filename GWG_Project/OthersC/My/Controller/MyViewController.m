//
//  MyViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MyViewController.h"
@interface MyViewController ()

@property (nonatomic ,strong) UITextView *textView ;
@property (nonatomic ,strong) UILabel *textLabel;

@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO ;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    
    self.view.backgroundColor = [UIColor darkGrayColor] ;
    
    
    
    
}


-(void)viewDidLoad{

    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,69,KScreenWidth-5,40)] ;
    //    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.text = @"版权说明" ;
    self.textLabel.font = [UIFont boldSystemFontOfSize:19] ;
    self.textLabel.textAlignment = NSTextAlignmentCenter ;
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(2, 114, KScreenWidth-4, KScreenHeight)];
    self.textView.backgroundColor = [UIColor darkGrayColor];
   
    self.textView.text =@"      本app所有内容均来自网络,包括文字、图片，音频、视频、软件、程序、以及版式设计等均在网络搜集。访问者可将本app提供的内容或服务用于个人学习、研究或欣赏，以及其他非商业性或非盈利性用途，但同时应遵守著作权法及相关法律的规定，不得侵犯本app及相关权利的合法权利。除此以外，将本app任何内容或服务用语其他用途，须征得本APP及相关权利的书面许可并支付报酬。\n       本app内容原作者如不愿意在本app刊登内容，请及时通知本APP，予以删除。\n联系方式：13160525782 \n邮箱：380568024@qq.com";
    //
    //    self.textLabel.text = @"本app所有内容均来自网络,包括文字、图片，音频、视频、软件、程序、以及版式设计等均在网络搜集。访问者可将本app提供的内容或服务用于个人学习、研究或欣赏，以及其他非商业性或非盈利性用途，但同时应遵守著作权法及相关法律的规定，不得侵犯本app及相关权利的合法权利。除此以外，将本app任何内容或服务用语其他用途，须征得本APP及相关权利的书面许可并支付报酬。本app内容原作者如不愿意在本app刊登内容，请及时通知本APP，予以删除。 联系方式：13160525782 邮箱：380568024@qq.com";
    //
    //    self.textLabel.numberOfLines = 0 ;
    //    self.textView.font = [UIFont fontWithName:@"STXingkai" size:17];
    self.textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.textLabel];
    
    [self.view addSubview:self.textView];
    


//- (void)viewDidLoad {
//    [super viewDidLoad];
      self.view.backgroundColor = [UIColor grayColor];
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
