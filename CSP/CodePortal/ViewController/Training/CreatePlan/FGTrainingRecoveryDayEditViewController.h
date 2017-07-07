//
//  FGTrainingRecoveryDayEditViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
typedef enum
{
    SportsType_Tennis = 1,
    SportsType_Badminton = 2,
    SportsType_Basketball = 3,
    SportsType_Running = 4,
    SportsType_Swimming = 5,
    SportsType_Soccer = 6,
    SportsType_Other = 7
}SportsType;


@interface FGTrainingRecoveryDayEditViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_addWorkoutBG;
@property(nonatomic,weak)IBOutlet UIView *view_otherChooseBG;
@property(nonatomic,weak)IBOutlet UILabel *lb_addOtherChoose;
@property(nonatomic,weak)IBOutlet UIImageView *iv_black_plus;
@property(nonatomic,weak)IBOutlet UILabel *lb_chooseOther;

@property(nonatomic,weak)IBOutlet UIView *view_bg_tennis;
@property(nonatomic,weak)IBOutlet UIView *view_bg_badminton;
@property(nonatomic,weak)IBOutlet UIView *view_bg_basketball;
@property(nonatomic,weak)IBOutlet UIView *view_bg_running;
@property(nonatomic,weak)IBOutlet UIView *view_bg_swimming;
@property(nonatomic,weak)IBOutlet UIView *view_bg_soccer;
@property(nonatomic,weak)IBOutlet UIView *view_bg_other;

@property(nonatomic,weak)IBOutlet UIImageView *iv_tennis;
@property(nonatomic,weak)IBOutlet UIImageView *iv_badminton;
@property(nonatomic,weak)IBOutlet UIImageView *iv_basketball;
@property(nonatomic,weak)IBOutlet UIImageView *iv_running;
@property(nonatomic,weak)IBOutlet UIImageView *iv_swimming;
@property(nonatomic,weak)IBOutlet UIImageView *iv_soccer;
@property(nonatomic,weak)IBOutlet UIImageView *iv_other;

@property(nonatomic,weak)IBOutlet UILabel *lb_tennis;
@property(nonatomic,weak)IBOutlet UILabel *lb_badminton;
@property(nonatomic,weak)IBOutlet UILabel *lb_basketball;
@property(nonatomic,weak)IBOutlet UILabel *lb_running;
@property(nonatomic,weak)IBOutlet UILabel *lb_swimming;
@property(nonatomic,weak)IBOutlet UILabel *lb_soccer;
@property(nonatomic,weak)IBOutlet UILabel *lb_other;

@property(nonatomic,weak)IBOutlet UIButton *btn_tennis;
@property(nonatomic,weak)IBOutlet UIButton *btn_badminton;
@property(nonatomic,weak)IBOutlet UIButton *btn_basketball;
@property(nonatomic,weak)IBOutlet UIButton *btn_running;
@property(nonatomic,weak)IBOutlet UIButton *btn_swimming;
@property(nonatomic,weak)IBOutlet UIButton *btn_soccer;
@property(nonatomic,weak)IBOutlet UIButton *btn_other;

@property(nonatomic,weak)IBOutlet UIButton *btn_addWorkout;

@property(nonatomic,weak)IBOutlet UIButton *btn_done;

@property SportsType sportsType;

-(IBAction)buttonAction_go2AddWorkout:(id)_sender;
-(IBAction)buttonAction_done:(id)_sender;
-(IBAction)buttonAction_clickOtherSports:(id)_sender;
@end
