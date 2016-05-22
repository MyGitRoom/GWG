//
//  RadioCollectionPlayerViewController.h
//  GWG_Project
//
//  Created by lanou on 16/5/13.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseUtil.h"
#import "DataDetailModel.h"
#import "GYPlayer.h"

@interface RadioCollectionPlayerViewController : UIViewController<GYPlayerDelegate>

@property (nonatomic, strong) DataDetailModel * detailMod;
@property (nonatomic, strong) NSMutableArray * passArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end
