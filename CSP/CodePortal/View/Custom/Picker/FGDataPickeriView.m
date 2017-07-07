//
//  FGDataPickeriew.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGDataPickeriView.h"
#import "Global.h"
@interface FGDataPickeriView()
{
    NSArray *arr_datas;
    NSString *str_selected;
}
@end

@implementation FGDataPickeriView
@synthesize labelFont;
@synthesize pv;
@synthesize delegate;
@synthesize btn;
-(void)awakeFromNib
{
    [super awakeFromNib];
   
    btn.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    btn.titleLabel.textColor = color_red_panel;
    
    [btn setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
    [btn setTitle:multiLanguage(@"DONE") forState:UIControlStateHighlighted];

}

-(void)setupDatas:(NSArray*)_arr_datas
{
    arr_datas = [_arr_datas copy];
     pv.delegate = self;
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
    labelFont = nil;
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
    
    CGRect _frame = CGRectMake(0, 0, W, 30);
    UILabel *lb_title = [[UILabel alloc] initWithFrame:_frame];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.text = [arr_datas objectAtIndex:row];
    lb_title.font = font(FONT_NUM_MEDIUM, 30);
    
    if(labelFont)
        lb_title.font = labelFont;
        
    return lb_title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    str_selected = [arr_datas objectAtIndex:row];
    if(delegate && [delegate respondsToSelector:@selector(didSelectData: picker:)])
    {
        [delegate didSelectData:str_selected picker:self];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arr_datas count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
@end
