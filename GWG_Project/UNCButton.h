//
//  UNCButton.h
//  text0229
//
//  Created by HuangZhaoyi on 16/2/29.
//  Copyright © 2016年 HuangZhaoyi. All rights reserved.
//

#import "UNCBaseButton.h"

@interface UNCButton : UNCBaseButton{
    UIView *bgView;
    UIView *pointView;
    UIView *leftView;
    UIView *rightView;
    BOOL isOpen;
}
@property(nonatomic ,assign)BOOL isAnimation;
@end
