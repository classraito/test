//
//  FGMyCalendarViewController.h
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGMyCalendarViewController : FGBaseViewController
@property (nonatomic, copy) NSString *str_id;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
@end
