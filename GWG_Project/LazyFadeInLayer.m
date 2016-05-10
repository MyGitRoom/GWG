//
//  LazyFadeInLayer.m
//  LazyFadeInView
//
//  Created by Tu You on 14-4-20.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "LazyFadeInLayer.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
@interface LazyFadeInLayer ()

@property (strong, nonatomic) CADisplayLink *displayLink; //定时器
@property (strong, nonatomic) NSMutableArray *alphaArray; //透明度数组
@property (strong, nonatomic) NSMutableAttributedString *attributedString; //富文本字符串
@property (strong, nonatomic) NSMutableArray *tmpArray; //临时数组存放

@end

@implementation LazyFadeInLayer

@synthesize duration = _duration;
@synthesize numberOfLayers = _numberOfLayers;
@synthesize interval = _interval;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        _duration = 1.2f;
        _duration = 0.5f ;
        _numberOfLayers = 6;
        _interval = 0.2;
        _alphaArray = [NSMutableArray array];
        _tmpArray = [NSMutableArray array];
        _attributedString = [[NSMutableAttributedString alloc] init];
        self.wrapped = YES;
    }
    return self;
}


//设置显示文本
- (void)setText:(NSString *)text
{
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (!text)
    {
        _text = @" ";
    }
    else
    {
        _text = text;
    }
    
    _attributedString = [[NSMutableAttributedString alloc] initWithString:_text];
    
    if (_text.length != 0)
    {
        [self setupAlphaArray];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameUpdate:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}


//定时器执行的方法
- (void)frameUpdate:(id)sender
{
    [self.attributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:NSMakeRange(0, self.text.length)];
    
    BOOL shouldRemoveTimer = YES;
    for (int i = 0; i < self.text.length; ++i)
    {
        float alpha = [_alphaArray[i] floatValue];
        
        alpha = alpha < 0.0 ? 0.0 : alpha;
        alpha = alpha > 1.0 ? 1.0 : alpha;
        
        if (alpha != 1.0)
        {
            shouldRemoveTimer = NO;
        }
        
//        UIColor *letterColor = [UIColor colorWithWhite:1 alpha:alpha];
        UIColor *letterColor = [UIColor colorWithRed:0.897 green:0.817 blue:0.877 alpha:alpha];
        [self.attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                      value:(id)letterColor.CGColor
                                      range:NSMakeRange(i, 1)];
    }

    if (shouldRemoveTimer)
    {
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = nil;
    }
    
    //字体
    CTFontRef helveticaBold = CTFontCreateWithName(CFSTR("TimesNewRomanPS-ItalicMT"), 20.0, NULL);
    [self.attributedString addAttribute:(NSString *)kCTFontAttributeName
                                  value:(__bridge id)helveticaBold
                                  range:NSMakeRange(0, self.text.length)];
    
    NSMutableArray *tAlpha = [NSMutableArray array];
    for (int i = 0; i < _alphaArray.count; ++i)
    {
        float newAlpha = [_alphaArray[i] floatValue] + (1.0 / 40);
        
        [tAlpha addObject:@(newAlpha)];
    }
    
    _alphaArray = tAlpha;
    
    self.string = (id)self.attributedString;
}

- (void)setupAlphaArray
{
    [_alphaArray removeAllObjects];
    
    for (int i = 0; i < self.text.length; ++i)
    {
        [_alphaArray addObject:@(MAXFLOAT)];
    }
    
    [self randomAlphaArray];
}

- (void)randomAlphaArray
{
    NSUInteger totalCount = self.text.length;
    NSUInteger tTotalCount = totalCount;
    [_tmpArray removeAllObjects];
    
    for (int i = 0; i < _numberOfLayers - 1; ++i)
    {
        int k = arc4random() % tTotalCount;
        [_tmpArray addObject:@(k)];
        tTotalCount -= k;
    }
     [_tmpArray addObject:@(tTotalCount)];
    
    
    for (id value in _tmpArray)
    {
        NSLog(@"%@", value);
    }
    
    
    for (int i = 0; i < _numberOfLayers; ++i)
    {
        int count = [_tmpArray[i] intValue];
        CGFloat alpha = -(i * 0.25);
        while (count)
        {
            int k = arc4random() % totalCount;
            if ([_alphaArray[k] floatValue] > 0.0f)
            {
                _alphaArray[k] = @(alpha);
                count--;
            }
        }
    }
    
    for (id value in _alphaArray)
    {
        NSLog(@"%@", value);
    }
}

@end