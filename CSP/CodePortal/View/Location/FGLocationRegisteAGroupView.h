//
//  FGLocationRegisteAGroupView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import <MessageUI/MessageUI.h>
@interface FGLocationRegisteAGroupView : FGPopupView<MFMailComposeViewControllerDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_email;
@property(nonatomic,weak)IBOutlet UIImageView *iv_bg;
@property(nonatomic,weak)IBOutlet UIImageView *iv_email;
@property(nonatomic,weak)IBOutlet UIButton *btn_email;
@property(nonatomic,strong)NSString *str_emailSubject;
-(IBAction)buttonAction_sendEmail:(id)_sender;
@end
