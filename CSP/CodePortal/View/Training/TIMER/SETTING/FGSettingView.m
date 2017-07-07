//
//  FGSettingView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGSettingView.h"
#import "Global.h"
@interface FGSettingView()
{
    ZJSwitch *switch_timerSound;
    ZJSwitch *switch_viberation;
    FGRoundTimerLogicModel *model_roundTimer;
}
@end

@implementation FGSettingView
@synthesize lb_key_warmUp;
@synthesize lb_key_numOfRounds;
@synthesize lb_key_roundTime;
@synthesize lb_key_warningTime;
@synthesize lb_key_restTime;
@synthesize lb_key_coolDown;
@synthesize lb_key_timerSound;
@synthesize lb_key_vibration;

@synthesize lb_value_warmUp;
@synthesize lb_value_numOfRounds;
@synthesize lb_value_roundTime;
@synthesize lb_value_warningTime;
@synthesize lb_value_restTime;
@synthesize lb_value_coolDown;
@synthesize view_switch_timerSound_placeholder;
@synthesize view_switch_viberation_placehlder;

@synthesize btn_warmUp;
@synthesize btn_numOfRounds;
@synthesize btn_roundTime;
@synthesize btn_warningTime;
@synthesize btn_restTime;
@synthesize btn_coolDown;

@synthesize view_separatorLine1;
@synthesize view_separatorLine2;
@synthesize view_separatorLine3;
@synthesize view_separatorLine4;

@synthesize view_whiteBg1;
@synthesize view_whiteBg2;
@synthesize view_whiteBg3;
@synthesize view_whiteBg4;

#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:lb_key_warmUp];
    [commond useDefaultRatioToScaleView: lb_key_numOfRounds];
    [commond useDefaultRatioToScaleView: lb_key_roundTime];
    [commond useDefaultRatioToScaleView: lb_key_warningTime];
    [commond useDefaultRatioToScaleView: lb_key_restTime];
    [commond useDefaultRatioToScaleView: lb_key_coolDown];
    [commond useDefaultRatioToScaleView: lb_key_timerSound];
    [commond useDefaultRatioToScaleView: lb_key_vibration];
    
    [commond useDefaultRatioToScaleView: lb_value_warmUp];
    [commond useDefaultRatioToScaleView: lb_value_numOfRounds];
    [commond useDefaultRatioToScaleView: lb_value_roundTime];
    [commond useDefaultRatioToScaleView: lb_value_warningTime];
    [commond useDefaultRatioToScaleView: lb_value_restTime];
    [commond useDefaultRatioToScaleView: lb_value_coolDown];
    [commond useDefaultRatioToScaleView: view_switch_timerSound_placeholder];
    [commond useDefaultRatioToScaleView: view_switch_viberation_placehlder];
    
    [commond useDefaultRatioToScaleView: btn_warmUp];
    [commond useDefaultRatioToScaleView: btn_numOfRounds];
    [commond useDefaultRatioToScaleView: btn_roundTime];
    [commond useDefaultRatioToScaleView: btn_warningTime];
    [commond useDefaultRatioToScaleView: btn_restTime];
    [commond useDefaultRatioToScaleView: btn_coolDown];
    
    [commond useDefaultRatioToScaleView: view_whiteBg1];
    [commond useDefaultRatioToScaleView: view_whiteBg2];
    [commond useDefaultRatioToScaleView: view_whiteBg3];
    [commond useDefaultRatioToScaleView: view_whiteBg4];
    
    /*分割线的高度不需要缩放，所以高度的比率设为1 宽度按比例缩放*/
    CGRect scaleRect = CGRectMake(ratioW,ratioH,ratioW, 1);
    [commond useRatio:scaleRect toScaleView:view_separatorLine1];
    [commond useRatio:scaleRect toScaleView:view_separatorLine2];
    [commond useRatio:scaleRect toScaleView:view_separatorLine3];
    [commond useRatio:scaleRect toScaleView:view_separatorLine4];
    
    CGFloat fontSize = 17;
    /*设置字体*/
    lb_key_warmUp.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_numOfRounds.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_roundTime.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_warningTime.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_restTime.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_coolDown.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_timerSound.font = font(FONT_TEXT_REGULAR, fontSize);
    lb_key_vibration.font = font(FONT_TEXT_REGULAR, fontSize);
    
    
    lb_value_warmUp.font = font(FONT_NUM_MEDIUM, fontSize);
    lb_value_numOfRounds.font = font(FONT_NUM_MEDIUM, fontSize);
    lb_value_roundTime.font = font(FONT_NUM_MEDIUM, fontSize);
    lb_value_warningTime.font = font(FONT_NUM_MEDIUM, fontSize);
    lb_value_restTime.font = font(FONT_NUM_MEDIUM, fontSize);
    lb_value_coolDown.font = font(FONT_NUM_MEDIUM, fontSize);
    
    /*设置文本*/
    lb_key_warmUp.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Warm Up")];
    lb_key_numOfRounds.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Number of Rounds")];
    lb_key_roundTime.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Round Time")];
    lb_key_warningTime.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Warning Time")];
    lb_key_restTime.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Rest Time")];
    lb_key_coolDown.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Cool Down")];
    lb_key_timerSound.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Timer Sound")];
    lb_key_vibration.text = [NSString stringWithFormat:@"%@:",multiLanguage(@"Vibration")];
    
    [self setupTimerSoundSwitchButton];
    [self setupTimerViberationSwitchButton];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    
}

#pragma mark - 加载模型
-(void)loadModel:(FGRoundTimerLogicModel *)_model
{
    model_roundTimer = _model;
    [self internalInitalTime];
    switch_viberation.on = [model_roundTimer isMyViberateOn];
    switch_timerSound.on = [model_roundTimer isMySoundEffectOn];
}

#pragma mark - 使用模型数据初始化UI
-(void)internalInitalTime
{
    NSString *str_warmup;
    NSInteger numOfRounds;
    NSString *str_roundTime;
    NSString *str_warningTime;
    NSString *str_restTime;
    NSString *str_coolDown;
    
    [model_roundTimer bindModelToWarmUp:&str_warmup toNumOfRounds:&numOfRounds toRoundTime:&str_roundTime toWarnningTime:&str_warningTime toRestTime:&str_restTime toCoolDown:&str_coolDown];
    
    lb_value_warmUp.text = str_warmup;
    lb_value_numOfRounds.text = [NSString stringWithFormat:@"%ld",numOfRounds];
    lb_value_roundTime.text = str_roundTime;
    lb_value_warningTime.text = str_warningTime;
    lb_value_restTime.text = str_restTime;
    lb_value_coolDown.text = str_coolDown;
}

#pragma mark - 初始化 TimerSound Switch Button
-(void)setupTimerSoundSwitchButton
{
    if(!switch_timerSound)
    {
        view_switch_timerSound_placeholder.backgroundColor = [UIColor clearColor];
        switch_timerSound = [[ZJSwitch alloc] initWithFrame:CGRectMake(0, 0, view_switch_timerSound_placeholder.frame.size.width, view_switch_timerSound_placeholder.frame.size.height)];
        [view_switch_timerSound_placeholder addSubview:switch_timerSound];
        [switch_timerSound addTarget:self action:@selector(handleSwitchTimerSoundEvent:) forControlEvents:UIControlEventValueChanged];
    }
    [switch_timerSound setBounds:view_switch_timerSound_placeholder.bounds];
    switch_timerSound.backgroundColor = [UIColor clearColor];
    
    switch_timerSound.onText = multiLanguage(@"ON") ;
    switch_timerSound.offText = multiLanguage(@"OFF");
    switch_timerSound.onLabel.font = font(FONT_TEXT_BOLD, 16);
    switch_timerSound.offLabel.font = font(FONT_TEXT_BOLD, 16);
    [switch_timerSound setOffTextColor:[UIColor whiteColor]];
    [switch_timerSound setOnTextColor:[UIColor whiteColor]];
    
    switch_timerSound.thumbTintColor = color_lightgreen;
    switch_timerSound.tintColor = [UIColor lightGrayColor];
    switch_timerSound.onTintColor = color_deepgreen;
    
    
}

#pragma mark - 初始化 TimerSound Switch Button
-(void)setupTimerViberationSwitchButton
{
    if(!switch_viberation)
    {
        view_switch_viberation_placehlder.backgroundColor = [UIColor clearColor];
        switch_viberation = [[ZJSwitch alloc] initWithFrame:CGRectMake(0, 0, view_switch_viberation_placehlder.frame.size.width, view_switch_viberation_placehlder.frame.size.height)];
        [view_switch_viberation_placehlder addSubview:switch_viberation];
        [switch_viberation addTarget:self action:@selector(handleSwitchTimerSoundEvent:) forControlEvents:UIControlEventValueChanged];
    }
    [switch_viberation setBounds:view_switch_viberation_placehlder.bounds];
    switch_viberation.backgroundColor = [UIColor clearColor];
    
    switch_viberation.onText = multiLanguage(@"ON") ;
    switch_viberation.offText = multiLanguage(@"OFF");
    switch_viberation.onLabel.font = font(FONT_TEXT_BOLD, 16);
    switch_viberation.offLabel.font = font(FONT_TEXT_BOLD, 16);
    [switch_viberation setOffTextColor:[UIColor whiteColor]];
    [switch_viberation setOnTextColor:[UIColor whiteColor]];
    
    switch_viberation.thumbTintColor = color_lightgreen;
    switch_viberation.tintColor = [UIColor lightGrayColor];
    switch_viberation.onTintColor = color_deepgreen;
    
    
}

#pragma mark - 从父类继承的方法 实现移除全部弹出控件 父类只实现了移除所有键盘 其他自定义控件要在此实现移除
-(void)removeAllInputView
{ 
    [super removeAllInputView];
    if(dp_hhmmss)
    {
            CGRect _frame = dp_hhmmss.frame;
            _frame.origin.y = H;
            dp_hhmmss.frame = _frame;
            [self resetVisibleRegion];
     
            [dp_hhmmss removeFromSuperview];
            dp_hhmmss = nil;
    }
    
    if(dp_singleData)
    {
            CGRect _frame = dp_singleData.frame;
            _frame.origin.y = H;
            dp_singleData.frame = _frame;
            [self resetVisibleRegion];
        
            [dp_singleData removeFromSuperview];
            dp_singleData = nil;
    }
}

#pragma mark - 初始化 FGDataPickerView
-(void)internalInitalDataPickerView:(NSNumber *)_hhmmssPickerType
{
    if(dp_singleData)
        return;
    
    dp_singleData = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
    dp_singleData.delegate = self;
    dp_singleData.tag = [_hhmmssPickerType integerValue];
    NSMutableArray *arr_numbers = [NSMutableArray arrayWithCapacity:99];
    for(int i=1;i<100;i++)
    {
        [arr_numbers addObject:[commond numberMinDigitsFormatter:2 num:i]];
    }
    [dp_singleData setupDatas:arr_numbers];
    CGRect _frame = dp_singleData.frame;
    _frame.size.width = self.frame.size.width;
    _frame.origin.y = H;
    dp_singleData.frame = _frame;
    dp_singleData.center = CGPointMake(self.frame.size.width / 2, dp_singleData.center.y);
    [appDelegate.window addSubview:dp_singleData];
    
    
    [UIView beginAnimations:nil context:nil];
    _frame = dp_singleData.frame;
    _frame.origin.y = H - dp_singleData.frame.size.height;
    dp_singleData.frame = _frame;
    [UIView commitAnimations];
    
    self.currentSlideUpHeight = dp_singleData.frame.size.height;
    [self adjustVisibleRegion:self.currentSlideUpHeight];
    
    NSString *str_rounds = [self giveMeTextByHHMMSSPickerType:[_hhmmssPickerType intValue]];
    int rounds = [str_rounds intValue];
    [dp_singleData.pv selectRow:rounds inComponent:0 animated:YES];
}

#pragma mark - 初始化 FGHHMMSSPickerView
-(void)internalInitalHHMMSSPickerView:(NSNumber *)_hhmmssPickerType
{
    if(dp_hhmmss)
        return;
    
    dp_hhmmss = (FGHHMMSSPickerView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHHMMSSPickerView" owner:nil options:nil] objectAtIndex:0];
    dp_hhmmss.delegate = self;
    dp_hhmmss.tag = [_hhmmssPickerType integerValue];
    CGRect _frame = dp_hhmmss.frame;
    _frame.size.width = self.frame.size.width;
    _frame.origin.y = H;
    dp_hhmmss.frame = _frame;
    dp_hhmmss.center = CGPointMake(self.frame.size.width / 2, dp_hhmmss.center.y);
    [appDelegate.window addSubview:dp_hhmmss];
    
    [UIView beginAnimations:nil context:nil];
    _frame = dp_hhmmss.frame;
    _frame.origin.y = H - dp_hhmmss.frame.size.height;
    dp_hhmmss.frame = _frame;
    [UIView commitAnimations];
    
    self.currentSlideUpHeight = dp_hhmmss.frame.size.height;
    [self adjustVisibleRegion:self.currentSlideUpHeight];
//    [self scrollSubViewToBottomIfNeeded:<#(UIView *)#> heightOccupied:<#(CGFloat)#> ];
    
    [dp_hhmmss setupTimeByStringFormat:[self giveMeTextByHHMMSSPickerType:[_hhmmssPickerType intValue]]];

}

#pragma mark - 根据picker类型返回label上的值
-(NSString *)giveMeTextByHHMMSSPickerType:(HHMMSSPickerType)_hhmmssType
{
    switch (_hhmmssType) {
        case HHMMSSPickerType_WarmUp:
            return lb_value_warmUp.text;
            break;
        case HHMMSSPickerType_NumberOfRound:
            return lb_value_numOfRounds.text;
            break;
        case HHMMSSPickerType_RoundTime:
            return lb_value_roundTime.text;
            break;
        case HHMMSSPickerType_WarningTime:
            return lb_value_warningTime.text;
            break;
        case HHMMSSPickerType_RestTime:
            return lb_value_restTime.text;
            break;
        case HHMMSSPickerType_CoolDown:
            return lb_value_coolDown.text;
            break;
        default:
            break;
    }
    return nil;
}

-(void)saveSettings
{
    [model_roundTimer fillModelDataByWarmUp:lb_value_warmUp.text numOfRounds:[lb_value_numOfRounds.text integerValue] roundTime:lb_value_roundTime.text warnningTime:lb_value_warningTime.text restTime:lb_value_restTime.text coolDown:lb_value_coolDown.text];
    [model_roundTimer reset];
}

#pragma mark - 事件触发
/*开关按钮事件*/
-(void)handleSwitchTimerSoundEvent:(ZJSwitch *)_switch
{
    if([_switch isEqual:switch_timerSound])//声音开关
    {
        [model_roundTimer setSoundEffectOn:switch_timerSound.isOn];
    }
    else if([_switch isEqual:switch_viberation])//震动开关
    {
        [model_roundTimer setViberateOn:switch_viberation.isOn];
    }
}

/*选择时间事件*/
-(IBAction)buttonAction_warmUp:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalHHMMSSPickerView:[NSNumber numberWithInt:HHMMSSPickerType_WarmUp]];
}

-(IBAction)buttonAction_numberOfRound:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalDataPickerView:[NSNumber numberWithInt:HHMMSSPickerType_NumberOfRound]];
}

-(IBAction)buttonAction_roundTime:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalHHMMSSPickerView:[NSNumber numberWithInt:HHMMSSPickerType_RoundTime]];
    
}

-(IBAction)buttonAction_warningTime:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalHHMMSSPickerView:[NSNumber numberWithInt:HHMMSSPickerType_WarningTime]];
}

-(IBAction)buttonAction_restTime:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalHHMMSSPickerView:[NSNumber numberWithInt:HHMMSSPickerType_RestTime]];
}

-(IBAction)buttonAction_coolDown:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalHHMMSSPickerView:[NSNumber numberWithInt:HHMMSSPickerType_CoolDown]];
}



#pragma mark -  FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
    
    if([_dataPicker isKindOfClass:[FGHHMMSSPickerView class]])
    {
        FGHHMMSSPickerView *_picker = (FGHHMMSSPickerView *)_dataPicker;
        switch (_picker.tag) {
            case HHMMSSPickerType_WarmUp:
                if([_str_selected isEqualToString:@"00:00"])
                {
                    [_picker.pv selectRow:1 inComponent:4 animated:YES];
                    [_picker pickerView:_picker.pv didSelectRow:1 inComponent:4];
                }
                
                else
                    lb_value_warmUp.text = _str_selected;
                break;
            case HHMMSSPickerType_RoundTime:
                if([_str_selected isEqualToString:@"00:00"])
                {
                    [_picker.pv selectRow:1 inComponent:4 animated:YES];
                    [_picker pickerView:_picker.pv didSelectRow:1 inComponent:4];
                }
                else
                    lb_value_roundTime.text = _str_selected;
                break;
            case HHMMSSPickerType_WarningTime:
                if([_str_selected isEqualToString:@"00:00"])
                {
                    [_picker.pv selectRow:1 inComponent:4 animated:YES];
                    [_picker pickerView:_picker.pv didSelectRow:1 inComponent:4];
                }
                else
                    lb_value_warningTime.text = _str_selected;
                break;
            case HHMMSSPickerType_RestTime:
                if([_str_selected isEqualToString:@"00:00"])
                {
                    [_picker.pv selectRow:1 inComponent:4 animated:YES];
                    [_picker pickerView:_picker.pv didSelectRow:1 inComponent:4];
                }
                else
                    lb_value_restTime.text = _str_selected;
                break;
            case HHMMSSPickerType_CoolDown:
                if([_str_selected isEqualToString:@"00:00"])
                {
                     [_picker.pv selectRow:1 inComponent:4 animated:YES];
                    [_picker pickerView:_picker.pv didSelectRow:1 inComponent:4];
                }
                else
                    lb_value_coolDown.text = _str_selected;
                break;
            default:
                break;
        }
    }
    else if([_dataPicker isKindOfClass:[FGDataPickeriView class]])
    {
        lb_value_numOfRounds.text = _str_selected;
    }
    [self saveSettings];
}

-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
{
    [self removeAllInputView];
}

@end
