//
//  FGLocationJoinAGroupMapView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationJoinAGroupMapView.h"
#import "Global.h"
@interface FGLocationJoinAGroupMapView()
{
    NSMutableDictionary *dic_selectedInfo;
}
@end

@implementation FGLocationJoinAGroupMapView
@synthesize cb_registeAGroup;
@synthesize cb_myGroup;
@synthesize arr_annotations;
@synthesize view_registeGroupPopup;

#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cb_registeAGroup];
    [commond useDefaultRatioToScaleView:cb_myGroup];
    
    [cb_registeAGroup setFrame:cb_registeAGroup.frame title:multiLanguage(@"CREATE\nA GROUP") arrimg:nil thumb:nil borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:rgb(149, 165, 165) padding:0 font:font(FONT_TEXT_REGULAR, 14) needTitleLeftAligment:NO needIconBesideLabel:NO];
    
    [cb_myGroup setFrame:cb_myGroup.frame title:multiLanguage(@"JOINED\nGROUP") arrimg:nil thumb:nil borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:rgb(60, 151, 148) padding:0 font:font(FONT_TEXT_REGULAR, 14) needTitleLeftAligment:NO needIconBesideLabel:NO];
    
    cb_registeAGroup.layer.cornerRadius = cb_registeAGroup.frame.size.width / 2;
    cb_registeAGroup.layer.masksToBounds = YES;
    
    cb_myGroup.layer.cornerRadius = cb_myGroup.frame.size.width / 2;
    cb_myGroup.layer.masksToBounds = YES;
    
    arr_annotations = [[NSMutableArray alloc] initWithCapacity:1];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.mapView.delegate = nil;
    [arr_annotations removeAllObjects];
    arr_annotations = nil;
    dic_selectedInfo = nil;
    view_registeGroupPopup = nil;
}


-(void)updateAllAnnotationsByDatas:(NSMutableArray *)_arr_datas
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for(NSMutableDictionary *_dic_singleInfo in _arr_datas )
    {
        CLLocationDegrees _lat = [commond DeCodeCoordinate:[[_dic_singleInfo objectForKey:@"Lat"] longValue]];
        CLLocationDegrees _lng = [commond DeCodeCoordinate:[[_dic_singleInfo objectForKey:@"Lng"] longValue]];
        MyCustomAnnotation *myPointAnnotation = [self initalSinglePointAnnotationByLat:_lat lng:_lng info:_dic_singleInfo];
        [arr_annotations addObject:myPointAnnotation];
    }
    [self.mapView addAnnotations:arr_annotations];
    [self.mapView showAnnotations:arr_annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];// 设置地图使其可以显示数组中所有的annotation, 如果数组中只有一个则直接设置地图中心为annotation的位置。
    _arr_datas = nil;
}


#pragma mark - 从父类继承的方法
-(void)bindDataToPaoPaoView:(FGLocationsCustomPaoPaoView *)_view_paopao annotationInfo:(NSMutableDictionary *)_dic_annotationInfo
{
    [_view_paopao bindDataToUI_group:_dic_annotationInfo];
    [_view_paopao.cb_go2Detail.button addTarget:self action:@selector(buttonAction_go2Detail:) forControlEvents:UIControlEventTouchUpInside];
   
    dic_selectedInfo = _dic_annotationInfo ;
}

#pragma mark - 按钮事件
-(void)buttonAction_go2Detail:(id)_sender
{
    if(!dic_selectedInfo)
        return;
    if([[dic_selectedInfo allKeys] count] <=0 )
        return;
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindAGroupDetailViewController *vc_findAGroup = [[FGLocationFindAGroupDetailViewController alloc] initWithNibName:@"FGLocationFindAGroupDetailViewController" bundle:nil datas:dic_selectedInfo];
    [manager pushController:vc_findAGroup navigationController:nav_current];
}

-(void)internalInitalRegisteGroupPopupView
{
    if(view_registeGroupPopup)
        return;
    
    view_registeGroupPopup = (FGLocationRegisteAGroupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationRegisteAGroupView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_registeGroupPopup];
    CGRect _frame = view_registeGroupPopup.frame;
    _frame.origin.y = cb_registeAGroup.frame.origin.y - view_registeGroupPopup.frame.size.height + 10 * ratioH;
    view_registeGroupPopup.frame = _frame;
    view_registeGroupPopup.center = CGPointMake(W/2, view_registeGroupPopup.center.y);
    [self addSubview:view_registeGroupPopup];
    view_registeGroupPopup.str_emailSubject = multiLanguage(@"request to register class");
    
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    SAFE_RemoveSupreView(view_registeGroupPopup);
    view_registeGroupPopup = nil;
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction;
{
    SAFE_RemoveSupreView(view_registeGroupPopup);
    view_registeGroupPopup = nil;
}
@end
