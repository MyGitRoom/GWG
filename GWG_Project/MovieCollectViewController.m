//
//  MovieCollectViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/11.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieCollectViewController.h"

@interface MovieCollectViewController ()

@end

@implementation MovieCollectViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO ;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    UIImage * image = [UIImage imageNamed:@"return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(touchReturn)];
}

- (void) touchReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
