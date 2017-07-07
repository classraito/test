//
//  FGFitnessLevelTestPopupView_HowManayPushUps.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCircularButton.h"
#import "FGCustomButton.h"
typedef enum{
    HowManyTypes_pushups = 1,
    HowManyTypes_stiups = 2,
    HowManyTypes_squats = 3,
    HowManyTypes_planks = 4
}HowManyTypes;

@interface FGFitnessLevelTestPopupView_HowManayPushUps : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet FGCircularButton *cirB_pushups;
@property(nonatomic,weak)IBOutlet UIButton *btn_minus;
@property(nonatomic,weak)IBOutlet UIButton *btn_plus;
@property(nonatomic,weak)IBOutlet UIImageView *iv_minus;
@property(nonatomic,weak)IBOutlet UIImageView *iv_plus;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_done;
@property HowManyTypes type;
@property NSInteger pushupsCount;
-(IBAction)buttonAction_minus:(id)_sender;
-(IBAction)buttonAction_plus:(id)_sender;
@end
