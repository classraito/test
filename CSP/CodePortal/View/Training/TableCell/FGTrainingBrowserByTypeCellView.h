//
//  FGTrainingBrowserByTypeCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomButton.h"
#import "NetworkManager_Training.h"
@protocol FGTrainingBrowserByTypeCellViewDelegate <NSObject>
-(void)browserByTypeDidSelected:(NSString *)_str_typename workoutType:(WorkoutType)_currentWorkOutType;
@end

@interface FGTrainingBrowserByTypeCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)id<FGTrainingBrowserByTypeCellViewDelegate>delegate;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_footwork;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_conditioning;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_bag;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_headMovement;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_pad;
@end
