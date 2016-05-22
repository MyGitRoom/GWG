//
//  RadioDetaillViewController.h
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceModel.h"
#import "DataDetailModel.h"
#import "DetailTableViewCell.h"
//#import "IntroduceViewTableViewCell.h"
#import "NetWorlRequestManager.h"
#import "MusicPlayerViewController.h"

#define DETAILURL @"http://www.duole.fm/api/collect/get_sound_list?device=iphone&limit=15"
#define DETAILDURL @"http://www.duole.fm/api/collect/get_info?device=iphone&cover_size=big&allcover=1"

@interface RadioDetaillViewController : UIViewController

@property (nonatomic, strong) NSNumber * passId;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) BOOL tag;//记录tableview是否已经创建

@end
