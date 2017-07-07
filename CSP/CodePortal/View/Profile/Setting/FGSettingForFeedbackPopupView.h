//
//  FGSettingForFeedbackPopupView.h
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLocationRegisteAGroupView.h"

@interface FGSettingForFeedbackPopupView : FGPopupView
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_email;
@property(nonatomic,weak)IBOutlet UIImageView *iv_email;
@property(nonatomic,weak)IBOutlet UIButton *btn_email;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property(nonatomic,strong)NSString *str_emailSubject;

@end
