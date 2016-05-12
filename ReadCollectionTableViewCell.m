//
//  ReadCollectionTableViewCell.m
//  GWG_Project
//
//  Created by Wcg on 16/5/12.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "ReadCollectionTableViewCell.h"

@implementation ReadCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgrand = [[UIImageView alloc]init];
        [self.contentView addSubview:_backgrand];
        _imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageV];
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _typeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_typeLabel];
        _jumpImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_jumpImage];
        _deleteno = [[UIImageView alloc]init];
        [self.contentView addSubview:_deleteno];
    
    }
    return  self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _backgrand.frame = CGRectMake(1, 1, KCellWidth-2, KCellHeight-2);
    _backgrand.image = [UIImage imageNamed:@"net1"];
    _imageV.frame = CGRectMake(10, 10, 100, 80);
    _typeLabel.textColor = [UIColor colorWithRed:0.765 green:0.620 blue:0.259 alpha:0.8];
    _typeLabel.frame = CGRectMake(130, 10, 60, 20);
    _typeLabel.text  =@"文 字";
    _title.frame = CGRectMake(130, 45, 120, 45);
    _title.numberOfLines = 0;
    _jumpImage.frame = CGRectMake(340, 10, 30, 30);
    _jumpImage.image = [UIImage imageNamed:@"jumpTo"];
    _deleteno.frame = CGRectMake(70, 10, 40, 80);
    _deleteno.alpha = 0.8;


    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
