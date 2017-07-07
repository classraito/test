//
//  FGCircularWithProcessingButton.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircularWithProcessingButton.h"
#import "Global.h"
@interface FGCircularWithProcessingButton()
{
    BOOL isShowProcessBG;
    BOOL isShowProcess;
}
@end

@implementation FGCircularWithProcessingButton
@synthesize iv_play;
@synthesize iv_download;
@synthesize btn_download_play;
@synthesize processPercent;
@synthesize status;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [commond useDefaultRatioToScaleView:iv_play];
    [commond useDefaultRatioToScaleView:iv_download];
    [commond useDefaultRatioToScaleView:btn_download_play];
    
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = YES;
    
    self.view_content.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor = self.view_content.backgroundColor;
    
    processPercent = 0;
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
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
        CGContextSetRGBStrokeColor(context, 1 , 1, 1, 1);
        CGContextAddArc(context, self.frame.size.width / 2 ,self.frame.size.height / 2, (self.frame.size.width - padding)/2  , degreesToRadian(0), degreesToRadian(360), 1);
        CGContextStrokePath(context);
    }
   
    if(isShowProcess)
    {
        CGContextSetRGBStrokeColor(context, 64.0 / 255.0 , 162.0 / 255.0, 158.0 / 255.0, 1);
        CGContextAddArc(context, self.frame.size.width / 2 ,self.frame.size.height / 2, (self.frame.size.width - padding)/2  , degreesToRadian(-90), degreesToRadian(-360.0f * processPercent - 90), 0);
        CGContextStrokePath(context);
    }
}

-(void)setStatusToReadyToPlay
{
    status = ProcessingButtonStatus_ReadyToPlay;
    isShowProcessBG = NO;
    isShowProcess = NO;
    [self setNeedsDisplay];
    iv_download.hidden = YES;
    iv_play.hidden = NO;
}

-(void)setStatusToNotDownload
{
    status = ProcessingButtonStatus_NotDownload;
    isShowProcessBG = NO;
    isShowProcess = NO;
    [self setNeedsDisplay];
    iv_download.hidden = NO;
    iv_download.highlighted = NO;
    iv_play.hidden  = YES;
}

-(void)setStatusToDownloading
{
    status = ProcessingButtonStatus_Downloading;
    isShowProcessBG = YES;
    isShowProcess = YES;
    [self setNeedsDisplay];
    iv_download.hidden = NO;
    iv_download.highlighted = YES;
    iv_play.hidden  = YES;
}
@end
