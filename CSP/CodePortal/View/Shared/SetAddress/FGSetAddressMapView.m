//
//  FGSetAddressMapView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/5.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGSetAddressMapView.h"
@interface FGSetAddressMapView()
{
    AMapReGeocode *regeocode; //!< 逆地理编码结果
}
@end


@implementation FGSetAddressMapView
@synthesize str_address;
@synthesize str_provinceDestrict;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initASearchAPIWithDelegate:self];
    [self initAFixedAnnotation];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.mapView.delegate = nil;
    str_address = nil;
    str_provinceDestrict = nil;
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [super makeGPSButtonView];
    CGRect _frame = ret.frame;
    _frame.origin.y =  20 * ratioH;
    ret.frame = _frame;
    NSLog(@"ret.frame = %@",NSStringFromCGRect(ret.frame));
    return ret;
}

/*根据关键字查周边*/
- (void)searchPoiBySearchKey:(NSString *)key
{
    if(!self.searchAPI)
        return;
    
    id obj_lat = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    id obj_lng = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];
    if(obj_lng && obj_lat)
    {
        CLLocationCoordinate2D _coordinate = CLLocationCoordinate2DMake([obj_lat doubleValue], [obj_lng doubleValue]);
        [self searchPoiBySearchKey:key coordinate:_coordinate];
        
    }
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
        NSLog(@"_lat = %f _lng = %f",_lat,_lng);
        request.location            = [AMapGeoPoint locationWithLatitude:_lat longitude:_lng];//中心点
        request.keywords            = key;
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = NO;
        request.offset = 50;
        [self.searchAPI AMapPOIAroundSearch:request];
        
        
        
    }
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = str_provinceDestrict;
    tips.cityLimit = YES; //是否限制城市
    
    [self.searchAPI AMapInputTipsSearch:tips];
}



#pragma mark - 地图回调
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"response.regeocode = %@",response.regeocode);
        
        regeocode = response.regeocode;
        
        
        str_provinceDestrict = [NSString stringWithFormat:@"%@%@",
                                regeocode.addressComponent.province?: @"",
                                regeocode.addressComponent.city ?: @""
                                
                                ];
        
        str_address = [NSString stringWithFormat:@"%@ %@ %@",
                       regeocode.addressComponent.streetNumber.street?: @"",
                       regeocode.addressComponent.streetNumber.number?: @"",
                       regeocode.addressComponent.building?: @""];
        
        
        
        FGSetAddressViewController *vc = (FGSetAddressViewController *)[self viewController];
        vc.tf_search.text = str_address;
        [vc getCityNameIfHave];
        /*
         由于searchTipsWithKey 获得的信息量比较少 我们只取坐标  然后根据获得的坐标
         联合 searchPoiBySearchKey 获得较多的信息 (POI附近查询的信息比较多)
         */
        [self searchTipsWithKey:str_address];//根据关键字获得经纬度
        [self searchPoiBySearchKey:@""];//根据关键字和经纬度 获得POI附近信息
        
        [self saveCityName];
    }
}

/* POI 搜索回调. 根据经纬度和关键词搜索周边POI信息*/
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
       // NSLog(@"obj.name = %@ obj.address = %@ district=%@",obj.name,obj.address,obj.district);
        
    }];
    
    AMapPOI *_poi = response.pois.firstObject;
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//更新POI经纬度，以便下次查询
    
    
    
    
    
    /*保存默认地址的经纬度*/
    FGSetAddressViewController *vc = (FGSetAddressViewController *)[self viewController];
    if([vc.str_defaultAddressKEY isEqualToString:KEY_DEFAULT_ADDRESS1])
    {
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_DEFAULT_ADDRESS1_LAT];
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_DEFAULT_ADDRESS1_LNG];
        NSLog(@"::::>(%@,%@)",[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LAT],[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LNG]);
    }
    else if([vc.str_defaultAddressKEY isEqualToString:KEY_DEFAULT_ADDRESS2])
    {
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_DEFAULT_ADDRESS2_LAT];
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_DEFAULT_ADDRESS2_LNG];
        NSLog(@"::::>(%@,%@)",[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LAT],[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LNG]);
    }
    
    
    [vc realodData:response.pois];//更新列表
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
        return;
    
    AMapTip *_tip = [response.tips firstObject];
    [commond setUserDefaults:[NSNumber numberWithDouble:_tip.location.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    [commond setUserDefaults:[NSNumber numberWithDouble:_tip.location.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//更新POI经纬度，以便下次查询
    
  
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
    str_provinceDestrict = _str_city;
    [commond setUserDefaults:_str_city forKey:KEY_CURRENTCITYNAME];
}

@end
