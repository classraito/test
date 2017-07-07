//
//  FGProfileEditViewController.h
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGProfileDetailView.h"

@interface FGProfileEditViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong) FGProfileDetailView *view_profileDetail;
@property (nonatomic, copy) NSString *str_id;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
@end
