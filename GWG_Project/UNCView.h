//
//  UNCView.h
//  text0229
//
//  Created by HuangZhaoyi on 16/2/29.
//  Copyright © 2016年 HuangZhaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNCButton.h"
@interface UNCView : UIView{
    UNCButton *button;
    UIView *bgView;
    UIView *custView;
    CAShapeLayer *layer;
    UIView *controlPoint_1;
    BOOL isOpen;
    BOOL isAnimation;
    UIView *radioView_1;
    UIView *radioView_2;
    UIView *radioView_3;
    UILabel *lable_1;
    UILabel *lable_2;
    UILabel *lable_3;
    
}

@property (nonatomic ,strong)UIColor *bgColor;
@property (nonatomic ,strong)UIColor *uncBtnColor;
@property (nonatomic ,strong)UIColor *custViewColor;
@property(nonatomic, strong)CADisplayLink *displayLink;
- (id)initWithFrame:(CGRect)frame;

@end
