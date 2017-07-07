//
//  FGTrainingDetailViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingDetailView.h"

@interface FGTrainingDetailViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGTrainingDetailView *view_trainingDetail;
@property(nonatomic,strong)id workoutID;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID;
@end
