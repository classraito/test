//
//  FGLocationFindATrainerMapView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindATrainerMapView.h"
#import "Global.h"
#import "UIView+ViewController.h"
@interface FGLocationFindATrainerMapView()
{
    AMapReGeocode *regeocode; //!< 逆地理编码结果
}
@end

@implementation FGLocationFindATrainerMapView
@synthesize lb_addressBar;
@synthesize view_addressBg;
@synthesize iv_arrow_up;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_addressBg];
    [commond useDefaultRatioToScaleView:iv_arrow_up];
    [commond useDefaultRatioToScaleView:lb_addressBar];
    
    [self initASearchAPIWithDelegate:self];
    [self initAFixedAnnotation];
    view_addressBg.layer.cornerRadius = 10;
    view_addressBg.layer.masksToBounds = YES;
    lb_addressBar.font = font(FONT_TEXT_REGULAR, 18);
    lb_addressBar.numberOfLines = 0;
    [lb_addressBar setLineSpace:6];
    
    [lb_addressBar showLoadingAnimationWithText:multiLanguage(@"Searching")];
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_showFillLocation:)];
    _tap.cancelsTouchesInView = NO;
    [view_addressBg addGestureRecognizer:_tap];
    _tap = nil;
    
    UIPanGestureRecognizer *_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_showFillLocation:)];
    _pan.cancelsTouchesInView = NO;
    [view_addressBg addGestureRecognizer:_pan ];
    _pan = nil;

    
    
    lb_addressBar.userInteractionEnabled = NO;
    
    
    [self.mapView setZoomLevel:17.2 animated:YES];
    
    view_addressBg.alpha = 0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [lb_addressBar hideLoadingAnimation];
    self.mapView.delegate = nil;
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        regeocode = response.regeocode;
        FGLocationFindATrainerViewController *vc = (FGLocationFindATrainerViewController *)[self viewController];
        
        if(vc.view_fillLocation)
        {
            /* 包含 省, 市, 区以及乡镇.  */
            vc.view_fillLocation.tf_location.text = [NSString stringWithFormat:@"%@%@",
                                                     regeocode.addressComponent.province?: @"",
                                                     regeocode.addressComponent.city ?: @""
                                                     
                                                     ];
            [vc.view_fillLocation.tf_location hideLoadingAnimation];
            
            vc.view_fillLocation.lb_locationDetail_address.text = [NSString stringWithFormat:@"%@ %@ %@",
                                                                   regeocode.addressComponent.streetNumber.street?: @"",
                                                                   regeocode.addressComponent.streetNumber.number?: @"",
                                                                   regeocode.addressComponent.building?: @""];
            [vc.view_fillLocation.lb_locationDetail_address hideLoadingAnimation];
            lb_addressBar.text = vc.view_fillLocation.lb_locationDetail_address.text;
        }//如果是预订单个教练的表单
        else if(vc.view_multiClassFillLocation)
        {
            /* 包含 省, 市, 区以及乡镇.  */
            vc.view_multiClassFillLocation.tf_location.text = [NSString stringWithFormat:@"%@%@",
                                                     regeocode.addressComponent.province?: @"",
                                                     regeocode.addressComponent.city ?: @""
                                                     
                                                     ];
            [vc.view_multiClassFillLocation.tf_location hideLoadingAnimation];
            
            vc.view_multiClassFillLocation.lb_locationDetail_address.text = [NSString stringWithFormat:@"%@ %@ %@",
                                                                   regeocode.addressComponent.streetNumber.street?: @"",
                                                                   regeocode.addressComponent.streetNumber.number?: @"",
                                                                   regeocode.addressComponent.building?: @""];
            [vc.view_multiClassFillLocation.lb_locationDetail_address hideLoadingAnimation];
            lb_addressBar.text = vc.view_multiClassFillLocation.lb_locationDetail_address.text;
            
            
        }//如果是预订多个教练的表单
        
        [lb_addressBar hideLoadingAnimation];
        [self saveCityName];
    }
}

-(void)saveCityName
{
    NSString *_str_province = regeocode.addressComponent.province;
    NSString *_str_city = regeocode.addressComponent.city;
    if([_str_city isEmptyStr])
    {
        _str_city = _str_province;
    }
    if(!_str_city)
        _str_city = @"";
    [commond setUserDefaults:_str_city forKey:KEY_CURRENTCITYNAME];
}

#pragma mark - 手势
-(void)gesture_showFillLocation:(id)_sender
{
    FGLocationFindATrainerViewController *vc = (FGLocationFindATrainerViewController *)[self viewController];
    if(vc.view_fillLocation)
        [vc showFillLocation];//展开单个教练的表单
    else if(vc.view_multiClassFillLocation)
        [vc showMultiClassFillLocation];//展开多个教练的表单
    
    
}

@end
