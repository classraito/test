//
//  FGBadgeDetailInfoPopView.h
//  CSP
//
//  Created by JasonLu on 16/12/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGBadgeDetailInfoPopView : FGPopupView
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UIImageView *iv_badge;
@property(nonatomic,weak)IBOutlet UILabel *lb_badgeInfo;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;


- (void)setupBadgeWithInfo:(NSDictionary *)_dic_info;
@end
