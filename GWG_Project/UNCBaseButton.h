//
//  UNCButton.h
//  text0229
//
//  Created by HuangZhaoyi on 16/2/29.
//  Copyright © 2016年 HuangZhaoyi. All rights reserved.
//
#define UICOLORWITHRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
#import <UIKit/UIKit.h>

@interface UNCBaseButton : UIView{
    id _target;
    SEL _action;
    UIControlEvents _controlEvents;
}


- (id)initWithFrame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end
