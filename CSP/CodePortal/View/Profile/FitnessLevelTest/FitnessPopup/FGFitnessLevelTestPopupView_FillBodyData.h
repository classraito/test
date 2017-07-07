//
//  FGFitnessLevelTestPopupView_FillBodyData.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "FGCustomButton.h"
#import "FGDataPickeriView.h"
@interface FGFitnessLevelTestPopupView_FillBodyData : FGUserInputPageBaseView<FGDataPickerViewDelegate,UITextFieldDelegate>
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_pickerData_Gender;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_gender;
@property(nonatomic,weak)IBOutlet UIView *view_bg_gender;
@property(nonatomic,weak)IBOutlet UITextField *tf_gender;
@property(nonatomic,weak)IBOutlet UILabel *lb_age;
@property(nonatomic,weak)IBOutlet UIView *view_bg_age;
@property(nonatomic,weak)IBOutlet UITextField *tf_age;
@property(nonatomic,weak)IBOutlet UILabel *lb_weight;
@property(nonatomic,weak)IBOutlet UIView *view_bg_weight;
@property(nonatomic,weak)IBOutlet UITextField *tf_weight;
@property(nonatomic,weak)IBOutlet UILabel *lb_height;
@property(nonatomic,weak)IBOutlet UIView *view_bg_height;
@property(nonatomic,weak)IBOutlet UITextField *tf_height;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_getStarted;
@property(nonatomic,weak)IBOutlet UIButton *btn_skip;
@property(nonatomic,weak)IBOutlet UIButton *btn_gender;
@property(nonatomic,strong)FGDataPickeriView *dp_pickData;
-(IBAction)buttonAction_gender:(id)_sender;
-(void)postRequest_submitBodyData;
@end
