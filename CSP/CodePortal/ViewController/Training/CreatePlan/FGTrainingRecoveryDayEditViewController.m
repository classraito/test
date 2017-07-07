//
//  FGTrainingRecoveryDayEditViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingRecoveryDayEditViewController.h"
#import "Global.h"
@interface FGTrainingRecoveryDayEditViewController ()
{
    
}
@end

@implementation FGTrainingRecoveryDayEditViewController
@synthesize view_addWorkoutBG;
@synthesize view_otherChooseBG;
@synthesize lb_addOtherChoose;
@synthesize iv_black_plus;
@synthesize lb_chooseOther;

@synthesize view_bg_tennis;
@synthesize view_bg_badminton;
@synthesize view_bg_basketball;
@synthesize view_bg_running;
@synthesize view_bg_swimming;
@synthesize view_bg_soccer;
@synthesize view_bg_other;

@synthesize iv_tennis;
@synthesize iv_badminton;
@synthesize iv_basketball;
@synthesize iv_running;
@synthesize iv_swimming;
@synthesize iv_soccer;
@synthesize iv_other;

@synthesize lb_tennis;
@synthesize lb_badminton;
@synthesize lb_basketball;
@synthesize lb_running;
@synthesize lb_swimming;
@synthesize lb_soccer;
@synthesize lb_other;

@synthesize btn_tennis;
@synthesize btn_badminton;
@synthesize btn_basketball;
@synthesize btn_running;
@synthesize btn_swimming;
@synthesize btn_soccer;
@synthesize btn_other;

@synthesize btn_done;
@synthesize btn_addWorkout;

@synthesize sportsType;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"EDIT RECOVERY DAY");
    [self hideBottomPanelWithAnimtaion:NO];
    
    [commond useDefaultRatioToScaleView:view_addWorkoutBG];
    [commond useDefaultRatioToScaleView:view_otherChooseBG];
    [commond useDefaultRatioToScaleView:lb_addOtherChoose];
    [commond useDefaultRatioToScaleView:iv_black_plus];
    [commond useDefaultRatioToScaleView:lb_chooseOther];
    
    [commond useDefaultRatioToScaleView:view_bg_tennis];
    [commond useDefaultRatioToScaleView:view_bg_badminton];
    [commond useDefaultRatioToScaleView:view_bg_basketball];
    [commond useDefaultRatioToScaleView:view_bg_running];
    [commond useDefaultRatioToScaleView:view_bg_swimming];
    [commond useDefaultRatioToScaleView:view_bg_soccer];
    [commond useDefaultRatioToScaleView:view_bg_other];
    
    [commond useDefaultRatioToScaleView:iv_tennis];
    [commond useDefaultRatioToScaleView:iv_badminton];
    [commond useDefaultRatioToScaleView:iv_basketball];
    [commond useDefaultRatioToScaleView:iv_running];
    [commond useDefaultRatioToScaleView:iv_swimming];
    [commond useDefaultRatioToScaleView:iv_soccer];
    [commond useDefaultRatioToScaleView:iv_other];
    
    [commond useDefaultRatioToScaleView:lb_tennis];
    [commond useDefaultRatioToScaleView:lb_badminton];
    [commond useDefaultRatioToScaleView:lb_basketball];
    [commond useDefaultRatioToScaleView:lb_running];
    [commond useDefaultRatioToScaleView:lb_swimming];
    [commond useDefaultRatioToScaleView:lb_soccer];
    [commond useDefaultRatioToScaleView:lb_other];
    
    [commond useDefaultRatioToScaleView:btn_tennis];
    [commond useDefaultRatioToScaleView:btn_badminton];
    [commond useDefaultRatioToScaleView:btn_basketball];
    [commond useDefaultRatioToScaleView:btn_running];
    [commond useDefaultRatioToScaleView:btn_swimming];
    [commond useDefaultRatioToScaleView:btn_soccer];
    [commond useDefaultRatioToScaleView:btn_other];
    
    [commond useDefaultRatioToScaleView:btn_done];
    [commond useDefaultRatioToScaleView:btn_addWorkout];
    
    lb_addOtherChoose.font = font(FONT_TEXT_REGULAR, 14);
    lb_chooseOther.font = font(FONT_TEXT_REGULAR, 14);
    
    lb_tennis.font = font(FONT_TEXT_REGULAR, 14);
    lb_badminton.font = font(FONT_TEXT_REGULAR, 14);
    lb_basketball.font = font(FONT_TEXT_REGULAR, 14);
    lb_running.font = font(FONT_TEXT_REGULAR, 14);
    lb_swimming.font = font(FONT_TEXT_REGULAR, 14);
    lb_soccer.font = font(FONT_TEXT_REGULAR, 14);
    lb_other.font = font(FONT_TEXT_REGULAR, 14);
    
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_done.layer.cornerRadius = btn_done.frame.size.height / 2;
    btn_done.layer.masksToBounds = YES;
    btn_done.backgroundColor = color_red_panel;
    
    [self setCornerRadius:8 fromView:view_bg_tennis];
    [self setCornerRadius:8 fromView:view_bg_badminton];
    [self setCornerRadius:8 fromView:view_bg_basketball];
    [self setCornerRadius:8 fromView:view_bg_running];
    [self setCornerRadius:8 fromView:view_bg_swimming];
    [self setCornerRadius:8 fromView:view_bg_soccer];
    [self setCornerRadius:8 fromView:view_bg_other];
    
    lb_tennis.text = multiLanguage(@"Tennis");
    lb_badminton.text = multiLanguage(@"Badminton");
    lb_basketball.text = multiLanguage(@"Basketball");
    lb_running.text = multiLanguage(@"Running");
    lb_swimming.text = multiLanguage(@"Swimming");
    lb_soccer.text = multiLanguage(@"Soccer");
    lb_other.text = multiLanguage(@"Other");
    
    
    
    lb_addOtherChoose.text = multiLanguage(@"Add a workout");
    lb_chooseOther.text = multiLanguage(@"Or choose other sports you do today");
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - buttonAction
-(IBAction)buttonAction_go2AddWorkout:(id)_sender;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGTrainingSetPlanSelectWorkoutHomeViewController" inNavigation:nav_current];
}

-(IBAction)buttonAction_done:(id)_sender;
{
    
}

-(IBAction)buttonAction_clickOtherSports:(UIButton *)_sender;
{
    sportsType = (int)_sender.tag;
    [self resetAllSportsItem];
    NSString *_str_sportName = nil;
    NSString *_str_sportNameEn = nil;
    NSString *_str_sportThumbnailName = nil;
    switch (sportsType) {
        case SportsType_Tennis:
            [self highlightASportItem:view_bg_tennis iv:iv_tennis lb:lb_tennis];
            _str_sportName = lb_tennis.text;
            _str_sportNameEn = @"Tennis";
            _str_sportThumbnailName = @"tennis_green.png";
            break;
            
        case SportsType_Badminton:
            [self highlightASportItem:view_bg_badminton iv:iv_badminton lb:lb_badminton];
            _str_sportName = lb_badminton.text;
            _str_sportNameEn = @"Badminton";
            _str_sportThumbnailName = @"badmiton_green.png";
            break;
        case SportsType_Basketball:
            [self highlightASportItem:view_bg_basketball iv:iv_basketball lb:lb_basketball];
            _str_sportName = lb_basketball.text;
            _str_sportNameEn = @"Basketball";
            _str_sportThumbnailName = @"basketball_green.png";
            break;
        case SportsType_Running:
            [self highlightASportItem:view_bg_running iv:iv_running lb:lb_running];
            _str_sportName = lb_running.text;
            _str_sportNameEn = @"Running";
            _str_sportThumbnailName = @"running_green.png";
            break;
        case SportsType_Swimming:
            [self highlightASportItem:view_bg_swimming iv:iv_swimming lb:lb_swimming];
            _str_sportName = lb_swimming.text;
            _str_sportNameEn = @"Swimming";
            _str_sportThumbnailName = @"swimming_green.png";
            break;
        case SportsType_Soccer:
            [self highlightASportItem:view_bg_soccer iv:iv_soccer lb:lb_soccer];
            _str_sportName = lb_soccer.text;
            _str_sportNameEn = @"Soccer";
            _str_sportThumbnailName = @"soccer_green.png";
            break;
        case SportsType_Other:
            [self highlightASportItem:view_bg_other iv:iv_other lb:lb_other];
            _str_sportName = lb_other.text;
            _str_sportNameEn = @"Other";
            _str_sportThumbnailName = @"other_green.png";
            break;
    }
    
    NSMutableDictionary *_dic_singleDay = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_singleDay setObject:@"sport" forKey:@"TrainingId"];
    [_dic_singleDay setObject:_str_sportName forKey:@"ScreenName"];
    [_dic_singleDay setObject:_str_sportNameEn forKey:@"ScreenNameEN"];
    [_dic_singleDay setObject:_str_sportThumbnailName forKey:@"Thumbnail"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WORKOUT_SELECTED object:_dic_singleDay];
  
}

-(void)highlightASportItem:(UIView *)_view_bg iv:(UIImageView *)_iv_thumbnail lb:(UILabel *)_lb_itemName
{
    _view_bg.backgroundColor = [UIColor blackColor];
    _iv_thumbnail.highlighted = YES;
    _lb_itemName.textColor = [UIColor whiteColor];
}

-(void)resetASportItem:(UIView *)_view_bg iv:(UIImageView *)_iv_thumbnail lb:(UILabel *)_lb_itemName
{
    _view_bg.backgroundColor = rgb(236, 240, 241);
    _iv_thumbnail.highlighted = NO;
    _lb_itemName.textColor = rgb(61, 157, 156);
}

-(void)resetAllSportsItem
{
    [self resetASportItem:view_bg_tennis iv:iv_tennis lb:lb_tennis];
    [self resetASportItem:view_bg_badminton iv:iv_badminton lb:lb_badminton];
    [self resetASportItem:view_bg_basketball iv:iv_basketball lb:lb_basketball];
    [self resetASportItem:view_bg_running iv:iv_running lb:lb_running];
    [self resetASportItem:view_bg_swimming iv:iv_swimming lb:lb_swimming];
    [self resetASportItem:view_bg_soccer iv:iv_soccer lb:lb_soccer];
    [self resetASportItem:view_bg_other iv:iv_other lb:lb_other];
}

- (void)setCornerRadius:(CGFloat)cornerRadius fromView:(UIView *)_view
{
    _view.layer.cornerRadius = cornerRadius;
    _view.layer.masksToBounds = YES;
}

#pragma mark - 网络相关
/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)receivedDataFromNetwork:(NSNotification *)_notification {
    [super receivedDataFromNetwork:_notification];
}

/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)requestFailedFromNetwork:(NSNotification *)_notification {
    [super requestFailedFromNetwork:_notification];
}
@end







