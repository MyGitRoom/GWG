//
//  MyView.h
//  UI进阶分享引导图
//
//  Created by lanou on 17/3/24.
//  Copyright © 2017年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Width  self.frame.size.width
//#define Height self.view.frame.size.height
#define  Height self.frame.size.height

@interface MyView : UIView

@property (nonatomic ,strong) UIScrollView *sc ;

@property (nonatomic ,strong) UIImageView *imageV ;

@property (nonatomic ,strong) UIImageView *imageV2 ;


@end
