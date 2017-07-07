//
//  FGLocationSelectViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationSelectViewController.h"
#import "Global.h"
#import "FGLocationSelectAddressCellView.h"
@interface FGLocationSelectViewController ()
{
    NSMutableArray *arr_data;
}
@property(nonatomic,strong)NSString *str_address;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@end

@interface FGLocationSelectViewController(TableView)<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end

@interface FGLocationSelectViewController(POI)<AMapSearchDelegate>
{
    
}
-(void)initASearchAPIWithDelegate:(id<AMapSearchDelegate>)_delegate;
- (void)searchTipsWithKey:(NSString *)key;
- (void)searchPoiBySearchKey:(NSString *)key;
- (void)geoSearchByAddress:(NSString *)_str_address;
@end


#pragma mark - FGLocationSelectViewController
@implementation FGLocationSelectViewController
@synthesize tb;
@synthesize lb_city;
@synthesize view_separator_v;
@synthesize view_separator_h;
@synthesize tf_search;
@synthesize view_selectDefaultAddress;

#pragma mark - 生命周期
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)__str_address
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.str_address = [__str_address mutableCopy];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view_topPanel.str_title = multiLanguage(@"SELECT LOCATION");
    [self hideBottomPanelWithAnimtaion:NO];
    tf_search.delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldEditChanged:)
     name:UITextFieldTextDidChangeNotification
     object:tf_search];

    
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    // Do any additional setup after loading the view from its nib.
    
    [commond useDefaultRatioToScaleView:tb];
    [commond useDefaultRatioToScaleView:lb_city];
    [commond useDefaultRatioToScaleView:view_separator_h];
    [commond useDefaultRatioToScaleView:view_separator_v];
    [commond useDefaultRatioToScaleView:tf_search];
    [commond useDefaultRatioToScaleView:view_selectDefaultAddress];
    
    [view_selectDefaultAddress.btn_address1 addTarget:self action:@selector(buttonAction_address1:) forControlEvents:UIControlEventTouchUpInside];
    [view_selectDefaultAddress.btn_address2 addTarget:self action:@selector(buttonAction_address2:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect _frame = tb.frame;
    _frame.origin.y = view_selectDefaultAddress.frame.origin.y + view_selectDefaultAddress.frame.size.height;
    _frame.size.height = H - _frame.origin.y;
    tb.frame = _frame;
    
    lb_city.font = font(FONT_TEXT_REGULAR, 14);
    tf_search.font = font(FONT_TEXT_REGULAR, 14);
    tf_search.text = self.str_address;
    
    tb.delegate = self;
    tb.dataSource = self;
    
    
    [self getCityNameIfHave];
    
    [self initASearchAPIWithDelegate:self];
    
    /*
     由于searchTipsWithKey 获得的信息量比较少 我们只取坐标  然后根据获得的坐标
     联合 searchPoiBySearchKey 获得较多的信息 (POI附近查询的信息比较多)
     */
    [self searchTipsWithKey:tf_search.text];//根据关键字获得经纬度
    [self searchPoiBySearchKey:@""];//根据关键字和经纬度 获得POI附近信息
    
}

-(void)getCityNameIfHave
{
    NSString *_str_city = (NSString *)[commond getUserDefaults:KEY_CURRENTCITYNAME];
    if(_str_city && ![_str_city isEmptyStr])
    {
        lb_city.text = _str_city;
        
    }
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
    arr_data = nil;
    self.str_address = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark - 按钮事件
-(void)buttonAction_address1:(id)_sender
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    if(_str_address1 && ![_str_address1 isEmptyStr])
    {
        view_selectDefaultAddress.lb_address1.text = _str_address1;
        
        
        NSLog(@"::::>(%@,%@)",[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LAT],[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LNG]);
        [commond setUserDefaults:[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LAT] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
        [commond setUserDefaults:[commond getUserDefaults:KEY_DEFAULT_ADDRESS1_LNG] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//把默认地址的经纬度更新为当前位置
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENTADDRESS object:view_selectDefaultAddress.lb_address1.text];
        
        FGControllerManager *manager = [FGControllerManager sharedManager];
        [manager popViewControllerInNavigation:&nav_current animated:YES];
    }
    else
    {
         FGControllerManager *manager = [FGControllerManager sharedManager];
        FGSetAddressViewController *vc_setAddress = [[FGSetAddressViewController alloc] initWithNibName:@"FGSetAddressViewController" bundle:nil address:tf_search.text setDefaultAddressKEY:KEY_DEFAULT_ADDRESS1];
        [manager pushController:vc_setAddress navigationController:nav_current];
    }
}

-(void)buttonAction_address2:(id)_sender
{
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    if(_str_address2 && ![_str_address2 isEmptyStr])
    {
        view_selectDefaultAddress.lb_address2.text = _str_address2;
        NSLog(@"::::>(%@,%@)",[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LAT],[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LNG]);
        [commond setUserDefaults:[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LAT] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
        [commond setUserDefaults:[commond getUserDefaults:KEY_DEFAULT_ADDRESS2_LNG] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//把默认地址的经纬度更新为当前位置
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENTADDRESS object:view_selectDefaultAddress.lb_address2.text];
        FGControllerManager *manager = [FGControllerManager sharedManager];
        [manager popViewControllerInNavigation:&nav_current animated:YES];
    }
    else
    {
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGSetAddressViewController *vc_setAddress = [[FGSetAddressViewController alloc] initWithNibName:@"FGSetAddressViewController" bundle:nil address:tf_search.text  setDefaultAddressKEY:KEY_DEFAULT_ADDRESS2];
        [manager pushController:vc_setAddress navigationController:nav_current];
    }
}

#pragma mark - 从父类继承的

-(void)buttonAction_left:(id)_sender
{
    if([arr_data count] >0 )
    {
        AMapPOI *_poi = (AMapPOI *)[arr_data firstObject];
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
        [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//更新POI经纬度，以便下次查询
    }//保存列表里第一个地址的经纬度
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENTADDRESS object:tf_search.text];
    [super buttonAction_left:_sender];
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [tf_search resignFirstResponder];
    return YES;
}

#pragma mark - 事件通知
-(void)textFieldEditChanged:(NSNotification *)obj
{
 
    UITextField *textField = (UITextField *)obj.object;
    if([textField isEqual:tf_search])
    {
        if(textField.markedTextRange)//markedTextRange 不为空 说明用了输入法 不处理以下代码
            return;
        /*
         由于searchTipsWithKey 获得的信息量比较少 我们只取坐标  然后根据获得的坐标
         联合 searchPoiBySearchKey 获得较多的信息 (POI附近查询的信息比较多)
         */
        [self searchTipsWithKey:tf_search.text];//根据关键字获得经纬度
        [self searchPoiBySearchKey:tf_search.text];//根据关键字和经纬度 获得POI附近信息
        
    }
}

@end

#pragma mark - FGLocationSelectViewController(TableView)
@implementation FGLocationSelectViewController(TableView)
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 54 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AMapPOI *_poi = (AMapPOI *)[arr_data objectAtIndex:indexPath.row];
    if([_poi.address isEmptyStr])//如果没有地址信息 那么用名称代替
        _poi.address = _poi.name;
    
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//更新POI经纬度，以便下次查询
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENTADDRESS object:_poi.address];
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return [arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMeLocationSelectCell:tableView];
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMeLocationSelectCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGLocationSelectAddressCellView";
    FGLocationSelectAddressCellView *cell = (FGLocationSelectAddressCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGLocationSelectAddressCellView *)[nib objectAtIndex:0];
    }
    return cell;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [tf_search resignFirstResponder];
}

@end


#pragma mark - #pragma mark - FGLocationSelectViewController(POI)
@implementation FGLocationSelectViewController(POI)

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



#pragma mark - 地图搜索方法

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

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = lb_city.text;
    tips.cityLimit = YES; //是否限制城市
    
    [self.searchAPI AMapInputTipsSearch:tips];
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

#pragma mark - 地图回调
/* POI 搜索回调. 根据经纬度和关键词搜索周边POI信息*/
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        //NSLog(@"obj.name = %@ obj.address = %@ district=%@",obj.name,obj.address,obj.district);
        
    }];
    
    AMapPOI *_poi = response.pois.firstObject;
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.latitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
    [commond setUserDefaults:[NSNumber numberWithDouble:_poi.location.longitude] forKey:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];//更新POI经纬度，以便下次查询
    
    [arr_data removeAllObjects];
    [arr_data addObjectsFromArray:response.pois];
    [tb reloadData];//更新列表
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


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.searchAPI = nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}




@end
