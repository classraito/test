//
//  FGTimerSettingViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGSettingView.h"
@interface FGTimerSettingViewController : FGBaseViewController
{
    
}
@property(nonatomic,assign)FGSettingView *view_setting;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(FGRoundTimerLogicModel *)_model;
@end
