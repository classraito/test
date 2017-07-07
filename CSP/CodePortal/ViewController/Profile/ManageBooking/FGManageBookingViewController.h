//
//  FGManageBookingViewController.h
//  CSP
//
//  Created by JasonLu on 16/11/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGManageBookingViewForUser.h"
#import "FGManageBookingViewForTrainer.h"
@interface FGManageBookingViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong, readonly) NSDictionary *dic_info;
@property (nonatomic, strong) FGManageBookingViewForUser *view_manageBookingForUser;
@property (nonatomic, strong) FGManageBookingViewForTrainer *view_manageBookingForTrainer;
@property (nonatomic, copy) NSString *str_id;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id withInfo:(NSDictionary *)_info;
- (void)refreshBookingWithInfo:(NSDictionary *)_dic_info;
@end
