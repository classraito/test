//
//  FGCircularUploadProgressView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircularUploadProgressView.h"
@interface FGCircularUploadProgressView()
{
    BOOL isShowProcessBG;
    BOOL isShowProcess;
}
@end

@implementation FGCircularUploadProgressView
@synthesize iv_uploading;
@synthesize view_mask;
@synthesize lb_title;
@synthesize processPercent;
@synthesize status;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:iv_uploading];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:view_mask];
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
    
    iv_uploading.layer.borderColor = [UIColor clearColor].CGColor;
    iv_uploading.layer.cornerRadius = iv_uploading.frame.size.width / 2;
    iv_uploading.layer.borderWidth = 0;
    iv_uploading.layer.masksToBounds = YES;
    
    view_mask.layer.borderColor = [UIColor clearColor].CGColor;
    view_mask.layer.cornerRadius = view_mask.frame.size.width / 2;
    view_mask.layer.borderWidth = 0;
    view_mask.layer.masksToBounds = YES;
    
    view_mask.hidden = YES;
    
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    [self drawCircular:context];
}

-(void)drawCircular:(CGContextRef)context
{//画圆和椭圆
    float padding = 5 * ratioW;
    
    CGContextSetLineWidth(context, padding );
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(isShowProcessBG)
    {
        CGContextSetRGBStrokeColor(context, .9 , .9, .9,1);
        CGContextAddArc(context, self.frame.size.width / 2 ,self.frame.size.height / 2, (self.frame.size.width - padding)/2  , degreesToRadian(0), degreesToRadian(360), 1);
        CGContextStrokePath(context);
    }
    
    if(isShowProcess)
    {
        
        CGContextSetRGBStrokeColor(context, 94.0 / 255.0 , 190.0 / 255.0, 156.0 / 255.0, 1);
        CGContextAddArc(context, self.frame.size.width / 2 ,self.frame.size.height / 2, (self.frame.size.width - padding)/2  , degreesToRadian(-90), degreesToRadian(-360.0f * processPercent - 90), 0);
        CGContextStrokePath(context);
    }
}

-(void)setStatusToNotLoading
{
    status = CircularUploadButtonStatus_NotUploading;
    isShowProcessBG = NO;
    isShowProcess = NO;
    [self setNeedsDisplay];
    iv_uploading.hidden = YES;
    lb_title.hidden = NO;
}

-(void)setStatusToUpLoading
{
    status = CircularUploadButtonStatus_Uploading;
    isShowProcessBG = YES;
    isShowProcess = YES;
    [self setNeedsDisplay];
    iv_uploading.hidden = NO;
    lb_title.hidden = NO;
}

-(void)setStatusToShowText
{
    status = CircularUploadButtonStatus_NotUploading;
    isShowProcessBG = NO;
    isShowProcess = NO;
    [self setNeedsDisplay];
    iv_uploading.hidden = YES;
    lb_title.hidden = NO;
}


-(void)dealloc
{
    
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
