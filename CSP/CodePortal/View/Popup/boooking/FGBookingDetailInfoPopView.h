//
//  FGBookingDetailInfoPopView.h
//  CSP
//
//  Created by JasonLu on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGBookingDetailInfoPopView : FGPopupView
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property (weak, nonatomic) IBOutlet UIView *view_blackBG;

- (void)setupBookingDetailWithInfo:(NSDictionary *)_dic_info;
@end
