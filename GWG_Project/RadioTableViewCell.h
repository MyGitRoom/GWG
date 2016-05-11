//
//  RadioTableViewCell.h
//  GWG_Project
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *introLab;

@end
