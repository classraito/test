//
//  HSCButton.m
//
//
//  Created by rui.gong on 12-7-20.
//  Copyright (c) 2015年 fugumobile. All rights reserved.
//

#import "HSCButton.h"

@implementation HSCButton
@synthesize delegate;
@synthesize dragEnable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
    offsetY = 0;
    if(delegate && [delegate respondsToSelector:@selector(HSCButtonDidTouchBegan:)])
    {
        [delegate HSCButtonDidTouchBegan:offsetX];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
//     offsetY = nowPoint.y - beginPoint.y;
    offsetX = nowPoint.x - beginPoint.x;
    if(delegate && [delegate respondsToSelector:@selector(HSCButtonDidTouchMoved:)])
    {
        [delegate HSCButtonDidTouchMoved:offsetX];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    if(delegate && [delegate respondsToSelector:@selector(HSCButtonDidTouchCanceled:)])
    {
        [delegate HSCButtonDidTouchCanceled:offsetX];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [self touchesEnded:touches withEvent:event];
}
@end
