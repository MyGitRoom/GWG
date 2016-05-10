//
//  TechnologyDetailsViewController.h
//  GWG_Project
//
//  Created by Wcg on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Technology.h"
#import "DataBaseUtil.h"
@interface TechnologyDetailsViewController : UIViewController
//接受web//
@property(nonatomic,assign)NSString *  aid;
/*model*/
@property (nonatomic,strong)Technology * tec;

@end
