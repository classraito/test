//
//  FGLocationFindATrainerFillLocationView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "FGCustomButton.h"
typedef enum
{
    PickType_Date = 1,
    PickType_Time = 2
}PickType;

#define NOTIFICATION_CURRENTADDRESS @"NOTIFICATION_CURRENTADDRESS"

@interface FGLocationFindATrainerFillLocationView : FGUserInputPageBaseView<FGDataPickerViewDelegate,UITextViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_panel;
@property(nonatomic,weak)IBOutlet UILabel *lb_date;
@property(nonatomic,weak)IBOutlet UILabel *lb_location;
@property(nonatomic,weak)IBOutlet UILabel *lb_locationDetail;
@property(nonatomic,weak)IBOutlet UILabel *lb_otherMessage;
@property(nonatomic,weak)IBOutlet UILabel *lb_messageCount;
@property(nonatomic,weak)IBOutlet UITextField *tf_date;
@property(nonatomic,weak)IBOutlet UITextField *tf_location;
@property(nonatomic,weak)IBOutlet UIButton *btn_locationDetail;
@property(nonatomic,weak)IBOutlet UIButton *btn_date;
@property(nonatomic,weak)IBOutlet UILabel *lb_locationDetail_address;
@property(nonatomic,weak)IBOutlet UITextField *tf_locationDetail;
@property(nonatomic,weak)IBOutlet UITextView *tv_otherMessage;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_bookNow;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin;
@property(nonatomic,weak)IBOutlet UIImageView *iv_arrow_down;
@property(nonatomic,weak)IBOutlet UIView *view_bg;

@property(nonatomic,weak)IBOutlet UILabel *lb_time;
@property(nonatomic,weak)IBOutlet UITextField *tf_time;
@property(nonatomic,weak)IBOutlet UIButton *btn_time;

@property(nonatomic,strong)FGDataPickeriView *dp_pickDate;
-(IBAction)buttonAction_locationDetail:(id)_sender;
-(IBAction)buttonAction_pickDate:(id)_sender;
-(IBAction)buttonAction_pickTime:(id)_sender;
-(void)removeAllInputView;
@end
