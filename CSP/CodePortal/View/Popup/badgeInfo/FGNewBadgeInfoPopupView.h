//
//  FGNewBadgeInfoPopupView.h
//  CSP
//
//  Created by JasonLu on 17/1/23.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGGlobalBadgesPopupView.h"
#import "M13ProgressViewBorderedBar.h"

@interface FGNewBadgeInfoPopupView : FGGlobalBadgesPopupView
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_progressTip;
@property (weak, nonatomic) IBOutlet M13ProgressViewBorderedBar *view_badgeProgressBar;
- (void)setupViewWithInfo:(NSDictionary *)_dic;
@end
