//
//  FGBookSucessPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookSucessPopView.h"
#import "Global.h"
@implementation FGBookSucessPopView
@synthesize view_whiteBG;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize iv_trainerThumbnail;
@synthesize lb_trainerName;
@synthesize queueView_rating;
@synthesize btn_done;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_whiteBG];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:iv_trainerThumbnail];
    [commond useDefaultRatioToScaleView:lb_trainerName];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:btn_done];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.numberOfLines = 0;
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 18);
    lb_trainerName.font = font(FONT_TEXT_REGULAR, 16);
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    [self setupRating];
    
    lb_title.text = multiLanguage(@"Bang!");
    lb_subtitle.text = multiLanguage(@"Your booking has been confirmed. Get ready to sweat! You can view the details in ‘My Booking’.");
    
    NSString *_str_done = multiLanguage(@"DONE");
    [btn_done setTitle:_str_done forState:UIControlStateNormal];
    [btn_done setTitle:_str_done forState:UIControlStateHighlighted];
    
    [self bindDataToUI];
}

-(void)setupRating
{
    NSMutableArray *_arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
    NSMutableArray *_arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
    CGRect imgBounds = CGRectMake(0, 0, 12 * ratioW, 12 * ratioH);
    [queueView_rating initalQueueByImageNames:_arr_imgs highlightedImageNames:_arr_imgs_highlighted padding:3 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)bindDataToUI
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    lb_trainerName.text = paymentModel.str_trainerName;
    [iv_trainerThumbnail sd_setImageWithURL:[NSURL URLWithString:paymentModel.str_trainerThumbnailUrl] placeholderImage:nil];
    [queueView_rating updateHighliteByCount:paymentModel.trainerRating];
}
@end
