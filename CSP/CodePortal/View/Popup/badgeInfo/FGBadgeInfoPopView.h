//
//  FGBadgeInfoPopView.h
//  CSP
//
//  Created by JasonLu on 16/12/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "M13ProgressViewBorderedBar.h"

@interface FGBadgeInfoPopView : FGPopupView
@property (weak, nonatomic) IBOutlet UIView *view_blackBG;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UIImageView *iv_badge;
@property(nonatomic,weak)IBOutlet UILabel *lb_badgeInfo;
@property (weak, nonatomic) IBOutlet UILabel *lb_progressTip;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet M13ProgressViewBorderedBar *view_badgeProgressBar;

- (void)setupViewWithInfo:(NSDictionary *)_dic;
@end
