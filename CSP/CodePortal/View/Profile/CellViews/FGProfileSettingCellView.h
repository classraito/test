//
//  FGProfileSettingCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomBadgeView.h"
#import "FGCircluarWithBottomTitleButton.h"
#import <UIKit/UIKit.h>

@interface FGProfileSettingCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_bg;

@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_mybooking;
@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_workinglog;
@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_savedworkouts;
@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_favorite;
@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_fitnessleveltest;
@property (weak, nonatomic) IBOutlet FGCircluarWithBottomTitleButton *btn_setting;
@property (weak, nonatomic) IBOutlet FGCustomBadgeView *view_bookingBadge;

@end
