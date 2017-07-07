//
//  FGAreaPickerView.m
//  Pureit
//
//  Created by Ryan Gong on 16/1/21.
//  Copyright © 2016年 Ryan Gong. All rights reserved.
//

#import "FGAreaPickerView.h"
#import "Global.h"
@implementation FGAreaPickerView
@synthesize view_picker;
@synthesize locatePicker;
@synthesize areaValue;
@synthesize areaID;
@synthesize btn;
@synthesize delegate;
-(void)awakeFromNib
{
    [super awakeFromNib];
    btn.titleLabel.font = font(FONT_TEXT_BOLD, 20);
    btn.titleLabel.textColor = [UIColor blueColor];
    [self cancelLocatePicker];
    self.locatePicker = [[HZAreaPickerView alloc] initWithDelegate:self];
    [self.locatePicker showInView:view_picker];
    self.locatePicker.backgroundColor = [UIColor clearColor];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.locatePicker.frame = CGRectMake(0, 0, view_picker.frame.size.width, view_picker.frame.size.height);
    [self.locatePicker setNeedsLayout];

}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

-(void)formatAreaID:(HZAreaPickerView *)picker
{
    picker.locate.stateID = [NSString stringWithFormat:@"%@",picker.locate.stateID];
    picker.locate.cityID = [NSString stringWithFormat:@"%@",picker.locate.cityID];
    picker.locate.districtID = [NSString stringWithFormat:@"%@",picker.locate.districtID];
    NSMutableArray *_arr_tmp = [NSMutableArray arrayWithCapacity:1];
    if(picker.locate.stateID && ![@"" isEqualToString:picker.locate.stateID])
        [_arr_tmp addObject:picker.locate.stateID];
    
    if(picker.locate.cityID && ![@"" isEqualToString:picker.locate.cityID])
        [_arr_tmp addObject:picker.locate.cityID];
    
    if(picker.locate.districtID && ![@"" isEqualToString:picker.locate.districtID])
        [_arr_tmp addObject:picker.locate.districtID];
    
    int index=0;
    for(NSString *str_tmp in  _arr_tmp)
    {
        self.areaID = [self.areaID stringByAppendingString:str_tmp];
        if(index < [_arr_tmp count] - 1)
            self.areaID = [self.areaID stringByAppendingString:@","];
        index++;
    }
    NSLog(@"self.areaID = %@",areaID);
}

-(void)formatAreaName:(HZAreaPickerView *)picker
{
    NSMutableArray *_arr_tmp = [NSMutableArray arrayWithCapacity:1];
    if(picker.locate.state && ![@"" isEqualToString:picker.locate.state])
        [_arr_tmp addObject:picker.locate.state];
    
    if(picker.locate.city && ![@"" isEqualToString:picker.locate.city])
        [_arr_tmp addObject:picker.locate.city];
    
    if(picker.locate.district && ![@"" isEqualToString:picker.locate.district])
        [_arr_tmp addObject:picker.locate.district];
    
    int index=0;
    for(NSString *str_tmp in  _arr_tmp)
    {
        self.areaValue = [self.areaValue stringByAppendingString:str_tmp];
        if(index < [_arr_tmp count] - 1)
            self.areaValue = [self.areaValue stringByAppendingString:@","];
        index++;
    }
    NSLog(@"self.areaValue = %@",areaValue);
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
   
        self.areaValue = @"";
        self.areaID = @"";
    
    
        [self formatAreaID:picker];
        [self formatAreaName:picker];
    
        if(delegate && [delegate respondsToSelector:@selector(didSelectData: ids: picker:)])
        {
            [delegate didSelectData:self.areaValue ids:self.areaID picker:self];
        }
}

-(IBAction)buttonAction_done:(id)_sender;
{
    if(delegate && [delegate respondsToSelector:@selector(didCloseDataPicker: picker:)])
    {
       
        [delegate didCloseDataPicker:self.areaValue picker:self];
    }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self cancelLocatePicker];
    self.areaValue = nil;
    self.areaID = nil;
}


@end
