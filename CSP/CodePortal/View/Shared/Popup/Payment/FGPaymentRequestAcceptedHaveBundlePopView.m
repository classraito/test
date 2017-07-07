//
//  FGPaymentRequestAcceptedHaveBundlePopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentRequestAcceptedHaveBundlePopView.h"
#import "Global.h"
@implementation FGPaymentRequestAcceptedHaveBundlePopView
@synthesize view_whiteBG;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize iv_trainerThumbnail;
@synthesize lb_trainerName;
@synthesize queueView_rating;
@synthesize btn_pay1Session;
@synthesize btn_payByBundle;
@synthesize btn_cancelRequest;
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
    [commond useDefaultRatioToScaleView:btn_pay1Session];
    [commond useDefaultRatioToScaleView:btn_payByBundle];
    [commond useDefaultRatioToScaleView:btn_cancelRequest];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 18);
    lb_trainerName.font = font(FONT_TEXT_REGULAR, 16);
    btn_pay1Session.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_payByBundle.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    [self setupRating];
    
    iv_trainerThumbnail.layer.cornerRadius = iv_trainerThumbnail.frame.size.width / 2;
    iv_trainerThumbnail.layer.masksToBounds = YES;
    
    lb_title.text = multiLanguage(@"Bang!");
    lb_subtitle.text = multiLanguage(@"Your booking has been confirmed. Get ready to sweat! You can view the details in ‘My Booking’.");
    lb_trainerName.text = @"username";
    
    NSString *_str_pay1Session = multiLanguage(@"PAY 1 SESSION");
    NSString *_str_payByBundle = multiLanguage(@"PAY BY BUNDLE");
    NSString *_str_cancelRequest = multiLanguage(@"CANCEL REQUEST");
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateNormal];
    [btn_pay1Session setTitle:_str_pay1Session forState:UIControlStateHighlighted];
    
    [btn_payByBundle setTitle:_str_payByBundle forState:UIControlStateNormal];
    [btn_payByBundle setTitle:_str_payByBundle forState:UIControlStateHighlighted];
    
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateHighlighted];
    
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
}
@end
