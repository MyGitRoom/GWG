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
}



@end
