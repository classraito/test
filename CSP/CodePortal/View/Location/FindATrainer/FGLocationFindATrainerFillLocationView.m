//
//  FGLocationFindATrainerFillLocationView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindATrainerFillLocationView.h"
#import "Global.h"
#define MAX_DATE_DAYS 30
#define MAX_LIMIT_NUMS 120

@interface FGLocationFindATrainerFillLocationView()
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_timeDivide;
@end



@implementation FGLocationFindATrainerFillLocationView
@synthesize view_panel;
@synthesize lb_date;
@synthesize lb_time;
@synthesize lb_location;
@synthesize lb_locationDetail;
@synthesize lb_otherMessage;
@synthesize lb_messageCount;
@synthesize tf_date;
@synthesize tf_time;
@synthesize tf_location;
@synthesize btn_locationDetail;
@synthesize btn_date;
@synthesize btn_time;
@synthesize lb_locationDetail_address;
@synthesize tv_otherMessage;
@synthesize cb_bookNow;
@synthesize iv_pin;
@synthesize dp_pickDate;
@synthesize tf_locationDetail;
@synthesize iv_arrow_down;
@synthesize view_bg;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAddress:) name:NOTIFICATION_CURRENTADDRESS object:nil];
 
    [commond useDefaultRatioToScaleView:view_panel];
    [commond useDefaultRatioToScaleView:lb_date];
    [commond useDefaultRatioToScaleView:lb_time];
    [commond useDefaultRatioToScaleView:lb_location];
    [commond useDefaultRatioToScaleView:lb_locationDetail];
    [commond useDefaultRatioToScaleView:lb_otherMessage];
    [commond useDefaultRatioToScaleView:lb_messageCount];
    [commond useDefaultRatioToScaleView:tf_date];
    [commond useDefaultRatioToScaleView:tf_time];
    [commond useDefaultRatioToScaleView:tf_location];
    [commond useDefaultRatioToScaleView:tf_locationDetail];
    [commond useDefaultRatioToScaleView:btn_locationDetail];
    [commond useDefaultRatioToScaleView:btn_date];
    [commond useDefaultRatioToScaleView:btn_time];
    [commond useDefaultRatioToScaleView:iv_pin];
    [commond useDefaultRatioToScaleView:lb_locationDetail_address];
    [commond useDefaultRatioToScaleView:tv_otherMessage];
    [commond useDefaultRatioToScaleView:cb_bookNow];
    [commond useDefaultRatioToScaleView:iv_arrow_down];
    [commond useDefaultRatioToScaleView:view_bg];
    
    [self setTFPadding:15 tf:tf_date];
    [self setTFPadding:15 tf:tf_time];
    [self setTFPadding:15 tf:tf_location];
    [self setTFPadding:15 tf:tf_locationDetail];
    
    [self setViewRoundCorner:6 view:tf_locationDetail];
    [self setViewRoundCorner:6 view:tf_time];
    [self setViewRoundCorner:6 view:tf_date];
    [self setViewRoundCorner:6 view:tf_location];
    [self setViewRoundCorner:6 view:lb_locationDetail_address];
    [self setViewRoundCorner:6 view:tv_otherMessage];
    [self setViewRoundCorner:6 view:view_panel];
    
    [cb_bookNow setFrame:cb_bookNow.frame title:multiLanguage(@"BOOK NOW") arrimg:nil borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:color_red_panel];
    cb_bookNow.layer.cornerRadius = cb_bookNow.frame.size.height / 2;
    cb_bookNow.layer.masksToBounds = YES;
    cb_bookNow.lb_title.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_date.font = font(FONT_TEXT_REGULAR, 16);
    lb_time.font = font(FONT_TEXT_REGULAR, 16);
    lb_location.font = font(FONT_TEXT_REGULAR, 16);
    lb_locationDetail.font = font(FONT_TEXT_REGULAR, 16);
    lb_otherMessage.font = font(FONT_TEXT_REGULAR, 16);
    lb_messageCount.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_messageCount.text = [NSString stringWithFormat:@"%d",MAX_LIMIT_NUMS];
    
    tf_date.font = font(FONT_TEXT_REGULAR, 16);
    tf_time.font = font(FONT_TEXT_REGULAR, 16);
    tf_location.font = font(FONT_TEXT_REGULAR, 16);
    tf_locationDetail.font = font(FONT_TEXT_REGULAR, 16);
    lb_locationDetail_address.font = font(FONT_TEXT_REGULAR, 16);
    tv_otherMessage.font = font(FONT_TEXT_REGULAR, 16);
    tv_otherMessage.delegate = self;
    
    self.arr_timeDivide = [self giveMeTimeDivideInfoFromPlist];
    NSMutableArray *arr_dateFormat = [self giveMeDateFormatLaterThanNow];
    if(tf_date)
    tf_date.text = [arr_dateFormat objectAtIndex:0];
    
    if(tf_time)
    tf_time.text = [[self giveMeTimeDivideTableByTimeFormat:tf_date.text] objectAtIndex:0];
    
    lb_date.text = multiLanguage(@"Date");
    lb_time.text = multiLanguage(@"Time");
    lb_location.text = multiLanguage(@"Location");
    lb_locationDetail.text = multiLanguage(@"Location detail");
    lb_otherMessage.text = multiLanguage(@"Other message");
    
    [self getCityNameIfHave];
    [lb_locationDetail_address showLoadingAnimationWithText:multiLanguage(@"Searching")];
    
    
}

-(void)getCityNameIfHave
{
    NSString *_str_city = (NSString *)[commond getUserDefaults:KEY_CURRENTCITYNAME];
    if(_str_city && ![_str_city isEmptyStr])
    {
        tf_location.text = _str_city;
        
    }
    else{
        tf_location.text = @"---";
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [tf_location hideLoadingAnimation];
    [lb_locationDetail_address hideLoadingAnimation];
    self.arr_timeDivide = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CURRENTADDRESS object:nil];
    
}

-(void)updateCurrentAddress:(NSNotification *)_obj
{
    NSString *str_address = _obj.object;
    FGLocationFindATrainerViewController *vc = (FGLocationFindATrainerViewController *)[self viewController];
    if([str_address isEmptyStr])
    {
        [vc.view_mapView startUpdateFixedAnnotation];
    }//如果返回空地址 那么使用当前位置的地址
    else
    {
        lb_locationDetail_address.text = str_address;//更新地址文字
        
        vc.view_mapView.lb_addressBar.text = self.lb_locationDetail_address.text;//更新地址文字
        
        id obj_lat = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
        id obj_lng = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];
        if(obj_lng && obj_lat)
        {
            CLLocationCoordinate2D _coordinate = CLLocationCoordinate2DMake([obj_lat doubleValue], [obj_lng doubleValue]);
            
            [vc.view_mapView.mapView setCenterCoordinate:_coordinate animated:YES];
            [vc.view_mapView.mapView setZoomLevel:17.2 animated:YES];
        }//根据经纬度 更新地图中心点
    }//如果给了一个地址 那么使用该地址 和经纬度 更新地图中心点和 地址文字
}

#pragma mark - 从plist中读取时刻表信息
-(NSMutableArray *)giveMeTimeDivideInfoFromPlist
{
    NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"预约时刻表" ofType:@"plist"];
    NSMutableArray *_arr_time = [NSMutableArray arrayWithContentsOfFile:_str_path];
    return _arr_time;
}

#pragma mark - 生成时间选项
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
    for(int i =0 ; i<MAX_DATE_DAYS;i++)
    {
        NSDate *newDate = [date dateByAddingDays:i];
        NSString *dateFormat = [newDate formattedDateWithFormat:str_dateFormatter ];
        
        
        NSMutableArray *arr_times = [self giveMeTimeDivideTableByTimeFormat:dateFormat];
        if(!arr_times || [arr_times count]<=0)
        {
            continue;//如果这一天没有时间可选 那么就去掉这一天
        }
        
        [arr_dates addObject:dateFormat];
    }
    return arr_dates;
}

-(NSMutableArray *)giveMeTimeDivideTableByTimeFormat:(NSString *)_str_timeFormat
{
    NSMutableArray *arr_dates = [NSMutableArray arrayWithCapacity:1];
    NSDate *now = [NSDate date];
    NSString *str_dateFormatter;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }
    for(NSMutableDictionary *_dic_singleTime in self.arr_timeDivide)
    {
        
        NSString *_str_startTime = [_dic_singleTime objectForKey:@"start"];
        NSString *_str_compareTime = [NSString stringWithFormat:@"%@ %@",_str_timeFormat,_str_startTime];
        NSDate *_compareDate = [NSDate dateWithString:_str_compareTime formatString:[NSString stringWithFormat:@"%@ HH:mm",str_dateFormatter]];
        _compareDate = [_compareDate dateByAddingMinutes:-30];//比较的时间提前30分钟
        if([_compareDate isLaterThan:now])
        {
            NSString *_str_endTime = [_dic_singleTime objectForKey:@"end"];
            NSString *_str_timePeriod = [NSString stringWithFormat:@"%@ - %@",_str_startTime,_str_endTime];
            [arr_dates addObject:_str_timePeriod];
        }
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
-(void)internalInitalDataPickerView:(NSMutableArray *)_arr_datas pickerType:(PickType)_pickType
{
    if(dp_pickDate)
        return;
    
    dp_pickDate = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
    dp_pickDate.labelFont = font(FONT_TEXT_REGULAR, 10);
    dp_pickDate.delegate = self;

    dp_pickDate.tag = _pickType;
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

#pragma mark - 按钮
-(IBAction)buttonAction_locationDetail:(id)_sender
{
    if([lb_locationDetail_address.text containsString:multiLanguage(@"Searching")])
        return;
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationSelectViewController *vc_select = [[FGLocationSelectViewController alloc] initWithNibName:@"FGLocationSelectViewController" bundle:nil address:lb_locationDetail_address.text];
    [manager pushController:vc_select navigationController:nav_current];
    
}

-(IBAction)buttonAction_pickDate:(id)_sender;
{
    
    [self removeAllInputView];
    NSMutableArray *arr_dateFormat = [self giveMeDateFormatLaterThanNow];
    [self internalInitalDataPickerView:arr_dateFormat pickerType:PickType_Date];

}

-(IBAction)buttonAction_pickTime:(id)_sender;
{
    
    [self removeAllInputView];
    NSMutableArray *arr_dateFormat = [self giveMeTimeDivideTableByTimeFormat:tf_date.text];
    if(!arr_dateFormat || [arr_dateFormat count]<=0)
    {
        return;
    }
    [self internalInitalDataPickerView:arr_dateFormat pickerType:PickType_Time];
    
}

#pragma mark -  FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
    
    if([_dataPicker isKindOfClass:[FGDataPickeriView class]])
    {
        FGDataPickeriView *_picker = (FGDataPickeriView *)_dataPicker;
        PickType _pickType = (int)_picker.tag;
        if(_pickType == PickType_Date)
        {
            tf_date.text = _str_selected;
            tf_time.text = [[self giveMeTimeDivideTableByTimeFormat:_str_selected] objectAtIndex:0];
        }
        else if(_pickType == PickType_Time)
        {
            tf_time.text = _str_selected;
        }
    }
    
}

-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
{
    [self removeAllInputView];
}
@end


#pragma mark - 处理限制字符长度
@implementation FGLocationFindATrainerFillLocationView(TextViewLimit)
- (BOOL)textViewDidBeginEditing:(UITextView *)textView;
{
    [self scrollsToBottomAnimated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            lb_messageCount.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.lb_messageCount.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}
@end
