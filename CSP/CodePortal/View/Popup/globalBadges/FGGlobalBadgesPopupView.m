//
//  FGGlobalBadgesPopupView.m
//  CSP
//
//  Created by Ryan Gong on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGGlobalBadgesPopupView.h"
#import "Global.h"
@implementation FGGlobalBadgesPopupView
@synthesize iv_badgeThumbnail;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize cub_shareNow;
@synthesize btn_seeMyBadges;
@synthesize iv_close;
@synthesize btn_close;
@synthesize view_badgesBG;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Do any additional setup after loading the view from its nib.
    self.view_bg.backgroundColor = [UIColor whiteColor];
    [commond useDefaultRatioToScaleView:iv_badgeThumbnail];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:cub_shareNow];
    [commond useDefaultRatioToScaleView:btn_seeMyBadges];
    [commond useDefaultRatioToScaleView:iv_close];
    [commond useDefaultRatioToScaleView:btn_close];
    [commond useDefaultRatioToScaleView:view_badgesBG];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    
    lb_title.font = font(FONT_TEXT_BOLD, 20);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
    
    [cub_shareNow setupStyleWithButtonColor:[UIColor blackColor] underlineColor:[UIColor blackColor]];
    [cub_shareNow.btn setTitle:multiLanguage(@"SHARE NOW") forState:UIControlStateNormal];
    [cub_shareNow.btn setTitle:multiLanguage(@"SHARE NOW") forState:UIControlStateHighlighted];
    
    [btn_seeMyBadges setTitle:multiLanguage(@"SEE MY BADGES") forState:UIControlStateNormal];
    [btn_seeMyBadges setTitle:multiLanguage(@"SEE MY BADGES") forState:UIControlStateHighlighted];
    
    [btn_seeMyBadges addTarget:self action:@selector(buttonAction_seeMyBadges:) forControlEvents:UIControlEventTouchUpInside];
    [cub_shareNow.btn addTarget:self action:@selector(buttonAction_shareNow:) forControlEvents:UIControlEventTouchUpInside];
    

    view_badgesBG.layer.shadowColor = [UIColor blackColor].CGColor;
    view_badgesBG.layer.shadowOpacity = .4;
    view_badgesBG.layer.shadowRadius = 10;
    view_badgesBG.layer.shadowOffset = CGSizeMake(1, 1);
    
    self.view_bg.backgroundColor = [UIColor clearColor];
    
    iv_badgeThumbnail.layer.cornerRadius = iv_badgeThumbnail.frame.size.width / 2;
    iv_badgeThumbnail.layer.masksToBounds = YES;
}

-(void)updateBadgesPopup:(id)_sender
{
    
    NSString *str_thumbnail = [_sender objectForKey:@"Thumbnail"];
    NSString *str_brief = [_sender objectForKey:@"Brief"];
    NSString *str_description = [_sender objectForKey:@"Description"];
    NSString *str_boxColor = [_sender objectForKey:@"BoxColor"];
    NSString *str_buttonColor = [_sender objectForKey:@"ButtonColor"];
    view_badgesBG.backgroundColor = [UIColor colorWithHexString:str_boxColor];
    self.btn_seeMyBadges.backgroundColor = [UIColor colorWithHexString:str_buttonColor];
    [iv_badgeThumbnail sd_setImageWithURL:[NSURL URLWithString:str_thumbnail]];
    lb_title.text = str_brief;
    lb_subtitle.text = str_description;
}



-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    vc_popup = nil;
}


-(void)buttonAction_shareNow:(id)_sender
{
    [self closePopup];
    //TODO: add share
}

-(void)buttonAction_seeMyBadges:(id)_sender;
{
    NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    FGMyBadgesViewController *vc_badges = [[FGMyBadgesViewController alloc] initWithNibName:@"FGMyBadgesViewController" bundle:nil withId:_str_id];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushController:vc_badges navigationController:nav_current];//TODO: 如果nav_current上有 present的界面 可能有问题
}

-(IBAction)buttonAction_close:(id)_sender;
{
    [self closePopup];
}
@end
