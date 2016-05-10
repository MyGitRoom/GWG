//
//  UNCButton.m
//  text0229
//
//  Created by HuangZhaoyi on 16/2/29.
//  Copyright © 2016年 HuangZhaoyi. All rights reserved.
//

#import "UNCButton.h"

@implementation UNCButton
@synthesize isAnimation;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.layer.masksToBounds = YES;
        isOpen = NO;
        isAnimation = NO;
        [self addBgView];
        [self addPointView];
        
    }
    return self;
}

- (void)addBgView{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*3/16, self.frame.size.height*9/16, self.frame.size.width/4, self.frame.size.height/4)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = self.frame.size.width/8;
    bgView.alpha = 0.0;
    [self addSubview:bgView];
}
- (void)addPointView{
    pointView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*3/16, self.frame.size.height*9/16, self.frame.size.width/4, self.frame.size.height/4)];
//    pointView.backgroundColor = [UIColor blackColor];
    [self addSubview:pointView];
    pointView.backgroundColor = [UIColor clearColor];
    leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, pointView.frame.size.width/3, 3)];
    leftView.layer.anchorPoint = CGPointMake(0.98, 0.5);
    leftView.center = CGPointMake(pointView.frame.size.width/2, pointView.frame.size.height/2 + pointView.frame.size.width/3 /sqrt(8));
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.transform = CGAffineTransformMakeRotation(M_PI_4);
    [pointView addSubview:leftView];
    
    rightView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, pointView.frame.size.width/3, 3)];
    rightView.layer.anchorPoint = CGPointMake(0.02, 0.5);
    [pointView addSubview: rightView];
    rightView.center = CGPointMake(pointView.frame.size.width/2, pointView.frame.size.height/2 + pointView.frame.size.width/3 /sqrt(8));
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.transform = CGAffineTransformMakeRotation(- M_PI_4);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (isAnimation) {
        return ;
    }
    [super touchesBegan:touches withEvent:event];
    bgView.alpha = 0.3;
    [UIView animateWithDuration:0.2 animations:^{
        bgView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        bgView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            bgView.transform = CGAffineTransformMakeScale(1, 1);
            bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            bgView.alpha = 0;
        }];
    }];
    if (!isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            pointView.frame = CGRectMake(pointView.frame.origin.x, pointView.frame.origin.y - pointView.frame.size.width/3 /sqrt(2) , pointView.frame.size.width, pointView.frame.size.height);
            leftView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            rightView.transform = CGAffineTransformMakeRotation(M_PI_4);
        } completion:^(BOOL finished) {
            isOpen = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            pointView.frame = CGRectMake(pointView.frame.origin.x, pointView.frame.origin.y + pointView.frame.size.width/3 /sqrt(2) , pointView.frame.size.width, pointView.frame.size.height);
            leftView.transform = CGAffineTransformMakeRotation(M_PI_4);
            rightView.transform = CGAffineTransformMakeRotation(-M_PI_4);
        } completion:^(BOOL finished) {
            isOpen = NO;
        }];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesEnded:touches withEvent:event];
}

@end
