//
//  FGLocationBookMultiClassPIckDateViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/2/21.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLocationBookMultiClassPIckDateViewController.h"
#import "Global.h"
#define MAX_DATE_DAYS 30
#define MAX_LIMIT_NUMS 120

#pragma mark - FGLocationBookMultiClassInputPage
@implementation FGLocationBookMultiClassInputPage
@synthesize lb_titleDescription;

/*开始日期*/
@synthesize lb_startDate;
@synthesize tf_startDate;
@synthesize btn_startDate;

/*周一*/
@synthesize iv_monday_checkBox;
@synthesize btn_monday_checkBox;
@synthesize lb_monday;
@synthesize tf_monday;
@synthesize btn_monday;

/*周二*/
@synthesize iv_tuesday_checkBox;
@synthesize btn_tuesday_checkBox;
@synthesize lb_tuesday;
@synthesize tf_tuesday;
@synthesize btn_tuesday;

/*周三*/
@synthesize iv_wednesday_checkBox;
@synthesize btn_wednesday_checkBox;
@synthesize lb_wednesday;
@synthesize tf_wednesday;
@synthesize btn_wednesday;

/*周四*/
@synthesize iv_thursday_checkBox;
@synthesize btn_thursday_checkBox;
@synthesize lb_thursday;
@synthesize tf_thursday;
@synthesize btn_thursday;

/*周五*/
@synthesize iv_friday_checkBox;
@synthesize btn_friday_checkBox;
@synthesize lb_friday;
@synthesize tf_friday;
@synthesize btn_friday;

/*周六*/
@synthesize iv_saturday_checkBox;
@synthesize btn_saturday_checkBox;
@synthesize lb_saturday;
@synthesize tf_saturday;
@synthesize btn_saturday;

/*周日*/
@synthesize iv_sunday_checkBox;
@synthesize btn_sunday_checkBox;
@synthesize lb_sunday;
@synthesize tf_sunday;
@synthesize btn_sunday;

@synthesize dp_pickDate;

@synthesize arr_checkBoxInfos;

@synthesize cb_done;

@synthesize lb_numberOfTimes;
@synthesize tf_numberOfTimes;
@synthesize btn_numberOfTimes;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUILayout];
    [self setupTextField];
    [self setupFont];
    [self setupText];
    [self formatTextField];
    
    [cb_done setFrame:cb_done.frame title:multiLanguage(@"Confirm your package") arrimg:nil borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    
    
    cb_done.layer.cornerRadius = 6;
    cb_done.layer.masksToBounds = YES;
    cb_done.lb_title.font = font(FONT_TEXT_REGULAR, 16);
    
    
    
    arr_checkBoxInfos = [NSMutableArray arrayWithCapacity:1];
    for(int i=0; i<7; i++)
    {
        [arr_checkBoxInfos addObject:[NSNumber numberWithBool:NO]];
    }
}

-(void)setupCheckBoxInfo:(PickMultiClassTimeType)_multiClassType isChecked:(BOOL)_isChecked
{
    [arr_checkBoxInfos replaceObjectAtIndex:_multiClassType - 2 withObject:[NSNumber numberWithBool:_isChecked]];
    NSLog(@"arr_checkBoxInfos = %@",arr_checkBoxInfos);
}

-(void)setupUILayout
{
    [commond useDefaultRatioToScaleView:lb_titleDescription];
    
    [commond  useDefaultRatioToScaleView: lb_startDate];
    [commond  useDefaultRatioToScaleView:tf_startDate];
    [commond  useDefaultRatioToScaleView:btn_startDate];
    
    /*周一*/
    [commond  useDefaultRatioToScaleView:iv_monday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_monday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_monday];
    [commond  useDefaultRatioToScaleView:tf_monday];
    [commond  useDefaultRatioToScaleView:btn_monday];
    
    /*周二*/
    [commond  useDefaultRatioToScaleView:iv_tuesday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_tuesday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_tuesday];
    [commond  useDefaultRatioToScaleView:tf_tuesday];
    [commond  useDefaultRatioToScaleView:btn_tuesday];
    
    /*周三*/
    [commond  useDefaultRatioToScaleView:iv_wednesday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_wednesday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_wednesday];
    [commond  useDefaultRatioToScaleView:tf_wednesday];
    [commond  useDefaultRatioToScaleView:btn_wednesday];
    
    /*周四*/
    [commond  useDefaultRatioToScaleView:iv_thursday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_thursday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_thursday];
    [commond  useDefaultRatioToScaleView:tf_thursday];
    [commond  useDefaultRatioToScaleView:btn_thursday];
    
    /*周五*/
    [commond  useDefaultRatioToScaleView:iv_friday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_friday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_friday];
    [commond  useDefaultRatioToScaleView:tf_friday];
    [commond  useDefaultRatioToScaleView:btn_friday];
    
    /*周六*/
    [commond  useDefaultRatioToScaleView:iv_saturday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_saturday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_saturday];
    [commond  useDefaultRatioToScaleView:tf_saturday];
    [commond  useDefaultRatioToScaleView:btn_saturday];
    
    /*周日*/
    [commond  useDefaultRatioToScaleView:iv_sunday_checkBox];
    [commond  useDefaultRatioToScaleView:btn_sunday_checkBox];
    [commond  useDefaultRatioToScaleView:lb_sunday];
    [commond  useDefaultRatioToScaleView:tf_sunday];
    [commond  useDefaultRatioToScaleView:btn_sunday];
    
    /*数据选择器*/
    [commond  useDefaultRatioToScaleView:dp_pickDate];
    
    [commond useDefaultRatioToScaleView:lb_numberOfTimes];
    [commond useDefaultRatioToScaleView:tf_numberOfTimes];
    [commond useDefaultRatioToScaleView:btn_numberOfTimes];
    
    /*完成按钮*/
    [commond  useDefaultRatioToScaleView:cb_done];
    
    btn_monday_checkBox.tag = PickMultiClassTimeType_Monday;
    btn_tuesday_checkBox.tag = PickMultiClassTimeType_Tuesday;
    btn_wednesday_checkBox.tag = PickMultiClassTimeType_Wednesday;
    btn_thursday_checkBox.tag = PickMultiClassTimeType_Thursday;
    btn_friday_checkBox.tag = PickMultiClassTimeType_Friday;
    btn_saturday_checkBox.tag = PickMultiClassTimeType_Saturday;
    btn_sunday_checkBox.tag = PickMultiClassTimeType_Sunday;
    
}

-(void)setupTextField
{
    [self setTFPadding:15 tf:tf_startDate];
    [self setTFPadding:15 tf:tf_monday];
    [self setTFPadding:15 tf:tf_tuesday];
    [self setTFPadding:15 tf:tf_wednesday];
    [self setTFPadding:15 tf:tf_thursday];
    [self setTFPadding:15 tf:tf_friday];
    [self setTFPadding:15 tf:tf_saturday];
    [self setTFPadding:15 tf:tf_sunday];
    [self setTFPadding:15 tf:tf_numberOfTimes];
    
    [self setViewRoundCorner:6 view:tf_startDate];
    [self setViewRoundCorner:6 view:tf_monday];
    [self setViewRoundCorner:6 view:tf_tuesday];
    [self setViewRoundCorner:6 view:tf_wednesday];
    [self setViewRoundCorner:6 view:tf_thursday];
    [self setViewRoundCorner:6 view:tf_friday];
    [self setViewRoundCorner:6 view:tf_saturday];
    [self setViewRoundCorner:6 view:tf_sunday];
    [self setViewRoundCorner:6 view:tf_numberOfTimes];
    
}

-(void)formatTextField
{
    NSMutableArray *arr_dateFormat = [self giveMeDateFormatLaterThanNow];
    NSString *_str_date = [arr_dateFormat objectAtIndex:0];
    tf_startDate.text = _str_date;
    
    NSMutableArray *_arr_timeList = [self giveMeTimeDivideFormattedInfoFromPlist];
    tf_monday.text = [_arr_timeList objectAtIndex:0];
    tf_sunday.text = tf_saturday.text = tf_friday.text = tf_thursday.text = tf_wednesday.text = tf_tuesday.text = tf_monday.text;
    
    tf_numberOfTimes.text = @"2";
}


-(void)setupFont
{
    lb_titleDescription.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_startDate.font = font(FONT_TEXT_REGULAR, 16);
    tf_startDate.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_monday.font = font(FONT_TEXT_REGULAR, 16);
    tf_monday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_tuesday.font = font(FONT_TEXT_REGULAR, 16);
    tf_tuesday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_wednesday.font = font(FONT_TEXT_REGULAR, 16);
    tf_wednesday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_thursday.font = font(FONT_TEXT_REGULAR, 16);
    tf_thursday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_friday.font = font(FONT_TEXT_REGULAR, 16);
    tf_friday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_saturday.font = font(FONT_TEXT_REGULAR, 16);
    tf_saturday.font = font(FONT_TEXT_REGULAR, 11);
    
    lb_sunday.font = font(FONT_TEXT_REGULAR, 16);
    tf_sunday.font = font(FONT_TEXT_REGULAR, 10);
    
    lb_numberOfTimes.font = font(FONT_TEXT_REGULAR, 16);
    tf_numberOfTimes.font = font(FONT_TEXT_REGULAR, 10);
}

-(void)setupText
{

    lb_titleDescription.text = multiLanguage(@"Select the day of the week and time you wish to spread your multibookings over");
    lb_startDate.text = multiLanguage(@"Select start date for multi-booking");
    lb_monday.text = multiLanguage(@"Every Monday at…");
    lb_tuesday.text = multiLanguage(@"Every Tuesday at…");
    lb_wednesday.text = multiLanguage(@"Every Wednesday at…");
    lb_thursday.text = multiLanguage(@"Every Thursday at…");
    lb_friday.text = multiLanguage(@"Every Friday at…");
    lb_saturday.text = multiLanguage(@"Every Saturday at…");
    lb_sunday.text = multiLanguage(@"Every Sunday at…");
    lb_numberOfTimes.text = multiLanguage(@"Select the number of days in your multi-booking package:");

}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self removeAllInputView];
    arr_checkBoxInfos = nil;
}


#pragma mark - 从plist中读取时刻表信息
/*获得固定的时间段*/
-(NSMutableArray *)giveMeTimeDivideInfoFromPlist
{
    NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"预约时刻表" ofType:@"plist"];
    NSMutableArray *_arr_time = [NSMutableArray arrayWithContentsOfFile:_str_path];
    return _arr_time;
}

/*根据固定的时间段 拼接出 startdate - enddate*/
-(NSMutableArray *)giveMeTimeDivideFormattedInfoFromPlist
{
    NSMutableArray *arr_timeDivide = [self giveMeTimeDivideInfoFromPlist];
    NSMutableArray *_arr_formattedTime = [NSMutableArray arrayWithCapacity:1];
    for(NSMutableDictionary *_dic_singleTime in arr_timeDivide)
    {
        NSString *_str_startTime = [_dic_singleTime objectForKey:@"start"];
        NSString *_str_endTime = [_dic_singleTime objectForKey:@"end"];
        NSString *_str_timePeriod = [NSString stringWithFormat:@"%@ - %@",_str_startTime,_str_endTime];
        [_arr_formattedTime addObject:_str_timePeriod];
    }
    return _arr_formattedTime;
}

/*根据startdate - enddate 获得startdate*/
-(NSString *)giveMeStartDateByFormattedTime:(NSString *)_str_formattedTime
{
    NSArray *_arr_formattedTime = [_str_formattedTime componentsSeparatedByString:@" - "];
    NSString *_str_startDate = [_arr_formattedTime objectAtIndex:0];
    return _str_startDate;
}

#pragma mark - 生成日期选项
-(NSMutableArray *)giveMeDateFormatLaterThanNow
{
    NSMutableArray *arr_dates = [NSMutableArray arrayWithCapacity:1];
    NSDate * date = [NSDate date];
    NSString *str_dateFormatter = nil;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }
    for(int i = 1 ; i<MAX_DATE_DAYS;i++)
    {
        NSDate *newDate = [date dateByAddingDays:i];
        NSString *dateFormat = [newDate formattedDateWithFormat:str_dateFormatter ];
        
        [arr_dates addObject:dateFormat];
    }
    return arr_dates;
}

#pragma mark - 设置textField 边距
-(void)setTFPadding:(CGFloat)_padding tf:(UITextField *)_tf
{
    UIView *tmp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _padding, 0)];
    _tf.leftView = tmp;
    tmp = nil;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    
    tmp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _padding, 0)];
    _tf.rightView = tmp;
    tmp = nil;
    _tf.rightViewMode = UITextFieldViewModeAlways;
}

#pragma mark - 设置视图圆角
-(void)setViewRoundCorner:(CGFloat)_cornerRadius view:(UIView *)_view
{
    _view.layer.cornerRadius = _cornerRadius;
    _view.layer.masksToBounds = YES;
}

#pragma mark - 初始化 FGDataPickerView
-(void)internalInitalDataPickerView:(NSMutableArray *)_arr_datas pickerType:(PickMultiClassTimeType)_pickType
{
    if(dp_pickDate)
        return;
    
    dp_pickDate = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
    dp_pickDate.delegate = self;
    dp_pickDate.tag = _pickType + 1;
    [dp_pickDate setupDatas:_arr_datas];
    CGRect _frame = dp_pickDate.frame;
    _frame.size.width = self.frame.size.width;
    _frame.origin.y = H;
    dp_pickDate.frame = _frame;
    dp_pickDate.center = CGPointMake(self.frame.size.width / 2, dp_pickDate.center.y);
    [appDelegate.window addSubview:dp_pickDate];
    
    
    [UIView beginAnimations:nil context:nil];
    _frame = dp_pickDate.frame;
    _frame.origin.y = H - dp_pickDate.frame.size.height;
    dp_pickDate.frame = _frame;
    [UIView commitAnimations];
    
    
    self.currentSlideUpHeight = dp_pickDate.frame.size.height;
    [self adjustVisibleRegion:self.currentSlideUpHeight];
    
    NSString *_str_firstDate = [_arr_datas objectAtIndex:0];
    [self didSelectData:_str_firstDate picker:dp_pickDate];
}



#pragma mark - 从父类继承的方法 实现移除全部弹出控件 父类只实现了移除所有键盘 其他自定义控件要在此实现移除
-(void)removeAllInputView
{
    [super removeAllInputView];
    if(dp_pickDate)
    {
        CGRect _frame = dp_pickDate.frame;
        _frame.origin.y = H;
        dp_pickDate.frame = _frame;
        [self resetVisibleRegion];
        
        [dp_pickDate removeFromSuperview];
        dp_pickDate = nil;
    }
}

-(IBAction)buttonAction_pickDate:(UIButton *)_sender;
{
    PickMultiClassTimeType timeType = (PickMultiClassTimeType)_sender.tag;
    [self removeAllInputView];
    NSMutableArray *arr_dateFormat = nil;
    if(timeType == PickMultiClassTimeType_StartDate)
    {
        arr_dateFormat = [self giveMeDateFormatLaterThanNow];//获得今天以后的日期列表
    }
    else
        arr_dateFormat = [self giveMeTimeDivideFormattedInfoFromPlist];//获得时间列表

    [self internalInitalDataPickerView:arr_dateFormat pickerType:timeType];
}

-(IBAction)buttonAction_selectDate:(UIButton *)_sender
{
    PickMultiClassTimeType timeType = (PickMultiClassTimeType)_sender.tag;
    switch ((int)timeType) {
    
        case PickMultiClassTimeType_Monday:
                iv_monday_checkBox.highlighted = iv_monday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_monday_checkBox.highlighted];
            break;
            
        case PickMultiClassTimeType_Tuesday:
                iv_tuesday_checkBox.highlighted = iv_tuesday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_tuesday_checkBox.highlighted];
            break;
        
        case PickMultiClassTimeType_Wednesday:
                iv_wednesday_checkBox.highlighted = iv_wednesday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_wednesday_checkBox.highlighted];
            break;
        
        case PickMultiClassTimeType_Thursday:
                iv_thursday_checkBox.highlighted = iv_thursday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_thursday_checkBox.highlighted];
            break;
            
        case PickMultiClassTimeType_Friday:
                iv_friday_checkBox.highlighted = iv_friday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_friday_checkBox.highlighted];
            break;
            
        case PickMultiClassTimeType_Saturday:
                iv_saturday_checkBox.highlighted = iv_saturday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_saturday_checkBox.highlighted];
            break;
            
        case PickMultiClassTimeType_Sunday:
                iv_sunday_checkBox.highlighted = iv_sunday_checkBox.highlighted ? NO : YES;
                [self setupCheckBoxInfo:timeType isChecked:iv_sunday_checkBox.highlighted];
            break;
    }
    
}

-(IBAction)buttonAction_pickNumberOfTimes:(int)_numberOfTimes
{
    [self removeAllInputView];
    NSMutableArray *arr_dateFormat = nil;
    
    arr_dateFormat = [NSMutableArray arrayWithCapacity:1];
    for(int i=2;i<11;i++)
    {
        [arr_dateFormat addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self internalInitalDataPickerView:arr_dateFormat pickerType:PickMultiClassTimeType_NumberOfTimes];
}

#pragma mark -  FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
    if([_dataPicker isKindOfClass:[FGDataPickeriView class]])
    {
        FGDataPickeriView *_picker = (FGDataPickeriView *)_dataPicker;
        PickMultiClassTimeType _pickType = (PickMultiClassTimeType)_picker.tag - 1;
        
        switch ((int)_pickType) {
            case PickMultiClassTimeType_StartDate:
                    tf_startDate.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Monday:
                    tf_monday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Tuesday:
                    tf_tuesday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Wednesday:
                    tf_wednesday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Thursday:
                    tf_thursday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Friday:
                    tf_friday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Saturday:
                    tf_saturday.text = _str_selected;
                break;
                
            case PickMultiClassTimeType_Sunday:
                    tf_sunday.text = _str_selected;
                break;
            case PickMultiClassTimeType_NumberOfTimes:
                    tf_numberOfTimes.text = _str_selected;
                break;

        }
    }
    
}

-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
{
    [self removeAllInputView];
}

-(BOOL)recordDateModel
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    NSMutableArray *_arr_bookClocks = [NSMutableArray arrayWithCapacity:1];

    [_arr_bookClocks addObject:[tf_monday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_tuesday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_wednesday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_thursday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_friday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_saturday.text  componentsSeparatedByString:@" - "][0]];
    [_arr_bookClocks addObject:[tf_sunday.text  componentsSeparatedByString:@" - "][0]];

    
    int index = 0;
    for(NSNumber *num in arr_checkBoxInfos)
    {
        BOOL isChecked = [num boolValue];
        if(!isChecked)
        {
            [_arr_bookClocks replaceObjectAtIndex:index withObject:@""];
        }
        index ++;
    }

    
    paymentModel.arr_multiClass_bookClocks = [_arr_bookClocks mutableCopy];
    paymentModel.multiClass_numberOfTimes = [tf_numberOfTimes.text intValue];
    
   
    NSString *str_dateFormatter;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }
    NSString *_str_date = tf_startDate.text;
    NSString *_str_fullDate = [NSString stringWithFormat:@"%@ 00:00",_str_date];
    NSString *_str_fullFormatter = [NSString stringWithFormat:@"%@ %@",str_dateFormatter,@"HH:mm"];
    
    NSDate *date = [commond dateFromString:_str_fullDate formatter:_str_fullFormatter];
    long since1970 = [date timeIntervalSince1970]; //将时间转换为 自1970年开始的秒数
    paymentModel.multiClass_startDate = since1970;
    
    NSString *_str_failedReason = nil;
    NSLog(@"arr_checkBoxInfos = %@",arr_checkBoxInfos);
    if(![arr_checkBoxInfos containsObject:[NSNumber numberWithInt:1]])
    {
        _str_failedReason = multiLanguage(@"Please check again");
    }
    
    if(_str_failedReason)
    {
        [commond alert:multiLanguage(@"ALERT") message:_str_failedReason callback:nil];
        return NO;
    }
    
    return YES;

}
@end

#pragma mark - FGLocationBookMultiClassPIckDateViewController
@interface FGLocationBookMultiClassPIckDateViewController ()
{
    
}
@end

@implementation FGLocationBookMultiClassPIckDateViewController
@synthesize view_pickDate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"Select Time");
    
    [self internalInitalBookingMultiClassView];
    [view_pickDate.cb_done.button addTarget:self action:@selector(buttonAction_confirm:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self hideBottomPanelWithAnimtaion:NO];
   
}

-(void)buttonAction_confirm:(id)_sender
{
    NSLog(@"buttonAction_confirm = %@",_sender);

    if([view_pickDate recordDateModel])
    {
        [self postRequest_preCheckOrder];
    }
}

-(void)internalInitalBookingMultiClassView
{
    if(view_pickDate)
        return;
    
    view_pickDate = (FGLocationBookMultiClassInputPage *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationBookMultiClassInputPage" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_pickDate];
    CGRect _frame = view_pickDate.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_pickDate.frame = _frame;
    [self.view addSubview:view_pickDate];
    [view_pickDate setupByOriginalContentSize:view_pickDate.bounds.size];
}

-(void)buttonAction_left:(id)_sender
{
    NSLog(@"buttonAction_left:%@",_sender);
    [super buttonAction_left:_sender];
    if(view_pickDate)
        [view_pickDate removeAllInputView];

}

/*预检查订单状态接口*/
-(void)postRequest_preCheckOrder
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [_dic_info setObject:@"preCheckOrder" forKey:@"preCheckOrder"];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkOrder:_dic_info];
}

-(void)postRequest_book
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    
    [[NetworkManager_Location sharedManager] postRequest_Location_OrderTrainMultiClass:paymentModel.str_trainerId startDate:paymentModel.multiClass_startDate repeatTimes:paymentModel.multiClass_numberOfTimes bookTime:paymentModel.arr_multiClass_bookClocks Lat:paymentModel.lat Lng:paymentModel.lng address:paymentModel.str_address addressDetail:paymentModel.str_addressDetail otherMsg:paymentModel.str_otherMessage userinfo:_dic_info];
        
    //调用预订多个课程的接口
}

#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    //预检查有没有已发送的订单请求
    if ([HOST(URL_LOCATION_CheckOrder) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:@"preCheckOrder"])
        {
            NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckOrder)];
            NSLog(@"_dic_result = %@",_dic_result);
            int Code = [[_dic_result objectForKey:@"Code"] intValue];
            if(Code == 0)
            {
                int orderStatus = [[_dic_result objectForKey:@"Status"] intValue];
                FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
                paymentModel.str_currentRequestedOrderId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"OrderId"]];
                paymentModel.str_trainerId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"TrainerId"]];
                paymentModel.oneSessionPrice = [[_dic_result objectForKey:@"Price"] floatValue];
                paymentModel.sessionCount = [[_dic_result objectForKey:@"SessionCount"] intValue];
                NSLog(@"paymentModel.sessionCount = %d",paymentModel.sessionCount);
                paymentModel.bookTime = [[_dic_result objectForKey:@"BookTime"] longValue];
                paymentModel.lat = [[_dic_result objectForKey:@"Lat"] longValue];
                paymentModel.lng = [[_dic_result objectForKey:@"Lng"] longValue];
                paymentModel.str_address = [_dic_result objectForKey:@"Address"];
                paymentModel.str_addressDetail = [_dic_result objectForKey:@"AddressDetial"];;
                paymentModel.str_otherMessage = [_dic_result objectForKey:@"OtherMsg"];
                
                paymentModel.currentRequestedOrderStatus = orderStatus;
                NSLog(@"orderStatus = %d",orderStatus);
                //0:订单已取消
                //1:订单已发送
                //2:订单已接受
                //3:订单已付款
                //4:订单已完成
                //5:订单已评论
                if(orderStatus == OrderStatus_Sended || orderStatus == OrderStatus_Accepted)//订单发送状态或接受状态
                {
                    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
                    [[NetworkManager_Location sharedManager] postRequest_Locations_orderCancel:paymentModel.str_currentRequestedOrderId userinfo:_dic_info];
                }
            }//取消前一个订单
            else
            {
                [self postRequest_book];
            }//发送新订单
        }
    }
    
    if([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url])
    {
        [self postRequest_book];
    }//取消上一个订单后 再定
    
    
    if ([HOST(URL_LOCATION_OrderTrainMultiClass) isEqualToString:_str_url]) {

        
            NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderTrainMultiClass)];
            int resultCode = [[_dic_info objectForKey:@"Code"] intValue];
            if(resultCode == 0)
            {
                [self go2RequestSended];
            }

        NSLog(@"获得预订多个课程的数据");
    }
}

/*进入到教练接受界面*/
-(void)go2RequestSended
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGPopupViewController *vc_popup = [[FGPopupViewController alloc] initWithNibName:@"FGPopupViewController" bundle:nil];
    [vc_popup inital_location_requestSended];
    [manager pushController:vc_popup navigationController:nav_current];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_pickDate = nil;
}
@end
