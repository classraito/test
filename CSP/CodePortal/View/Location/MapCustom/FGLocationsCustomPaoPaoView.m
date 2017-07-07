//
//  FGLocationsCustomPaoPaoView.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/1.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGLocationsCustomPaoPaoView.h"
#import "Global.h"
@interface FGLocationsCustomPaoPaoView()
{
   
}
@end

@implementation FGLocationsCustomPaoPaoView
@synthesize iv_bg;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize lb_description;
@synthesize view_seperatorLine_h;
@synthesize cb_go2Detail;
@synthesize iv_thumbnail;
@synthesize str_id;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_bg];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:lb_description];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_seperatorLine_h];
    [commond useDefaultRatioToScaleView:cb_go2Detail];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 12);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 12);
    lb_description.font = font(FONT_TEXT_REGULAR, 12);
    
    [cb_go2Detail setFrame:cb_go2Detail.frame title:multiLanguage(@"DETAIL") arrimg:nil thumb:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel padding:0 font:font(FONT_TEXT_BOLD, 18) needTitleLeftAligment:NO needIconBesideLabel:NO];
    cb_go2Detail.layer.cornerRadius = 4;
    cb_go2Detail.layer.masksToBounds = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_id = nil;
}

-(void)bindDataToUI_gym:(NSMutableDictionary *)_dic_info
{
    NSLog(@"_dic_info = %@",_dic_info);
   // lb_title.text = [_dic_info objectForKey:@"ScreenName"];
   // lb_subtitle.text = [_dic_info objectForKey:@"Open"];
  //  lb_description.text = [_dic_info objectForKey:@"Address"];
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:[_dic_info objectForKey:@"Thumbnail"]] placeholderImage:IMG_PLACEHOLDER];
    str_id = [_dic_info objectForKey:@"GymId"];
    
    NSString *_str_screenName = [_dic_info objectForKey:@"ScreenName"];
    NSString *_str_screenTime = [_dic_info objectForKey:@"ScreenTime"];
    NSString  *_str_location = [_dic_info objectForKey:@"Location"];
    
    lb_title.text = [NSString stringWithFormat:@"%@\n%@\n%@",_str_screenName,_str_screenTime,_str_location];
    
    [lb_title setCustomColor:[UIColor blackColor] searchText:_str_screenName font:font(FONT_TEXT_REGULAR, 14)];
}

-(void)bindDataToUI_group:(NSMutableDictionary *)_dic_info
{
  //  lb_title.text = [_dic_info objectForKey:@"ScreenName"];
   // lb_subtitle.text = [_dic_info objectForKey:@"ScreenTime"];
  //  lb_description.text = [_dic_info objectForKey:@"Location"];
    iv_thumbnail.image = [UIImage imageNamed:@"QuoteDesigns12.png"];
    str_id = [_dic_info objectForKey:@"GroupId"];
    
    NSString *_str_screenName = [_dic_info objectForKey:@"ScreenName"];
    NSString *_str_screenTime = [_dic_info objectForKey:@"ScreenTime"];
    NSString  *_str_location = [_dic_info objectForKey:@"Location"];
    
    lb_title.text = [NSString stringWithFormat:@"%@\n%@\n%@",_str_screenName,_str_screenTime,_str_location];
    
    [lb_title setCustomColor:[UIColor blackColor] searchText:_str_screenName font:font(FONT_TEXT_REGULAR, 14)];
    
    
}
@end
