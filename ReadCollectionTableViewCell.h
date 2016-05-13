//
//  ReadCollectionTableViewCell.h
//  GWG_Project
//
//  Created by Wcg on 16/5/12.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadCollectionTableViewCell : UITableViewCell
/*pic*/
@property (nonatomic,strong)UIImageView * imageV;
/*type*/
@property (nonatomic,strong)UILabel * typeLabel;
/*title*/
@property (nonatomic,strong)UILabel * title;
/*jumpPic*/
@property (nonatomic,strong)UIImageView * jumpImage;

@property (nonatomic,strong)UIImageView * deleteno;

@property (nonatomic,strong)UIImageView * backgrand;



@end
