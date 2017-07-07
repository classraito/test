//
//  FGWriteFeedBackView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWriteFeedBackView.h"
#import "Global.h"
@implementation FGWriteFeedBackView
@synthesize iv_trainerThumbnail;
@synthesize queueView_rating;
@synthesize tv_feedback;
@synthesize btn_sendFeedback;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_trainerThumbnail];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:tv_feedback];
    [commond useDefaultRatioToScaleView:btn_sendFeedback];
    
    [self setupRating];
    
    tv_feedback.font = font(FONT_TEXT_REGULAR, 18);
    
}

-(void)setupRating
{
    NSMutableArray *_arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
    NSMutableArray *_arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
    CGRect imgBounds = CGRectMake(0, 0, 16 * ratioW, 16 * ratioH);
    [queueView_rating initalQueueByImageNames:_arr_imgs highlightedImageNames:_arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
