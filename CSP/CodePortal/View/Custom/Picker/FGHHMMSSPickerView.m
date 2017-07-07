//
//  FGDataPickeriew.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGHHMMSSPickerView.h"
#import "Global.h"

#define NUM_WIDTH (35 * ratioW)
#define TEXT_WIDTH (40 * ratioW)
#define CELL_HEIGHT (30 * ratioH)
@interface FGHHMMSSPickerView()
{
    NSMutableArray *arr_datas;
    NSString *str_selected;
    int hour;
    int mins;
    int secs;
    UIColor *dataTextColor;
}
@end

@implementation FGHHMMSSPickerView
@synthesize pv;
@synthesize delegate;
@synthesize btn;
@synthesize view_titlePanel;
-(void)awakeFromNib
{
    [super awakeFromNib];
    pv.delegate = self;
    btn.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    btn.titleLabel.textColor = color_red_panel;
    [btn setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
    [btn setTitle:multiLanguage(@"DONE") forState:UIControlStateHighlighted];
    [self setupDatas];
}

-(void)setupDatas
{
    arr_datas = [[NSMutableArray alloc] init];
    NSMutableArray *_arr_hours = [NSMutableArray arrayWithCapacity:1];
    for(int i=0;i<24;i++)
    {
        [_arr_hours addObject:[commond numberMinDigitsFormatter:2 num:i]];
    }
    NSMutableArray *_arr_mins = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *_arr_secs = [NSMutableArray arrayWithCapacity:1];
    for(int i=0;i<60;i++)
    {
        [_arr_mins addObject:[commond numberMinDigitsFormatter:2 num:i]];
        [_arr_secs addObject:[commond numberMinDigitsFormatter:2 num:i]];
    }
    
    NSMutableArray *_arr_hours_name = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *_arr_mins_name = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *_arr_secs_name = [NSMutableArray arrayWithCapacity:1];
    [_arr_hours_name addObject:multiLanguage(@"hours")];
    [_arr_mins_name addObject:multiLanguage(@"mins") ];
    [_arr_secs_name addObject:multiLanguage(@"secs")];
    
    
    
    [arr_datas addObject:_arr_hours];
    [arr_datas addObject:_arr_hours_name];
    [arr_datas addObject:_arr_mins];
    [arr_datas addObject:_arr_mins_name];
    [arr_datas addObject:_arr_secs];
    [arr_datas addObject:_arr_secs_name];
    
    
}

/*
 将 01 : 10 : 03字符串
 
 提取出 时分秒 信息
 
 作为pickerview 初始化的值
 */
-(void)setupTimeByStringFormat:(NSString *)_str_timeFormate
{
   
    [self setupTimeByStringFormat:_str_timeFormate dataTextColor:[UIColor blackColor]];
}

-(void)setupTimeByStringFormat:(NSString *)_str_timeFormate dataTextColor:(UIColor *)_dataTextColor
{
    dataTextColor = _dataTextColor;
    NSArray *arr_nums = [_str_timeFormate componentsSeparatedByString:@":"];
    if([arr_nums count]==2)
    {
        hour = 0;
        mins = [[arr_nums objectAtIndex:0] intValue];
        secs = [[arr_nums objectAtIndex:1] intValue];
    }
    else if([arr_nums count]==3)
    {
        hour = [[arr_nums objectAtIndex:0] intValue];
        mins = [[arr_nums objectAtIndex:1] intValue];
        secs = [[arr_nums objectAtIndex:2] intValue];
    }
    
    
    [self.pv selectRow:hour inComponent:0 animated:YES];
    [self.pv selectRow:mins inComponent:2 animated:YES];
    [self.pv selectRow:secs inComponent:4 animated:YES];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_datas = nil;
    str_selected = nil;
}

-(IBAction)buttonAction_done:(id)_sender
{
    if(delegate && [delegate respondsToSelector:@selector(didCloseDataPicker: picker:)])
    {
        if(!str_selected)
            str_selected = [arr_datas objectAtIndex:0];
        [delegate didCloseDataPicker:str_selected picker:self];
    }
}

#pragma mark -
#pragma mark PickerView delegate methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED;
{
    
    CGRect _frame = CGRectMake(0, 0, 0, CELL_HEIGHT);
    if(component == 0 || component==2 || component==4)
    {
        _frame.size.width = NUM_WIDTH;
       
    }
    else
    {
        _frame.size.width = TEXT_WIDTH;
        
    }
    UILabel *lb_title = [[UILabel alloc] initWithFrame:_frame];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.textColor = dataTextColor;
    lb_title.text = [[arr_datas objectAtIndex:component] objectAtIndex:row];
    if(component == 0 || component==2 || component==4)
    {
        
        lb_title.font = font(FONT_NUM_MEDIUM, 30);
        
    }
    else
    {
        lb_title.font = font(FONT_TEXT_BOLD, 16);
        
    }
    return lb_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"::::> didSelectRow %ld %ld",row,component);
    if(component == 0)
    {
         hour = [[[arr_datas objectAtIndex:component] objectAtIndex:row] intValue];
    }
    
    else if(component == 2)
    {
         mins = [[[arr_datas objectAtIndex:component] objectAtIndex:row] intValue];
    }
    
    else if(component == 4)
    {
         secs = [[[arr_datas objectAtIndex:component] objectAtIndex:row] intValue];
    }
    
    if(hour == 0)
    {
        str_selected = [NSString stringWithFormat:@"%@:%@",
                        [commond numberMinDigitsFormatter:2 num:mins],
                        [commond numberMinDigitsFormatter:2 num:secs]];
    }
    else
    {
        str_selected = [NSString stringWithFormat:@"%@:%@:%@",[commond numberMinDigitsFormatter:2 num:hour],
                        [commond numberMinDigitsFormatter:2 num:mins],
                        [commond numberMinDigitsFormatter:2 num:secs]];
    }
    
   
    if(delegate && [delegate respondsToSelector:@selector(didSelectData: picker:)])
    {
        [delegate didSelectData:str_selected picker:self];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return CELL_HEIGHT;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        case 2:
        case 4:
            return NUM_WIDTH ;
            
        case 1:
        case 3:
        case 5:
            return TEXT_WIDTH ;
    
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[arr_datas objectAtIndex:component] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}
@end
