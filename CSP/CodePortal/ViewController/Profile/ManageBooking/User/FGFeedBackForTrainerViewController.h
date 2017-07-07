//
//  FGFeedBackForTrainerViewController.h
//  CSP
//
//  Created by JasonLu on 16/12/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGFeedBackForTrainerView.h"
#import "FGBuyBundlePopView.h"
@interface FGFeedBackForTrainerViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong, readonly) FGFeedBackForTrainerView *view_feedbackForTrainer;
@property (nonatomic, strong, readonly) FGBuyBundlePopView *view_buyBundlePop;

@property (nonatomic, strong, readonly) NSDictionary *dic_trainerInfo;
@property (nonatomic, copy, readonly) NSString *str_id;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTrainerInfo:(id)_dic_info;
@end
