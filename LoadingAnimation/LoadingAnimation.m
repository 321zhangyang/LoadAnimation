//
//  LoadingAnimation.m
//  LoadingAnimation
//
//  Created by 换一换 on 16/2/26.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import "LoadingAnimation.h"
@interface LoadingAnimation ()
@property (nonatomic, assign) int stepNumber;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *titleString;

@end

@implementation LoadingAnimation

#define ANIMATION_DURATION_SECS 0.5f

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleString = title;
        
        [self loadUI];
    }
    return self;
}


-(void)loadUI
{
    
    _shapeView=[[UIImageView alloc] init];
    _shapeView.frame=CGRectMake(self.frame.size.width/2-31/2, 0, 31, 31);
    _shapeView.image=[UIImage imageNamed:@"loading_circle"];
    _shapeView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:_shapeView];
    
    
    //阴影
    _shadowView=[[UIImageView alloc] init];
    _shadowView.frame=CGRectMake(self.frame.size.width/2-37/2, self.frame.size.height-2.5-30, 37, 2.5);
    _shadowView.image=[UIImage imageNamed:@"loading_shadow"];
    [self addSubview:_shadowView];
    
    
    //
    UILabel *_label=[[UILabel alloc] init];
    _label.frame=CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
    _label.textColor=[UIColor grayColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text=_titleString;
    _label.font=[UIFont systemFontOfSize:13.0f];
    
    [self addSubview:_label];
    
    
    _fromValue = _shapeView.frame.size.height / 2;
    _toValue = self.frame.size.height - 30 - _shapeView.frame.size.height/2 - _shadowView.frame.size.height;
    
    _scaleFromValue = 0.3f;
    _scaleToValue = 1.0f;
    
    self.alpha = 0;
    
    
}

-(void)startAnimation
{
    if (!_isAnimating) {
        _isAnimating = YES;
        
        self.alpha = 1;
        
        //添加计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION_SECS target:self selector:@selector(animationBeat) userInfo:nil repeats:YES];
    }
}

-(void)stopAnimation
{
    _isAnimating = NO;
    
    //停止计时器
    [_timer invalidate];
    
    _stepNumber = 0;
    
    self.alpha = 0;
    
    //移除动画
    [_shapeView.layer removeAllAnimations];
    
    [_shadowView.layer removeAllAnimations];
    
    _shapeView.image = [UIImage imageNamed:@"loading_circle"];
    
}


-(void)animationBeat
{
    switch (_stepNumber) {
        case 0:
        {
            _shapeView.image = [UIImage imageNamed:@"loading_circle"];
            
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            [self scaleAnimation:_scaleFromValue toValue:_scaleToValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
        }
            break;
        case 1:
        {
            
            _shapeView.image = [UIImage imageNamed:@"loading_square"];
            
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            [self scaleAnimation:_scaleToValue toValue:_scaleFromValue timingFunction:kCAMediaTimingFunctionEaseIn];
    
            
        }
            break;
        case 2:
        {
            _shapeView.image = [UIImage imageNamed:@"loading_square"];
            
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            [self scaleAnimation:_scaleFromValue toValue:_scaleToValue timingFunction:kCAMediaTimingFunctionEaseIn];
        }
            break;
        case 3:
        {
            _shapeView.image = [UIImage imageNamed:@"loading_triangle"];
            
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            
            [self scaleAnimation:_scaleToValue toValue:_scaleFromValue timingFunction:kCAMediaTimingFunctionEaseIn];
        }
            break;
            
         case 4:
        {
            _shapeView.image = [UIImage imageNamed:@"loading_triangle"];
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            [self scaleAnimation:_scaleFromValue toValue:_scaleToValue timingFunction:kCAMediaTimingFunctionEaseIn];
        }
            break;
            
        case 5:
            
        {
            _shapeView.image = [UIImage imageNamed:@"loading_circle"];
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            [self scaleAnimation:_scaleToValue toValue:_scaleFromValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            _stepNumber = -1;
        }
            
            
        default:
            break;
    }
    _stepNumber ++ ;
}


//动画效果

-(void)loadingAnimation:(float)fromValue toValue:(float)toValue timingFunction:(NSString * const)tf
{
    
    //位置
    CABasicAnimation *panAnimation = [CABasicAnimation animation];
    panAnimation.keyPath = @"position.y";
    panAnimation.fromValue = @(fromValue);
    panAnimation.toValue = @(toValue);
    panAnimation.duration = ANIMATION_DURATION_SECS;
    
    panAnimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    
    //旋转
    CABasicAnimation *ranAnimation = [CABasicAnimation animation];
    ranAnimation.keyPath = @"transform.rotation";
    ranAnimation.fromValue = @(0);
    ranAnimation.toValue = @(M_PI_2);
    ranAnimation.duration = ANIMATION_DURATION_SECS;
    
    ranAnimation.timingFunction= [CAMediaTimingFunction functionWithName:tf];
    
    
    //组合
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[panAnimation,ranAnimation];
    group.duration = ANIMATION_DURATION_SECS;
    group.beginTime = 0;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [_shapeView.layer addAnimation:group forKey:@"basic"];
    
    
    
}

-(void)scaleAnimation:(float)fromeValue toValue:(float)toValue
       timingFunction:(NSString *const)tf
{
    //缩放
    CABasicAnimation *sanimation = [CABasicAnimation animation];
    sanimation.keyPath = @"tranform.scale";
    sanimation.fromValue = @(fromeValue);
    sanimation.toValue = @(toValue);
    sanimation.duration = ANIMATION_DURATION_SECS;
    
    sanimation.fillMode = kCAFillModeForwards;
    sanimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    sanimation.removedOnCompletion = NO;
    
    [_shadowView.layer addAnimation:sanimation forKey:@"shadow"];
    
    
}

-(BOOL)isAnimating
{
    return _isAnimating;
}





@end
