//
//  FGTrainingStepByStepViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingStepByStepView.h"
@interface FGTrainingStepByStepViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGTrainingStepByStepView *view_stepByStep;
-(void)internalInitalStepByStepView;

@end
