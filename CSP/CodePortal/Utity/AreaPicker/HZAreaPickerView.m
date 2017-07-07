//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
//#import "JSONKit.h"
#import "MemoryCache.h"
#import "Global.h"
#define kDuration 0.3

@interface HZAreaPickerView ()
{
    
    NSInteger component;
    NSInteger row;
    
  
}

@end

@implementation HZAreaPickerView
@synthesize arr_datas;
@synthesize delegate=_delegate;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;
@synthesize arr_areasUnderCity;
@synthesize arr_citysUnderProvince;
@synthesize arr_province;
- (void)dealloc
{
    arr_datas = nil;
    arr_province = nil;
    arr_citysUnderProvince = nil;
    arr_areasUnderCity = nil;
   
}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    return _locate;
}

-(void)readCityLists
{
    MemoryCache *memoryCache = [MemoryCache sharedMemoryCache];
    NSMutableDictionary *dic_citylist = [memoryCache getDataByUrl:URL_GetCityList];
    arr_datas = [dic_citylist objectForKey:@"province"];
     NSMutableDictionary *dic_oneProvince = nil;
     NSMutableDictionary *dic_oneCity = nil;
   
    dic_oneProvince = [arr_datas objectAtIndex:0];
    arr_citysUnderProvince = [dic_oneProvince objectForKey:@"city"];
    dic_oneCity = [arr_citysUnderProvince objectAtIndex:0];
    arr_areasUnderCity = [dic_oneCity objectForKey:@"area"];
    
}

- (id)initWithDelegate:(id<HZAreaPickerDelegate>)delegate
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
        arr_province = [[NSMutableArray alloc] init];
        arr_citysUnderProvince = [[NSMutableArray alloc] init];
        arr_areasUnderCity = [[NSMutableArray alloc] init];
        [self readCityLists];
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
    }
    return self;
    
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)_component
{

    
    switch (_component) {
        case 0:
            return [arr_datas count];
        case 1:
            return [arr_citysUnderProvince count];
        case 2:
            return [arr_areasUnderCity count];
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)_row forComponent:(NSInteger)_component
{
    static NSMutableDictionary *dic_oneProvince = nil;
    static NSMutableDictionary *dic_oneCity = nil;
    static NSMutableDictionary *dic_oneArea = nil;
    
  
    
        switch (_component) {
            case 0:
            {
                dic_oneProvince = [arr_datas objectAtIndex:_row] ;
                NSString *str_province = [dic_oneProvince objectForKey:@"name"];
                return str_province;
            }
                break;
               
            case 1:
            {
                dic_oneCity = [arr_citysUnderProvince objectAtIndex:_row];
                NSString *str_city = [dic_oneCity objectForKey:@"name"];
                return str_city;
            }
                break;
                
            case 2:
            {
                dic_oneArea = [arr_areasUnderCity objectAtIndex:_row];
                NSString *str_area = [dic_oneArea objectForKey:@"name"];
                return str_area;
            }
                break;
                
            default:
                return  @"";
        }
    

}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)_row inComponent:(NSInteger)_component
{
    static NSMutableDictionary *dic_oneProvince = nil;
    static NSMutableDictionary *dic_oneCity = nil;
    static NSMutableDictionary *dic_oneArea = nil;
    switch (_component) {
        case 0:
            dic_oneProvince = [arr_datas objectAtIndex:_row] ;
            arr_citysUnderProvince = [dic_oneProvince objectForKey:@"city"];
            dic_oneCity = [[dic_oneProvince objectForKey:@"city"] objectAtIndex:0];
            arr_areasUnderCity = [dic_oneCity objectForKey:@"area"];
            break;
            
        case 1:
            dic_oneCity = [[dic_oneProvince objectForKey:@"city"] objectAtIndex:_row];
            arr_areasUnderCity = [dic_oneCity objectForKey:@"area"];
            break;
            
        case 2:
            dic_oneArea = [[dic_oneCity objectForKey:@"area"] objectAtIndex:_row];
            break;
    }
    [self.locatePicker reloadAllComponents];
    NSInteger selectedProvinceIndex = [self.locatePicker selectedRowInComponent:0];
    self.locate.stateID = [[arr_datas objectAtIndex:selectedProvinceIndex] objectForKey:@"id"];
    self.locate.state = [[arr_datas objectAtIndex:selectedProvinceIndex] objectForKey:@"name"];
    
    NSInteger selectedCityIndex = [self.locatePicker selectedRowInComponent:1];
    self.locate.cityID = [[arr_citysUnderProvince objectAtIndex:selectedCityIndex] objectForKey:@"id"];
    self.locate.city = [[arr_citysUnderProvince objectAtIndex:selectedCityIndex] objectForKey:@"name"];
    
    NSInteger selectedAreaIndex = [self.locatePicker selectedRowInComponent:2];
    self.locate.districtID = [[arr_areasUnderCity objectAtIndex:selectedAreaIndex] objectForKey:@"id"];
    self.locate.district = [[arr_areasUnderCity objectAtIndex:selectedAreaIndex] objectForKey:@"name"];
    
    NSLog(@"%@,%@,%@",self.locate.stateID,self.locate.cityID,self.locate.districtID);
    NSLog(@"%@,%@,%@\n",self.locate.state,self.locate.city,self.locate.district);
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.locatePicker.frame = self.bounds;
    self.locatePicker.dataSource = self;
    self.locatePicker.delegate = self;
}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
