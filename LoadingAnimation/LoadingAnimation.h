//
//  LoadingAnimation.h
//  LoadingAnimation
//
//  Created by 换一换 on 16/2/26.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingAnimation : UIView
{
    
    UIImageView *_shapeView;
    
    UIImageView *_shadowView;
    
    
    float _toValue;
    float _fromValue;
    
    
    float _scaleToValue;
    float _scaleFromValue;
    
    
    
    
    
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

-(void)loadUI;

-(void)startAnimation;

-(void)stopAnimation;

@end
