//
//  FGFitnessLevelTestPopupView_FillBodyData.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_FillBodyData.h"
#import "Global.h"
@interface FGFitnessLevelTestPopupView_FillBodyData()
{
    
}
@end


@implementation FGFitnessLevelTestPopupView_FillBodyData
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize lb_gender;
@synthesize view_bg_gender;
@synthesize tf_gender;
@synthesize lb_age;
@synthesize view_bg_age;
@synthesize tf_age;
@synthesize lb_weight;
@synthesize view_bg_weight;
@synthesize tf_weight;
@synthesize lb_height;
@synthesize view_bg_height;
@synthesize tf_height;
@synthesize cb_getStarted;
@synthesize btn_skip;
@synthesize btn_gender;
@synthesize dp_pickData;
@synthesize arr_pickerData_Gender;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor =  rgba(0, 0, 0, .8);
    arr_pickerData_Gender = (NSMutableArray *)@[GenderToString(0),GenderToString(1)];
    
    [commond useDefaultRatioToScaleView: lb_title];
    [commond useDefaultRatioToScaleView:  lb_subtitle];
    [commond useDefaultRatioToScaleView:  lb_gender];
    [commond useDefaultRatioToScaleView:  view_bg_gender];
    [commond useDefaultRatioToScaleView:  tf_gender];
    [commond useDefaultRatioToScaleView:  lb_age];
    [commond useDefaultRatioToScaleView:  view_bg_age];
    [commond useDefaultRatioToScaleView:  tf_age];
    [commond useDefaultRatioToScaleView:  lb_weight];
    [commond useDefaultRatioToScaleView:  view_bg_weight];
    [commond useDefaultRatioToScaleView:  tf_weight];
    [commond useDefaultRatioToScaleView:  lb_height];
    [commond useDefaultRatioToScaleView:  view_bg_height];
    [commond useDefaultRatioToScaleView:  tf_height];
    [commond useDefaultRatioToScaleView:  cb_getStarted];
    [commond useDefaultRatioToScaleView:  btn_skip];
    [commond useDefaultRatioToScaleView:  btn_gender];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 15);
    
    lb_gender.font = font(FONT_TEXT_REGULAR, 15);
    lb_age.font = font(FONT_TEXT_REGULAR, 15);
    lb_weight.font = font(FONT_TEXT_REGULAR, 15);
    lb_height.font = font(FONT_TEXT_REGULAR, 15);
    
    tf_age.font = font(FONT_TEXT_REGULAR, 15);
    tf_gender.font = font(FONT_TEXT_REGULAR, 15);
    tf_weight.font = font(FONT_TEXT_REGULAR, 15);
    tf_height.font = font(FONT_TEXT_REGULAR, 15);
   
    [commond setTextField:tf_age placeHolderFont:font(FONT_TEXT_REGULAR, 15) placeHolderColor:[UIColor lightGrayColor]];
    [commond setTextField:tf_gender placeHolderFont:font(FONT_TEXT_REGULAR, 15) placeHolderColor:[UIColor lightGrayColor]];
    [commond setTextField:tf_weight placeHolderFont:font(FONT_TEXT_REGULAR, 15) placeHolderColor:[UIColor lightGrayColor]];
    [commond setTextField:tf_height placeHolderFont:font(FONT_TEXT_REGULAR, 15) placeHolderColor:[UIColor lightGrayColor]];
    
    view_bg_age.layer.cornerRadius = view_bg_age.frame.size.height / 2;
    view_bg_gender.layer.cornerRadius = view_bg_gender.frame.size.height / 2;
    view_bg_weight.layer.cornerRadius = view_bg_gender.frame.size.height / 2;
    view_bg_height.layer.cornerRadius = view_bg_height.frame.size.height / 2;
    
    view_bg_age.layer.masksToBounds = YES;
    view_bg_gender.layer.masksToBounds = YES;
    view_bg_height.layer.masksToBounds = YES;
    view_bg_weight.layer.masksToBounds = YES;
    
    [cb_getStarted setFrame:cb_getStarted.frame title:multiLanguage(@"GET STARTED") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    cb_getStarted.layer.cornerRadius = cb_getStarted.frame.size.height / 2;
    cb_getStarted.layer.masksToBounds = YES;
    
    cb_getStarted.button.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    lb_title.text = multiLanguage(@"Complete below data to keep track calories burned");
    lb_subtitle.hidden = YES;
    lb_gender.text = multiLanguage(@"Gender");
    lb_age.text = multiLanguage(@"Age");
    lb_weight.text = multiLanguage(@"Weight(kg)");
    lb_height.text = multiLanguage(@"Height(cm)");
    
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateNormal];
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateHighlighted];
    
    [tf_age addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [tf_weight addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [tf_height addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)postReuquest_getProfile
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    NSString *_str_userid = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    [[NetworkManager_User sharedManager] postRequest_GetUserProfileWithQueryId:_str_userid userinfo:_dic_info];
}

-(void)postRequest_submitBodyData
{
   
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"FitnessTest" notifyOnVC:[self viewController]];
    NSMutableArray *arr_needUpdateData = [NSMutableArray arrayWithCapacity:1];
    if(tf_gender.text && ![tf_gender.text isEmptyStr])
    {
        NSMutableDictionary *_dic_gender = [NSMutableDictionary dictionaryWithCapacity:1];
        int gender = GenderToInteger(tf_gender.text);
        [_dic_gender setObject:@"Gender" forKey:@"ActionType"];
        [_dic_gender setObject:[NSString stringWithFormat:@"%d",gender] forKey:@"Value"];
        [arr_needUpdateData addObject:_dic_gender];
    }
    if(tf_age.text && ![tf_age.text isEmptyStr])
    {
        NSMutableDictionary *_dic_age = [NSMutableDictionary dictionaryWithCapacity:1];
        int age = [tf_age.text intValue];
        [_dic_age setObject:@"Age" forKey:@"ActionType"];
        [_dic_age setObject:[NSString stringWithFormat:@"%d",age] forKey:@"Value"];
        [arr_needUpdateData addObject:_dic_age];
    }
    if(tf_weight.text && ![tf_weight.text isEmptyStr])
    {
        NSMutableDictionary *_dic_weight = [NSMutableDictionary dictionaryWithCapacity:1];
        int weight = [tf_weight.text intValue];
        [_dic_weight setObject:@"Weight" forKey:@"ActionType"];
        [_dic_weight setObject:[NSString stringWithFormat:@"%d",weight] forKey:@"Value"];
        [arr_needUpdateData addObject:_dic_weight];
    }
    if(tf_height.text && ![tf_height.text isEmptyStr])
    {
        NSMutableDictionary *_dic_height = [NSMutableDictionary dictionaryWithCapacity:1];
        int height = [tf_height.text intValue];
        [_dic_height setObject:@"Height" forKey:@"ActionType"];
        [_dic_height setObject:[NSString stringWithFormat:@"%d",height] forKey:@"Value"];
        [arr_needUpdateData addObject:_dic_height];
    }
    
    if([arr_needUpdateData count] <4 )
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please fill in the datas!") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }
    else
    {
        //保存用户信息
        [[NetworkManager_User sharedManager] postRequest_SetUserProfile:arr_needUpdateData userinfo:_dic_info];
    }
}

#pragma mark - 初始化 FGDataPickerView
-(void)internalInitalDataPickerView:(NSMutableArray *)_arr_datas
{
    if(dp_pickData)
        return;
    
    dp_pickData = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
    dp_pickData.delegate = self;
    [dp_pickData setupDatas:_arr_datas];
    CGRect _frame = dp_pickData.frame;
    _frame.size.width = self.frame.size.width;
    _frame.origin.y = H;
    dp_pickData.frame = _frame;
    dp_pickData.center = CGPointMake(self.frame.size.width / 2, dp_pickData.center.y);
    [appDelegate.window addSubview:dp_pickData];
    
    
    [UIView beginAnimations:nil context:nil];
    _frame = dp_pickData.frame;
    _frame.origin.y = H - dp_pickData.frame.size.height;
    dp_pickData.frame = _frame;
    [UIView commitAnimations];
    
    self.currentSlideUpHeight = dp_pickData.frame.size.height;
    [self adjustVisibleRegion:self.currentSlideUpHeight];
    
    NSString *_str_firstDate = [_arr_datas objectAtIndex:0];
    [self didSelectData:_str_firstDate picker:dp_pickData];
    
}

#pragma mark -  FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
    
    if([_dataPicker isKindOfClass:[FGDataPickeriView class]])
    {
        tf_gender.text = _str_selected;
    }
    
}

#pragma mark - 从父类继承的方法 实现移除全部弹出控件 父类只实现了移除所有键盘 其他自定义控件要在此实现移除
-(void)removeAllInputView
{
    [super removeAllInputView];
    if(dp_pickData)
    {
        CGRect _frame = dp_pickData.frame;
        _frame.origin.y = H;
        dp_pickData.frame = _frame;
        [self resetVisibleRegion];
        
        [dp_pickData removeFromSuperview];
        dp_pickData = nil;
    }
}


-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
{
    [self removeAllInputView];
}

-(IBAction)buttonAction_gender:(id)_sender
{
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_pickerData_Gender];
}


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_pickerData_Gender = nil;
    [self removeAllInputView];
    dp_pickData = nil;
    tf_height.delegate = nil;
    tf_weight.delegate = nil;
    tf_age.delegate = nil;
}

- (BOOL)isValiateWithFlt:(float)_flt_val limit:(float)_flt_limit {
    if (_flt_val > _flt_limit) {
        return NO;
    }
    return YES;
}

#pragma mark - TextFieldDelegate
- (void) textFieldDidChange:(UITextField *)textField{
    
    NSLog(@"textField = %@",textField.text);
    if([textField isEqual:tf_age])
    {
        int age = [textField.text intValue];
        if (![self isValiateWithFlt:age limit:120]) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    }
    
    if([textField isEqual:tf_height])
    {
        int height = [textField.text intValue];
        if (![self isValiateWithFlt:height limit:1000]) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    }
    
    if([textField isEqual:tf_weight])
    {
        int weight = [textField.text intValue];
        if (![self isValiateWithFlt:weight limit:1000]) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    }
}
@end
