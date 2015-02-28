//
//  UIVIewSpringEffect.m
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/5.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "UIVIewSpringEffect.h"

@interface UIVIewSpringEffect ()
@property (assign, nonatomic) CGFloat yend;
@end

@implementation UIVIewSpringEffect
- (void)startSpringWithEndFrame:(CGRect)frame{
//    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"springEffect"];
////    keyFrame.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionTranslateY];
//    keyFrame.values = @[@100,@20,@0];
//    keyFrame.keyTimes = @[@(0.25),@(0.1),@(0.01)];
//    keyFrame.duration = 0.36;
//    [self.layer addAnimation:keyFrame forKey:@"springEffect"];
    
//    NSValue * from = [NSNumber numberWithFloat:self.layer.position.y];
//    NSArray * vias = @[@200,@160,@180];
//    NSValue * to = [NSNumber numberWithFloat:200];
//    CAKeyframeAnimation *ani = [self keyframeBounceAnimationFrom:from via:vias to:to forKeypath:@"position.y" withDuration:0.6];
//    [self.layer addAnimation:ani forKey:@"spring"];
    CGFloat yend = CGRectGetMidY(frame);
    CGFloat x = self.layer.position.x;
    CGFloat ystart = self.layer.position.y;//90
    CGFloat y1 = yend - (yend-ystart)/3;
    CGFloat y2 = yend - (yend - ystart)/5;
    _yend = yend;
    CGMutablePathRef starPath = CGPathCreateMutable();
    CGPathMoveToPoint(starPath,NULL,x, yend);
    CGPathAddLineToPoint(starPath, NULL, x, y1);
    CGPathAddLineToPoint(starPath, NULL, x, y2);
    CGPathAddLineToPoint(starPath, NULL, x, yend);
    CGPathCloseSubpath(starPath);
    
    CAKeyframeAnimation *animation = nil;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:.3f];
    [animation setDelegate:self];
    [animation setPath:starPath];
//    animation.keyTimes = @[@0.4,@0.3,@0.2,@0.1];

    animation.removedOnCompletion = NO;
    CFRelease(starPath);
    starPath = nil;
    [self.layer addAnimation:animation forKey:@"position"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.layer.position = CGPointMake(self.layer.position.x, _yend);
}
-(void)animateGreenBall
{
//    NSValue * from = [NSNumber numberWithFloat:self.layer.position.y];
//    CGFloat bounceDistance = 20.0;
//    CGFloat direction = (greenUp? 1 : -1);
//    
//    NSValue * via = [NSNumber numberWithFloat:(greenUp ? HEIGHT_DOWN : HEIGHT_UP) + direction*bounceDistance];
//    NSValue * to = greenUp ? [NSNumber numberWithFloat:HEIGHT_DOWN] : [NSNumber numberWithFloat:HEIGHT_UP];
//    NSString * keypath = @"position.y";
//    [greenBall.layer addAnimation:[self keyframeBounceAnimationFrom:from via:via to:to forKeypath:keypath withDuration:.6] forKey:@"bounce"];
//    [greenBall.layer setValue:to forKeyPath:keypath];
//    greenUp = !greenUp;
}

-(CAKeyframeAnimation *)keyframeBounceAnimationFrom:(NSValue *)from
                                                via:(NSArray *)via
                                                 to:(NSValue *)to
                                         forKeypath:(NSString *)keyPath
                                       withDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    NSMutableArray *mut = [[NSMutableArray alloc] initWithArray:via];
    [mut insertObject:from atIndex:0];
    [mut addObject:to];
    [animation setValues:@[@200,@50]];
    [animation setKeyTimes:@[@0.3,@0.2]];
//    animation.removedOnCompletion = NO;
//     [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:.7], [NSNumber numberWithFloat:1.0], nil]];
    
    animation.duration = duration;
    return animation;
}
@end
