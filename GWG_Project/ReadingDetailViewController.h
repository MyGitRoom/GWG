//
//  ReadingDetailViewController.h
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reading.h"
@interface ReadingDetailViewController : UIViewController
/*接收网址*/
@property (nonatomic,strong)NSString * webStr;
/*接收标题 判断数据库*/
@property (nonatomic,strong)NSString  * str;
/*接受model*/
@property (nonatomic,strong)Reading * read;





@end
