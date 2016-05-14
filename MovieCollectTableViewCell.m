//
//  MovieCollectTableViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/5/13.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieCollectTableViewCell.h"

@implementation MovieCollectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.imageV = [[UIImageView alloc]init];
        
        self.contentView.backgroundColor =  [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];
        
        
        self.deleteimageV = [[UIImageView alloc]init];
        self.deleteimageV.alpha = 0.8 ;
        
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deleteimageV];
                           
    }

    return  self ;

}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(9, KCellHeight-41, KCellWidth, 30) ;
    self.titleLabel.textAlignment = NSTextAlignmentLeft ;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.imageV.frame = CGRectMake(6, 0, KCellWidth-14, KCellHeight-8);
    self.imageV.layer.cornerRadius = 8 ;
    self.imageV.layer.masksToBounds = YES ;
    
    
    self.deleteimageV.frame = CGRectMake(KCellWidth-55, 15, 30, 30) ;
    

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
