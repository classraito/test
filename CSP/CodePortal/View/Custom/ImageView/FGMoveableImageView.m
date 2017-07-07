//
//  FGMoveableImageView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/2.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMoveableImageView.h"
#import "Global.h"
@interface FGMoveableImageView()
{
    CGPoint lastLocation;
    CGFloat lastRotation;
}
@end

@implementation FGMoveableImageView
-(id)initWithImage:(UIImage *)image
{
    if(self = [super initWithImage:image])
    {
        [self internalInital];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self internalInital];
    }
    return self;
}

-(void)internalInital
{
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_rotationImage:)];
    rotation.delegate = self;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_pinchImage:)];
    pinch.delegate = self;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesture_panImage:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_tapImage:)];
    pan.delegate = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_doubleTapImage:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:rotation];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:doubleTap];
    [self setUserInteractionEnabled:YES];
}

-(void)gesture_rotationImage:(UIRotationGestureRecognizer * )gesture
{
    [self.superview bringSubviewToFront:self];
    
    if(gesture.numberOfTouches <= 1)
        return;
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        lastRotation = gesture.rotation;
    }
    else if ([gesture state] == UIGestureRecognizerStateChanged)
    {
        CGAffineTransform currentTransform = self.transform;
        CGFloat rotation = 0.0 - (lastRotation - gesture.rotation);
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
        self.transform = newTransform;
        lastRotation = gesture.rotation;
    }
}

-(void)gesture_pinchImage:(UIPinchGestureRecognizer * )gesture
{
    if(gesture.numberOfTouches <= 1)
        return;
    [self.superview bringSubviewToFront:self];
    
    if([gesture state] == UIGestureRecognizerStateChanged)
    {
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
    
}

-(void)gesture_panImage:(UIPanGestureRecognizer * )gesture
{
    [self.superview bringSubviewToFront:self];
    
    if(gesture.numberOfTouches > 1)
        return;
    
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        lastLocation = [gesture locationInView:self.superview];
    }
    else if([gesture state] == UIGestureRecognizerStateChanged)
    {
        CGPoint location = [gesture locationInView:self.superview];
        CGFloat dx = location.x - lastLocation.x;
        CGFloat dy = location.y - lastLocation.y;
        
        self.center = CGPointMake(self.center.x + dx,  self.center.y + dy);
        lastLocation = location;
    }
}

-(void)gesture_tapImage:(UITapGestureRecognizer *)gesture
{
    if(gesture.numberOfTouches > 1)
        return;
    
    [self.superview bringSubviewToFront:self];
}

-(void)gesture_doubleTapImage:(UITapGestureRecognizer *)gesture
{
    if(gesture.numberOfTouches > 1)
        return;
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  NO;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
