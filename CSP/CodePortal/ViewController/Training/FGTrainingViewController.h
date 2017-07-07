//
//  FGTrainingViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingHomePageView.h"

#define KEY_USERINFO_TRAINING_SECTIONTYPE @"KEY_USERINFO_TRAINING_SECTIONTYPE"
@interface FGTrainingViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)FGTrainingHomePageView *view_training_homepage;
-(void)internalInitalHomePage;
@end

