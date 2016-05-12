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
    _backgrand.frame = CGRectMake(0, KCellHeight-5, KCellWidth,5);
    _backgrand.backgroundColor = [UIColor lightGrayColor];
//    _backgrand.image = [UIImage imageNamed:@"net1"];
    _imageV.frame = CGRectMake(5, 5, KCellWidth/3.5, KCellHeight-15);
    _typeLabel.textColor = [UIColor colorWithRed:0.765 green:0.620 blue:0.259 alpha:0.8];
    _typeLabel.frame = CGRectMake(130, 10, 60, 20);
    _typeLabel.text  =@"文 字";
    _title.frame = CGRectMake(130, 45, 120, 45);
    _title.numberOfLines = 0;
    _jumpImage.frame = CGRectMake(340, 10, 30, 30);
    _jumpImage.image = [UIImage imageNamed:@"jumpTo"];
    _deleteno.frame = CGRectMake(KCellWidth/7+10, 5, KCellWidth/8, KCellHeight-15);
    _deleteno.alpha = 0.8;


    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
