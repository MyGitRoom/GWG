//
//  MyView.m
//  UI进阶分享引导图
//
//  Created by lanou on 17/3/24.
//  Copyright © 2017年 lanou. All rights reserved.
//

#import "MyView.h"

@implementation MyView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame] ;
    if ( self ) {
        _sc = [[UIScrollView alloc]init];
        _imageV = [[UIImageView alloc]init];
        _imageV2 = [[UIImageView alloc]init];
        
        [self addSubview: _sc];
        [self addSubview:_imageV];
        [self addSubview:_imageV2];
        
    }

    return self ;

    

}

-(void)layoutSubviews{
    [super layoutSubviews];

    _sc.frame = CGRectMake(0, 0, Width, Height);

    
    _sc.contentSize = CGSizeMake(Width*3,Height);
    
    _sc.bounces = NO ;// 取消反弹
    
    
    //建立imageView
    
    
    for (int i = 0 ; i<2; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(Width*i, 0, Width,Height)];
        [_sc addSubview:imageV];
        //添加图片
        UIImage *image= [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        imageV.image = image ;
        
    }

    
    //裁剪图片
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(Width*2, 0, Width, Height/2)] ;
    _imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(Width*2, Height/2, Width, Height/2)];
    
    [_sc  addSubview:_imageV];
        [_sc  addSubview:_imageV2];
//图片
    UIImage *image = [UIImage imageNamed:@"3"];
    CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width, image.size.height/2));
    CGImageRef ref2 = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, image.size.height/2, image.size.width, image.size.height/2));
    _imageV.image = [UIImage imageWithCGImage:ref];
    _imageV2.image = [UIImage imageWithCGImage:ref2];
    
    //创建按钮跳转到界面
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(150+Width*2, 500, 120,40);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(enterinterface) forControlEvents:UIControlEventTouchUpInside ];
    
    [_sc addSubview:button];
    _sc.pagingEnabled = YES ;

}

-(void)enterinterface {
  [UIView animateWithDuration:0.5 animations:^{
      _imageV.transform = CGAffineTransformMakeTranslation(0, -Height/2) ;
      _imageV2.transform = CGAffineTransformMakeTranslation(0, Height/2);
      
      
  } completion:^(BOOL finished) {
      //添加标记
      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      [user setValue:@"you" forKey:@"标记"];
      
      [self removeFromSuperview];
  }];
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
