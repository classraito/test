//
//  FGTimerViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGRoundTimerView.h"
#import "FGStopWatchView.h"
#import "FGRoundTimerLogicModel.h"
#import "FGStopWatchLogicModel.h"


@interface FGTimerViewController : FGBaseViewController
{
    
}
@property(nonatomic,assign)FGRoundTimerLogicModel *model_roundTimer;
@property(nonatomic,assign)FGStopWatchLogicModel *model_stopWatch;
@property(nonatomic,assign)IBOutlet UIButton *btn_roundTimer;
@property(nonatomic,assign)IBOutlet UIButton *btn_stopWatch;
@property(nonatomic,assign)IBOutlet UIView *view_separatorLine;
@property(nonatomic,assign)IBOutlet UIView *view_clockContent;
@property(nonatomic,assign)FGRoundTimerView *view_roundTmer;
@property(nonatomic,assign)FGStopWatchView *view_stopWatch;
-(IBAction)buttonAction_roundTimer:(id)_sender;
-(IBAction)buttonAction_stopWatch:(id)_sender;
@end
