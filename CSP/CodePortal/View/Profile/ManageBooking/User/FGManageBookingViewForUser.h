//
//  FGManageBookingViewForUser.h
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGManagingBookTitleView.h"
#import "FGManageBookingView.h"

@protocol FGManageBookingViewForUserDelegate <NSObject>
- (void)didGotoTrainerInfoWithTrainerId:(NSString *)_str_trainerId;
- (void)didRebookCourseWithTrainerId:(NSString *)_str_trainerId;
- (void)didFeedbackWithTrainerInfo:(NSDictionary *)_dic_trainerInfo;
- (void)didGoToFindTrainerMapView;

@end

@interface FGManageBookingViewForUser : FGManageBookingView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *view_titleBg;
@property (assign, nonatomic) id<FGManageBookingViewForUserDelegate> delegate;
- (void)bindDataToUIForBundleWithIndex:(NSInteger)_int_idx;
@end
