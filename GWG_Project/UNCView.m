//
//  UNCView.m
//  text0229
//
//  Created by HuangZhaoyi on 16/2/29.
//  Copyright © 2016年 HuangZhaoyi. All rights reserved.
//

#import "UNCView.h"

@implementation UNCView
@synthesize uncBtnColor,bgColor;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.layer.masksToBounds = YES;
        isAnimation = NO;
        isOpen = NO;
        [self addControlPoint];
        [self addBgView];
       
        [self addCustButton];
        [self addCustview];
        [self addUNCButton];
        
    }
    return self;
}
- (void)addControlPoint{
    controlPoint_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    controlPoint_1.backgroundColor = [UIColor blackColor];
    controlPoint_1.center = CGPointMake(self.frame.size.width, 0);
    [self addSubview:controlPoint_1];
}
- (void)addUNCButton{
    button = [[UNCButton alloc] initWithFrame:CGRectMake(self.frame.size.width*4/5, - self.frame.size.width /5, self.frame.size.width *2/5, self.frame.size.width *2/5)];
    [self addSubview:button];
    [button addTarget:self action:@selector(runAction:) forControlEvents:UIControlEventTouchDown];
}
- (void)addBgView{
    bgView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:bgView];
    
}
- (void)addCustview{
    custView = [[UIView alloc] initWithFrame:self.bounds];
    layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];

    layer.path = path.CGPath;
    [custView.layer addSublayer:layer];
    [self addSubview:custView];
}
- (void)addCustButton{
    UNCBaseButton *custBtn_1;
    UNCBaseButton *custBtn_2;
    UNCBaseButton *custBtn_3;
    custBtn_1 = [[UNCBaseButton alloc] initWithFrame:CGRectMake(0 , -self.frame.size.width/18, self.frame.size.width/9, self.frame.size.width/9)];
    custBtn_1.transform = CGAffineTransformMakeRotation(M_PI_4*0.5);
    custBtn_1.backgroundColor = [UIColor colorWithRed:0.137 green:0.482 blue:0.490 alpha:1.000];
    lable_1 = [[UILabel alloc] initWithFrame:custBtn_1.bounds];
    lable_1.text = @"C";
    lable_1.textColor = [UIColor redColor];
    lable_1.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    lable_1.textAlignment = 1;
    [custBtn_1 addSubview:lable_1];
    custBtn_2 = [[UNCBaseButton alloc] initWithFrame:CGRectMake(0 ,  -self.frame.size.width/18, self.frame.size.width/9, self.frame.size.width/9)];
    custBtn_2.transform = CGAffineTransformMakeRotation(M_PI_4);
    custBtn_2.backgroundColor = [UIColor colorWithRed:0.514 green:0.173 blue:0.310 alpha:1.000];
    lable_2 = [[UILabel alloc] initWithFrame:custBtn_2.bounds];
    lable_2.text = @"S";
    lable_2.textColor = [UIColor redColor];
    lable_2.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    lable_2.textAlignment = 1;
    [custBtn_2 addSubview:lable_2];
    custBtn_3 = [[UNCBaseButton alloc] initWithFrame:CGRectMake(0 ,  -self.frame.size.width/18, self.frame.size.width/9, self.frame.size.width/9)];
    custBtn_3.transform = CGAffineTransformMakeRotation(M_PI_4*1.5);
    custBtn_3.backgroundColor = [UIColor colorWithRed:0.954 green:0.821 blue:0.588 alpha:1.000];
    lable_3 = [[UILabel alloc] initWithFrame:custBtn_2.bounds];
    lable_3.text = @"M";
    lable_3.textColor = [UIColor redColor];
    lable_3.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    lable_3.textAlignment = 1;
    [custBtn_3 addSubview:lable_3];
    
    radioView_1 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width *3/4, -1, self.frame.size.height*3/4,2 )];
    radioView_1.backgroundColor = [UIColor clearColor];
    radioView_1.layer.anchorPoint = CGPointMake(1, 0.5);
    [radioView_1 addSubview:custBtn_1];
    radioView_1.transform = CGAffineTransformMakeRotation(0.15);
    radioView_2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width *3/4, -1, self.frame.size.height*3/4,2 )];
    radioView_2.backgroundColor = [UIColor clearColor];
    radioView_2.layer.anchorPoint = CGPointMake(1, 0.5);
    [radioView_2 addSubview:custBtn_2];
    radioView_2.transform = CGAffineTransformMakeRotation(0.15);
    
    radioView_3 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width *3/4, -1, self.frame.size.height*3/4,2 )];
    radioView_3.backgroundColor = [UIColor clearColor];
    radioView_3.layer.anchorPoint = CGPointMake(1, 0.5);
    [radioView_3 addSubview:custBtn_3];
    radioView_3.transform = CGAffineTransformMakeRotation(0.15);
    
    [self addSubview:radioView_1];
    [self addSubview:radioView_2];
    [self addSubview:radioView_3];
}
- (void)setUncBtnColor:(UIColor *)newColor{
    uncBtnColor = newColor;
}
- (void)setBgColor:(UIColor *)newColor{
    bgColor = newColor;
    button.backgroundColor = newColor;
    bgView.backgroundColor = newColor;
}

- (void)setCustViewColor:(UIColor *)newColor{
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    lable_1.textColor = newColor;
    lable_2.textColor = newColor;
    lable_3.textColor = newColor;
    
}

- (void)changePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    int pos_x = self.frame.size.width*2/7;
    int pos_y = 0;
    double baseRadian = M_PI*1.4/self.frame.size.width;
    [path addLineToPoint:CGPointMake(pos_x, pos_y)];
    for (; pos_x<=self.frame.size.width; pos_x++) {
        if (pos_x<=self.frame.size.width*3/5) {
           pos_y = -cos(baseRadian*pos_x*1.7 - M_PI*0.72)*[[controlPoint_1.layer presentationLayer] position].y + [[controlPoint_1.layer presentationLayer] position].y;
        }
        else{
            pos_y = -cos(baseRadian*pos_x - M_PI*0.14)*[[controlPoint_1.layer presentationLayer] position].y + [[controlPoint_1.layer presentationLayer] position].y;
        }
    
        [path addLineToPoint:CGPointMake(pos_x, pos_y)];
    }
    [path closePath];
    layer.path = path.CGPath;
}
- (CADisplayLink *)displayLink{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changePath)];
        
        [_displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}
- (void)runAction:(id)sender{
    [self.btnjumpdelegate settingbtn];
    button.isAnimation = YES;
    self.displayLink.paused = NO;
    if (!isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            button.backgroundColor = uncBtnColor;
            button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            controlPoint_1.center = CGPointMake(self.frame.size.width, self.frame.size.height*5/12);
        } completion:^(BOOL finished) {
            self.displayLink.paused = YES;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                radioView_3.transform = CGAffineTransformMakeRotation(-M_PI_4*1.5);
            } completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:1 delay:0.1 usingSpringWithDamping:0.4
                  initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                radioView_2.transform = CGAffineTransformMakeRotation(-M_PI_4);
            } completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:1 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                radioView_1.transform = CGAffineTransformMakeRotation(-M_PI_4/2);
            } completion:^(BOOL finished) {
                button.isAnimation = NO;
                isOpen = YES;

            }];
            
        }];
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            radioView_1.transform = CGAffineTransformMakeRotation(0.15);
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            radioView_2.transform = CGAffineTransformMakeRotation(0.15);
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            radioView_3.transform = CGAffineTransformMakeRotation(0.15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                button.backgroundColor = bgColor;
                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
                controlPoint_1.center = CGPointMake(self.frame.size.width, 0);
            } completion:^(BOOL finished) {
                
                self.displayLink.paused = YES;
                button.isAnimation = NO;
                isOpen = NO;
            }];

        }];

        
    }
}
//- (CAKeyframeAnimation *)keyFrameAnimationwithStartAngle:(CGFloat)startAngle EndAngle:(CGFloat)endAngle Radius:(CGFloat)radius Duration:(NSTimeInterval)duration {
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path addArcWithCenter:CGPointMake(self.frame.size.width, 0) radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
//    
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;
//    
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.removedOnCompletion = YES;
//    pathAnimation.duration = duration;
////    pathAnimation.path
//    
//    pathAnimation.repeatCount = 0;
//    
//    
//    return pathAnimation;
//}
@end
