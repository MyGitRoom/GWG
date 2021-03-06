//
//  TypeOfMovieTableViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TypeOfMovieTableViewCell.h"

@implementation TypeOfMovieTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.imageV = [[UIImageView alloc]init];
        self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effectview = [[UIVisualEffectView alloc]initWithEffect:self.blur];
        
//        self.likeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [self.likeBtn setImage:[UIImage imageNamed:@"orangeNotLike"] forState:UIControlStateNormal];
//        

        self.contentView.backgroundColor = [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];


        [self.contentView addSubview:self.imageV];
        
//        [self.contentView addSubview:self.effectview];
        
        [self.contentView addSubview:self.titleLabel];
        
//        [self.contentView addSubview:self.likeBtn];
    }

    return  self ;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.layer.cornerRadius = 8 ;
    self.imageV.layer.masksToBounds = YES ;
    
    self.titleLabel.frame = CGRectMake(9, KCellHeight-41, KCellWidth, 30);
    self.titleLabel.textAlignment = NSTextAlignmentLeft ;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.imageV.frame = CGRectMake(6, 0, KCellWidth-15, KCellHeight-8);
    
//    self.effectview.frame = self.imageV.frame ;
//    self.effectview.alpha = 0.1 ;
//    
//    self.likeBtn.frame =  CGRectMake(KScreenWidth-50, 10, 32, 32);

//    [self.likeBtn addTarget: self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
}

////实现按钮的方法
//-(void)like:(UIButton *)btn {
//    
//    
//    //调用协议的方法
//
//    [self.isLikeDelegate like:btn];
//    
//
//    
//} 


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
