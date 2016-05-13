//
//  TecCollectionTableViewCell.m
//  GWG_Project
//
//  Created by Wcg on 16/5/12.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TecCollectionTableViewCell.h"
#import "TecCollectionTableViewCell.h"
@implementation TecCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.imageV = [[UIImageView alloc]init];
        self.contentView.backgroundColor =  [UIColor colorWithRed:0.024 green:0.031 blue:0.063 alpha:1.000];
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.titleLabel];
        _deleteno = [[UIImageView alloc]init];
        [self.contentView addSubview:_deleteno];
        
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
    
    _deleteno.frame = CGRectMake(KCellWidth-8-KCellHeight/4, 5, KCellHeight/4, KCellHeight/2.5);
    _deleteno.alpha =0.8;
//    _deleteno.backgroundColor = [UIColor blueColor];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
