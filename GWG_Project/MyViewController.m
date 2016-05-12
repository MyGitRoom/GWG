//
//  MyViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MyViewController.h"
@interface MyViewController ()

@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
