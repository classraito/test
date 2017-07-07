//
//  FGPaymentRequestAcceptedPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentRequestAcceptedPopView.h"

@implementation FGPaymentRequestAcceptedPopView
@synthesize view_whiteBg;
@synthesize lb_title;
@synthesize lb_subTitle;
@synthesize iv_trainerThumbnail;
@synthesize lb_trainerName;
@synthesize queueView_rating;
@synthesize btn_pay1Session;
@synthesize btn_cancelRequest;
@synthesize view_bundleBg;
@synthesize lb_title_bundle;
@synthesize lb_subtitle_bundle;
@synthesize btn_go2PayBundle;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    
    [commond useDefaultRatioToScaleView:view_whiteBg];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subTitle];
    [commond useDefaultRatioToScaleView:iv_trainerThumbnail];
    [commond useDefaultRatioToScaleView:lb_trainerName];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:btn_pay1Session];
    [commond useDefaultRatioToScaleView:btn_cancelRequest];
    [commond useDefaultRatioToScaleView:view_bundleBg];
    [commond useDefaultRatioToScaleView:lb_title_bundle];
    [commond useDefaultRatioToScaleView:lb_subtitle_bundle];
    [commond useDefaultRatioToScaleView:btn_go2PayBundle];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 18);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 16);
    lb_trainerName.font = font(FONT_TEXT_REGULAR, 16);
    btn_pay1Session.titleLabel.font = font(FONT_TEXT_BOLD, 18);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    lb_title_bundle.font = font(FONT_TEXT_REGULAR, 18);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 16);
    btn_go2PayBundle.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    
    [self setupRating];
    
    iv_trainerThumbnail.layer.cornerRadius = iv_trainerThumbnail.frame.size.width / 2;
    iv_trainerThumbnail.layer.masksToBounds = YES;
  
    
    NSString *_str_pay1Session = multiLanguage(@"PAY 1 SESSION");
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateNormal];
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateHighlighted];
    
    NSString *_str_cancelRequest = multiLanguage(@"CANCEL REQUEST");
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateHighlighted];
    
    lb_title.text = multiLanguage(@"Bang!");
    lb_subTitle.text = multiLanguage(@"We have a trainer ready for you. Confirm your single training session.");
    lb_title_bundle.text = multiLanguage(@"Buy 10 sessions and get 1 session free!");
    lb_subtitle_bundle.text = multiLanguage(@"Your booking has been confirmed. Get ready to sweat! You can view the details in ‘My Booking’.");
    
    NSString *_str_bundlePrice = @"￥3000";
    [btn_go2PayBundle setTitle:_str_bundlePrice forState:UIControlStateNormal];
    [btn_go2PayBundle setTitle:_str_bundlePrice forState:UIControlStateHighlighted];
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
    NSString *_str_trainerName =  [paymentModel.dic_acceptedTrainerInfo objectForKey:@"UserName"];
    
    lb_trainerName.text = _str_trainerName;
    NSString *_str_trainerThumbnailUrl = [paymentModel.dic_acceptedTrainerInfo objectForKey:@"UserIcon"];
    
    [iv_trainerThumbnail sd_setImageWithURL:[NSURL URLWithString:_str_trainerThumbnailUrl] placeholderImage:IMG_PLACEHOLDER];
    
    int rating = [[paymentModel.dic_acceptedTrainerInfo objectForKey:@"Rating"] intValue];
    [queueView_rating updateHighliteByCount:rating];
    
    paymentModel.str_trainerName = _str_trainerName;
    paymentModel.str_trainerThumbnailUrl = _str_trainerThumbnailUrl;
    paymentModel.trainerRating = rating;
    
    
    NSString *_str_pay1Session = [NSString stringWithFormat:@"%@ %d %@ ￥%.2f",multiLanguage(@"PAY"),paymentModel.sessionCount,multiLanguage(@"SESSION"),paymentModel.oneSessionPrice];
    NSLog(@"paymentModel.sessionCount = %d",paymentModel.sessionCount);
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateNormal];
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateHighlighted];
    
    if(paymentModel.arr_bundleLessons && [paymentModel.arr_bundleLessons count ]> 0)
    {
        lb_title_bundle.text = [[paymentModel.arr_bundleLessons objectAtIndex:0] objectForKey:@"BundleName"];
        NSLog(@":::::>从服务器获得课程卡 名称:%@",lb_title_bundle.text);
        NSString *_str_bundlePrice = [[paymentModel.arr_bundleLessons objectAtIndex:0] objectForKey:@"BundlePrice"];
        [btn_go2PayBundle setTitle:[NSString stringWithFormat:@"￥%@",_str_bundlePrice] forState:UIControlStateNormal];
        [btn_go2PayBundle setTitle:[NSString stringWithFormat:@"￥%@",_str_bundlePrice] forState:UIControlStateHighlighted];
    }
    
}
@end
