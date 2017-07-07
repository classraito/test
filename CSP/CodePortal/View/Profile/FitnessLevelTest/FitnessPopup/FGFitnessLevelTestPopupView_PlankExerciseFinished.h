//
//  FGFitnessLevelTestPopupView_PlankExerciseFinished.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCustomButton.h"
@interface FGFitnessLevelTestPopupView_PlankExerciseFinished : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_timeUsed;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_yes;
@property(nonatomic,weak)IBOutlet UIButton *btn_no;
@end
