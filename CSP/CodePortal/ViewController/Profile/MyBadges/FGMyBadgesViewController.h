//
//  FGMyBadgesViewController.h
//  CSP
//
//  Created by JasonLu on 16/10/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGMyBadgesView.h"
@interface FGMyBadgesViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong) FGMyBadgesView *view_mybadges;
@property (nonatomic, copy) NSString *str_id;
@property (nonatomic, copy) NSString *str_name;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id name:(NSString *)_str_name;
@end
