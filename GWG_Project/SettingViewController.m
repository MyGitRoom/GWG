//
//  SettingViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
    self.navigationController.navigationBarHidden = NO ;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
