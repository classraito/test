//
//  FGLoginInputPhoneNumberView.h
//  CSP
//
//  Created by JasonLu on 17/2/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"

@interface FGLoginInputPhoneNumberView : FGUserInputPageBaseView
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIView *view_inputCode_BG;
@property(nonatomic,weak)IBOutlet UITextField *tf_inputCode;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;

-(IBAction)buttonAction_done:(id)_sender;
@end
