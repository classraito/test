//
//  FGLocationFindAGYMViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindAGYMViewController.h"
#import "Global.h"
@interface FGLocationFindAGYMViewController ()
{
    
}
@end

@implementation FGLocationFindAGYMViewController
@synthesize view_map;
@synthesize view_list;

@synthesize view_section;
@synthesize view_separator_v;
@synthesize btn_map;
@synthesize btn_list;
@synthesize sectionType;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sectionType = -1;
    [commond useDefaultRatioToScaleView:btn_map];
    [commond useDefaultRatioToScaleView:btn_list];
    [commond useDefaultRatioToScaleView:view_separator_v];
    [commond useDefaultRatioToScaleView:view_section];
    
    [btn_map setTitle:multiLanguage(@"MAP") forState:UIControlStateNormal];
    [btn_map setTitle:multiLanguage(@"MAP") forState:UIControlStateHighlighted];
    [btn_list setTitle:multiLanguage(@"LIST") forState:UIControlStateNormal];
    [btn_list setTitle:multiLanguage(@"LIST") forState:UIControlStateHighlighted];
    
    btn_map.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_list.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"FIND A GYM");
    [self hideBottomPanelWithAnimtaion:NO];
    
    [self internalInitalMapView];
    [self internalInitalListView];
    [self switchUIBySectionType:LocationSectionType_Map];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self.view_list.tb setRefreshFooter:nil];
    self.view_list.tb.mj_header=nil;
    view_map = nil;
    view_list = nil;
}

#pragma mark - 初始化
-(void)internalInitalMapView
{
    if(view_map)
        return;
    view_map = (FGLocationFindAGYMMapVIew *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationFindAGYMMapVIew" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_map];
    CGRect _frame = view_map.frame;
    _frame.origin.y = view_section.frame.origin.y + view_section.frame.size.height;
    _frame.size.height = H - _frame.origin.y;
    view_map.frame = _frame;
    [self.view addSubview:view_map];
    [self.view bringSubviewToFront:view_section];
    
    [view_map.cb_registeAGroup.button addTarget:self action:@selector(buttonAction_registerAGroup:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 初始化
-(void)internalInitalListView
{
    if(view_list)
        return;
    view_list = (FGLocationFindAGYMListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationFindAGYMListView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_list];
    CGRect _frame = view_list.frame;
    _frame.origin.y = view_section.frame.origin.y + view_section.frame.size.height;
    _frame.size.height = H - _frame.origin.y;
    view_list.frame = _frame;
    [self.view addSubview:view_list];
    [self.view bringSubviewToFront:view_section];
    
    [view_list beginRefresh];
}

#pragma mark - 切换标签
-(void)switchUIBySectionType:(LocationSectionType)_sectionType
{
    if(sectionType == _sectionType)
        return;
    
    if(_sectionType == LocationSectionType_Map)
    {
        view_list.hidden = YES;
        view_map.hidden = NO;
        
        [btn_map setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_map setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn_list setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    else if(_sectionType == LocationSectionType_List)
    {
        view_list.hidden = NO;
        view_map.hidden = YES;
        
        [btn_map setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn_map setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn_list setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_list setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    sectionType = _sectionType;
}

-(void)updateMapViewAnnotationByData:(NSMutableArray *)_arr_datas
{
    if(!view_map)
        return;
    [view_map updateAllAnnotationsByDatas:_arr_datas];
}
#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_LOCATION_GymList) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:@"GetGYMList_loadMore"])
        {
            [view_list loadMoreGYMList];
        }
        else
        {
            [view_list bindDataToUI];
        }

    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_map:(id)_sender
{
    [self switchUIBySectionType:LocationSectionType_Map];
}

-(IBAction)buttonAction_list:(id)_sender
{
    [self switchUIBySectionType:LocationSectionType_List];
}

-(void)buttonAction_registerAGroup:(id)_sender
{
    if(!view_map)
        return;
    
    [view_map internalInitalRegisteGroupPopupView];
}

@end
