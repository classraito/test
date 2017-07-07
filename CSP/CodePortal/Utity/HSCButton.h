//
//  HSCButton.m
//
//
//  Created by rui.gong on 12-7-20.
//  Copyright (c) 2015年 fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HSCButtonDelegate<NSObject>
-(void)HSCButtonDidTouchBegan:(CGFloat)_offsetX;
-(void)HSCButtonDidTouchMoved:(CGFloat)_offsetX;
-(void)HSCButtonDidTouchCanceled:(CGFloat)_offsetX;
@end

@interface HSCButton : UIButton
{
    CGPoint beginPoint;
    float offsetY;
    float offsetX;
}
@property(nonatomic,assign)id<HSCButtonDelegate>delegate;
@property (nonatomic) BOOL dragEnable;
@end
