//
//  FGProfileSavedWorkoutViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkOutListViewController.h"
#import "FGProfileSavedWorkoutListView.h"
#define KEY_SAVEDWORKOUT_DATAS @"KEY_SAVEDWORKOUT_DATAS"
#define KEY_SAVEDWORKOUTLIST_DATAS @"KEY_SAVEDWORKOUTLIST_DATAS"
@interface FGProfileSavedWorkoutViewController : FGTrainingWorkOutListViewController
{
    
}
@property(nonatomic,strong)FGProfileSavedWorkoutListView *view_savedWorkoutList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title;
@end
