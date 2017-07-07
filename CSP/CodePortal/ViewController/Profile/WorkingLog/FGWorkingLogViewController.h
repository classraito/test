//
//  FGWorkingLogViewController.h
//  CSP
//
//  Created by JasonLu on 16/12/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGWorkingLogView.h"
@interface FGWorkingLogViewController : FGBaseViewController
@property (nonatomic, strong) FGWorkingLogView *view_workinglog;
@property (nonatomic, copy) NSString *str_id;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
@end
