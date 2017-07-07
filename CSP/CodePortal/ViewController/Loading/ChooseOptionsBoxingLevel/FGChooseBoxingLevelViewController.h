//
//  FGChooseBoxingLevelViewController.h
//  CSP
//
//  Created by JasonLu on 16/10/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

#define KEY_USER_BOXING_LEVEL @"KEY_USER_BOXING_LEVEL"

typedef enum : NSUInteger {
  Beginner,
  Intermediate,
  Advanced,
} EMBoxingLevel;

@interface FGChooseBoxingLevelViewController : FGBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_done;
@property (weak, nonatomic) IBOutlet UIImageView *vi_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_beginner;
@property (weak, nonatomic) IBOutlet UIButton *btn_intermediate;
@property (weak, nonatomic) IBOutlet UIButton *btn_advanced;

@end