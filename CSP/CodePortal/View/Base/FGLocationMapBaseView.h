//
//  FGLocationMapBaseView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>
#import "FGLocationsCustomPaoPaoView.h"
#import "MyCustomAnnotation.h"
#import "MyCustomAnnotationView.h"

#define KEY_CURRENT_AUTONAVI_COORDINATE_LAT @"KEY_CURRENT_AUTONAVI_COORDINATE_LAT"
#define KEY_CURRENT_AUTONAVI_COORDINATE_LNG @"KEY_CURRENT_AUTONAVI_COORDINATE_LNG"
@interface FGLocationMapBaseView : UIView<MAMapViewDelegate>
{
    
}
@property (nonatomic, strong) MAMapView *mapView;
@property(nonatomic,strong)MAPointAnnotation *fixedAnnotaion;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) UIButton *gpsButton;
@property BOOL userLocationUpdated;
- (UIButton *)makeGPSButtonView;
@end


@interface FGLocationMapBaseView(AddAnnotation)
{
    
}
-(MyCustomAnnotation *)initalSinglePointAnnotationByLat:(CLLocationDegrees)_lat lng:(CLLocationDegrees)_lng info:(NSMutableDictionary *)_dic_info;
-(void)bindDataToPaoPaoView:(FGLocationsCustomPaoPaoView *)_view_paopao annotationInfo:(NSMutableDictionary *)_dic_annotationInfo;
@end


@interface FGLocationMapBaseView(FixedAnnotation)
{
    
}
- (void)initAFixedAnnotation ;
@end

@interface FGLocationMapBaseView(SearchAPI)<AMapSearchDelegate>
{
    
}
-(void)initASearchAPIWithDelegate:(id<AMapSearchDelegate>)_delegate;;
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)searchPoiBySearchKey:(NSString *)key;
- (void)searchPoiBySearchKey:(NSString *)key coordinate:(CLLocationCoordinate2D)_coordinate;
-(void)saveCurrentAutoNavCoordinate:(CLLocationCoordinate2D)_coordinate;
-(void)startUpdateFixedAnnotation;
-(void)stopUpdateFixedAnnotation;
@end
