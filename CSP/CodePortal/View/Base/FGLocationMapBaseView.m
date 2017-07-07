//
//  FGLocationMapBaseView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMapBaseView.h"
#import "Global.h"
#pragma mark - FGLocationMapBaseView(AddAnnotation)
@implementation FGLocationMapBaseView(AddAnnotation)
//添加标注
- (void)addPointAnnotationByLat:(CLLocationDegrees)_lat lng:(CLLocationDegrees)_lng info:(NSMutableDictionary *)_dic_info
{
    MyCustomAnnotation *myPointAnnotation = [self initalSinglePointAnnotationByLat:_lat lng:_lng info:_dic_info];
    [self.mapView addAnnotation:myPointAnnotation];
}

/*初始化单个标注*/
-(MyCustomAnnotation *)initalSinglePointAnnotationByLat:(CLLocationDegrees)_lat lng:(CLLocationDegrees)_lng info:(NSMutableDictionary *)_dic_info
{
    NSLog(@"::::::>%s %d (%f,%f)",__FUNCTION__,__LINE__,_lat,_lng);
    MyCustomAnnotation *myPointAnnotation = [[MyCustomAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = _lat;
    coor.longitude = _lng;
    myPointAnnotation.coordinate = coor;
    myPointAnnotation.dic_annotationInfo = _dic_info;
    myPointAnnotation.title = @"";
    myPointAnnotation.subtitle = @"";
    return myPointAnnotation;
}

/*指定标注的视图*/
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyCustomAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        MyCustomAnnotationView *annotationView = (MyCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MyCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            [annotationView setAnnotaionViewByImage:[UIImage imageNamed:@"pinicon.png"] highlightedImg:[UIImage imageNamed:@"pinicon.png"]];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            //annotationView.calloutOffset = CGPointMake(0, -5);
        }
        return annotationView;
    }
    return nil;
}

/*子类实现如何绑定数据*/
-(void)bindDataToPaoPaoView:(FGLocationsCustomPaoPaoView *)_view_paopao annotationInfo:(NSMutableDictionary *)_dic_annotationInfo
{
    
}

/*标注视图点击事件*/
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if([view isKindOfClass:[MyCustomAnnotationView class]])
    {
        
        MyCustomAnnotationView *myAnnotationView = (MyCustomAnnotationView *)view;
        MyCustomAnnotation *myAnnotation = (MyCustomAnnotation *)myAnnotationView.annotation;
        NSMutableDictionary *_dic_destinationInfo = myAnnotation.dic_annotationInfo;
        //========================bind data to paopaoView=======================
        if(_dic_destinationInfo && [_dic_destinationInfo count]>0)
        {
            [self bindDataToPaoPaoView:myAnnotationView.calloutView annotationInfo:_dic_destinationInfo];
        }
    }
    
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}



-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end



#pragma mark - FGLocationMapBaseView(FixedAnnotation)
@implementation FGLocationMapBaseView(FixedAnnotation)

- (void)initAFixedAnnotation {

  if(self.fixedAnnotaion)
      return;
    self.fixedAnnotaion = [[MAPointAnnotation alloc] init];
    self.fixedAnnotaion.coordinate = self.mapView.userLocation.coordinate;
    self.fixedAnnotaion.lockedToScreen = YES;
    [self.mapView addAnnotation:self.fixedAnnotaion];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction;
{
   
    if(!self.fixedAnnotaion)
        return;
    if(wasUserAction)
    {
        // NSLog(@":::::> %s %d",__FUNCTION__,__LINE__);
        [self searchReGeocodeWithCoordinate:self.fixedAnnotaion.coordinate];
        [self searchPoiBySearchKey:@""];
        [self saveCurrentAutoNavCoordinate:self.fixedAnnotaion.coordinate];//保存当前选中地址的经纬度
    }
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.fixedAnnotaion = nil;
}
@end








#pragma mark - FGLocationMapBaseView(SearchAPI)
@implementation FGLocationMapBaseView(SearchAPI)
-(void)initASearchAPIWithDelegate:(id<AMapSearchDelegate>)_delegate;
{
    if(self.searchAPI)
        return;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = _delegate;
    AMapSearchLanguage _mapLanguage = AMapSearchLanguageEn;
    if([commond isChinese])
        _mapLanguage = AMapSearchLanguageZhCN;
    self.searchAPI.language = _mapLanguage;
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(!self.searchAPI)
        return;
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    regeo.radius = 3000;
    [self.searchAPI AMapReGoecodeSearch:regeo];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiBySearchKey:(NSString *)key
{
    if(!self.searchAPI)
        return;
    
    [self searchPoiBySearchKey:key coordinate:self.fixedAnnotaion.coordinate];
    
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiBySearchKey:(NSString *)key coordinate:(CLLocationCoordinate2D)_coordinate
{
    if(!self.searchAPI)
        return;
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    {
        CLLocationDegrees _lat = _coordinate.latitude;
        CLLocationDegrees _lng = _coordinate.longitude;
        request.location            = [AMapGeoPoint locationWithLatitude:_lat longitude:_lng];//中心点
        request.keywords            = key;
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = NO;
        
        [self.searchAPI AMapPOIAroundSearch:request];
    }
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.searchAPI.delegate = nil;
    self.searchAPI = nil;
}
@end










#pragma mark - FGLocationMapBaseView
@implementation FGLocationMapBaseView
@synthesize mapView;
@synthesize searchAPI;
@synthesize gpsButton;
@synthesize userLocationUpdated;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self internalInitalMapView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.fixedAnnotaion)
    {
        self.fixedAnnotaion.lockedScreenPoint = CGPointMake(self.mapView.frame.size.width / 2 ,self.mapView.frame.size.height / 2 );
    }
    mapView.frame = self.bounds;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    mapView = nil;
    self.fixedAnnotaion = nil;
    
}

-(void)internalInitalMapView
{
    if(mapView)
        return;
    userLocationUpdated = NO;
    ///初始化地图
    mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    mapView.mapType = MAMapTypeStandard;
    
    self.mapView.delegate  = self;
    
    MAMapLanguage _mapLanguage = MAMapLanguageEn;
    if([commond isChinese])
        _mapLanguage = MAMapLanguageZhCN;
    mapView.language = _mapLanguage;
    // 开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    
    ///把地图添加至view
    [self addSubview:mapView];
    [self sendSubviewToBack:mapView];
    
    self.gpsButton = [self makeGPSButtonView];
    
    
    
    [self addSubview:self.gpsButton];
    //self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
}

-(void)saveCurrentAutoNavCoordinate:(CLLocationCoordinate2D)_coordinate
{
    [commond setUserDefaults:[NSNumber numberWithDouble:_coordinate.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    [commond setUserDefaults:[NSNumber numberWithDouble:_coordinate.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    ret.center = CGPointMake(CGRectGetMidX(ret.bounds) + 10,
                                        self.bounds.size.height -  CGRectGetMidY(ret.bounds) - 20);
    CGRect _frame = ret.frame;
    _frame.origin.y = 60 * ratioH;
    ret.frame = _frame;
    NSLog(@"ret.frame = %@",NSStringFromCGRect(ret.frame));
    return ret;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];
        [self searchPoiBySearchKey:@"" coordinate:self.mapView.userLocation.location.coordinate];
        [self.gpsButton setSelected:YES];
    }
}

-(void)startUpdateFixedAnnotation
{
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    userLocationUpdated = NO;
}

-(void)stopUpdateFixedAnnotation
{
    userLocationUpdated = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction;
{
    
    NSLog(@"mapView.zoomLevel = %f",mapView.zoomLevel);
}

/*!
 @brief 在地图View将要启动定位时调用此接口
 @param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)_mapView;
{
    NSLog(@":::::>%s %d %@",__FUNCTION__,__LINE__,_mapView);
}

/*!
 @brief 在地图View停止定位后调用此接口
 @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)_mapView;
{
    NSLog(@":::::>%s %d %@",__FUNCTION__,__LINE__,_mapView);
}

/*!
 @brief 位置或者设备方向更新后调用此接口
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)_mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;
{
    
    if(!userLocationUpdated)
    {
        NSLog(@":::::>%s %d %@ %@ updatingLocation=%d",__FUNCTION__,__LINE__,mapView,userLocation,updatingLocation);
        [self searchReGeocodeWithCoordinate:self.fixedAnnotaion.coordinate];
        [self searchPoiBySearchKey:@""];
        [self stopUpdateFixedAnnotation];
        [self saveCurrentAutoNavCoordinate:self.fixedAnnotaion.coordinate];//保存当前选中地址的经纬度
    }//防止一直更新地址导致重复 逆地理编码请求
}

/*!
 @brief 定位失败后调用此接口
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)_mapView didFailToLocateUserWithError:(NSError *)error;
{
    NSLog(@":::::>%@ %@",_mapView,error);
}

/*!
 @brief 当userTrackingMode改变时调用此接口
 @param mapView 地图View
 @param mode 改变后的mode
 @param animated 动画
 */
- (void)mapView:(MAMapView *)_mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;
{
    NSLog(@":::::>%@ %ld %d",_mapView,mode,animated);
}
@end
