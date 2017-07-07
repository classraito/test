//
//  FGLocationListCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationListCellView.h"
#import "Global.h"
@implementation FGLocationListCellView
@synthesize lb_title;
@synthesize lb_date;
@synthesize lb_time;
@synthesize lb_location;
@synthesize lb_distance;
@synthesize iv_pin;
@synthesize view_whiteBG;
@synthesize str_groupId;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_date];
    [commond useDefaultRatioToScaleView:lb_time];
    [commond useDefaultRatioToScaleView:lb_location];
    [commond useDefaultRatioToScaleView:lb_distance];
    [commond useDefaultRatioToScaleView:iv_pin];
    [commond useDefaultRatioToScaleView:view_whiteBG];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 14);
    lb_date.font = font(FONT_TEXT_REGULAR, 14);
    lb_time.font = font(FONT_TEXT_REGULAR, 14);
    lb_location.font = font(FONT_TEXT_REGULAR, 14);
    lb_distance.font = font(FONT_TEXT_REGULAR, 14);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect _frame = view_whiteBG.frame;
    _frame.size.height = self.frame.size.height - 5;
    view_whiteBG.frame = _frame;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_groupId = nil;
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_title.text = [_dataInfo objectForKey:@"ScreenName"];
    long time = [[_dataInfo objectForKey:@"Time"] longValue];
    NSString *str_dateFormat = @"MM / dd / YYYY";
    if([commond isChinese])
        str_dateFormat = @"yyyy年MM月dd日";
    lb_date.text =  [commond dateStringBySince1970:time dateFormat:str_dateFormat];
    lb_time.text = [_dataInfo objectForKey:@"ScreenTime"];
    lb_location.text = [NSString stringWithFormat:@"%@ : %@",multiLanguage(@"LOCATION"),[_dataInfo objectForKey:@"Location"]];
    str_groupId = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"GroupId"]];
    lb_distance.text = [_dataInfo objectForKey:@"Distance"];
}

-(void)postRequest_chekIn
{
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
        if(_lat != DEFAULT_LATITUDE && _lng != DEFAULT_LONTITUDE)
        {
            long lat = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLatitude];
            long lng = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLontitude];
            NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
            [manager postRequest_Locations_checkInGroup:str_groupId lat:lat lng:lng userinfo:nil];
        }
        
    }];
}

-(void)postRequest_leave
{
   
    
    
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Are You sure you want leave this group?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:nil notifyOnVC:[self viewController]];
            NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
            [manager postRequest_Locations_leaveGroup:str_groupId userinfo:_dic_info];
        }
    }];
}

-(IBAction)buttonAction_checkIn:(id)_sender;
{
    [self postRequest_chekIn];
    
}

-(IBAction)buttonAction_leave:(id)_sender;
{
    [self postRequest_leave];
}
@end
