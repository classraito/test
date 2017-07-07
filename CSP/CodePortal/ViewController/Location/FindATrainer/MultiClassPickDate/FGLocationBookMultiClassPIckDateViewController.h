//
//  FGLocationBookMultiClassPIckDateViewController.h
//  CSP
//
//  Created by Ryan Gong on 17/2/21.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGUserInputPageBaseView.h"
#import "FGCustomButton.h"


typedef enum
{
    PickMultiClassTimeType_StartDate = 1,//开始日期
    PickMultiClassTimeType_Monday = 2,//星期一
    PickMultiClassTimeType_Tuesday = 3,//星期二
    PickMultiClassTimeType_Wednesday = 4,//星期三
    PickMultiClassTimeType_Thursday = 5,//星期四
    PickMultiClassTimeType_Friday = 6,//星期五
    PickMultiClassTimeType_Saturday = 7,//星期六
    PickMultiClassTimeType_Sunday = 8,//星期日
    PickMultiClassTimeType_NumberOfTimes = 9//循环次数
}PickMultiClassTimeType;//选择框类型


@interface FGLocationBookMultiClassInputPage : FGUserInputPageBaseView<FGDataPickerViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_titleDescription;


/*开始日期*/
@property(nonatomic,weak)IBOutlet UILabel *lb_startDate;
@property(nonatomic,weak)IBOutlet UITextField *tf_startDate;
@property(nonatomic,weak)IBOutlet UIButton *btn_startDate;

/*周一*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_monday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_monday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_monday;
@property(nonatomic,weak)IBOutlet UITextField *tf_monday;
@property(nonatomic,weak)IBOutlet UIButton *btn_monday;

/*周二*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_tuesday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_tuesday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_tuesday;
@property(nonatomic,weak)IBOutlet UITextField *tf_tuesday;
@property(nonatomic,weak)IBOutlet UIButton *btn_tuesday;

/*周三*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_wednesday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_wednesday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_wednesday;
@property(nonatomic,weak)IBOutlet UITextField *tf_wednesday;
@property(nonatomic,weak)IBOutlet UIButton *btn_wednesday;

/*周四*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_thursday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_thursday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_thursday;
@property(nonatomic,weak)IBOutlet UITextField *tf_thursday;
@property(nonatomic,weak)IBOutlet UIButton *btn_thursday;

/*周五*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_friday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_friday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_friday;
@property(nonatomic,weak)IBOutlet UITextField *tf_friday;
@property(nonatomic,weak)IBOutlet UIButton *btn_friday;

/*周六*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_saturday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_saturday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_saturday;
@property(nonatomic,weak)IBOutlet UITextField *tf_saturday;
@property(nonatomic,weak)IBOutlet UIButton *btn_saturday;

/*周日*/
@property(nonatomic,weak)IBOutlet UIImageView *iv_sunday_checkBox;
@property(nonatomic,weak)IBOutlet UIButton *btn_sunday_checkBox;
@property(nonatomic,weak)IBOutlet UILabel *lb_sunday;
@property(nonatomic,weak)IBOutlet UITextField *tf_sunday;
@property(nonatomic,weak)IBOutlet UIButton *btn_sunday;

@property(nonatomic,weak)IBOutlet UILabel *lb_numberOfTimes;
@property(nonatomic,weak)IBOutlet UITextField *tf_numberOfTimes;
@property(nonatomic,weak)IBOutlet UIButton *btn_numberOfTimes;

@property(nonatomic,strong)FGDataPickeriView *dp_pickDate;

@property(nonatomic,strong)NSMutableArray *arr_checkBoxInfos;

@property(nonatomic,weak)IBOutlet FGCustomButton *cb_done;

-(IBAction)buttonAction_pickDate:(UIButton *)_sender;
-(IBAction)buttonAction_selectDate:(UIButton *)_sender;
-(IBAction)buttonAction_pickNumberOfTimes:(int)_numberOfTimes;
-(BOOL)recordDateModel;
@end

@interface FGLocationBookMultiClassPIckDateViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong) FGLocationBookMultiClassInputPage *view_pickDate;
-(void)buttonAction_done:(id)_sender;
@end
