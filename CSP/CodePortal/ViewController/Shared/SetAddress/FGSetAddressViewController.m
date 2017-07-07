//
//  FGSetAddressViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/5.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGSetAddressViewController.h"
#import "Global.h"
#import "FGLocationSelectAddressCellView.h"
@interface FGSetAddressViewController ()
{
    NSMutableArray *arr_data;
}


@end

@interface FGSetAddressViewController (TableView)<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end



@implementation FGSetAddressViewController
@synthesize view_setAddressMap;
@synthesize tb;
@synthesize tf_search;
@synthesize lb_city;
@synthesize view_separator_v;
@synthesize str_address;
@synthesize str_defaultAddressKEY;
#pragma mark - 生命周期


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)__str_address setDefaultAddressKEY:(NSString *)_str_setDefaultAddressKEY;
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.str_address = __str_address;
        self.str_defaultAddressKEY = _str_setDefaultAddressKEY;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"SELECT LCOATION");
    [self hideBottomPanelWithAnimtaion:NO];
    
    [commond useDefaultRatioToScaleView:tb];
    [commond useDefaultRatioToScaleView:tf_search];
    [commond useDefaultRatioToScaleView:lb_city];
    [commond useDefaultRatioToScaleView:view_separator_v];
    
    [self internalInitalAddressMapView];
    
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    
    lb_city.font = font(FONT_TEXT_REGULAR, 14);
    tf_search.font = font(FONT_TEXT_REGULAR, 14);
    tf_search.delegate = self;
    
    tb.delegate = self;
    tb.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldEditChanged:)
     name:UITextFieldTextDidChangeNotification
     object:tf_search];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.str_address = nil;
    self.str_defaultAddressKEY = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:tf_search];
}

-(void)buttonAction_left:(id)_sender
{
    if(str_defaultAddressKEY)
    {
        [commond setUserDefaults:tf_search.text forKey:str_defaultAddressKEY]; //KEY_DEFAULT_ADDRESS1 , KEY_DEFAULT_ADDRESS2
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
    [super buttonAction_left:_sender];
    
}

-(void)getCityNameIfHave
{
    NSString *_str_city = (NSString *)[commond getUserDefaults:KEY_CURRENTCITYNAME];
    if(_str_city && ![_str_city isEmptyStr])
    {
        lb_city.text = _str_city;
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [tf_search resignFirstResponder];
}

#pragma mark - 事件通知
-(void)textFieldEditChanged:(NSNotification *)obj
{
    // TODO: 需要做的逻辑处理
    UITextField *textField = (UITextField *)obj.object;
    if([textField isEqual:tf_search])
    {
        if(textField.markedTextRange)//markedTextRange 不为空 说明用了输入法 不处理以下代码
            return;
        
            /*
             由于searchTipsWithKey 获得的信息量比较少 我们只取坐标  然后根据获得的坐标
             联合 searchPoiBySearchKey 获得较多的信息 (POI附近查询的信息比较多)
             */
            [view_setAddressMap searchTipsWithKey:tf_search.text];//根据关键字获得经纬度
            [view_setAddressMap searchPoiBySearchKey:tf_search.text];//根据关键字和经纬度 获得POI附近信息
            
            
            /*更新地图的中心点*/
            id obj_lat = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LAT];
            id obj_lng = [commond getUserDefaults:KEY_CURRENT_AUTONAVI_COORDINATE_LNG];
            if(obj_lng && obj_lat)
            {
                CLLocationCoordinate2D _coordinate = CLLocationCoordinate2DMake([obj_lat doubleValue],[obj_lng doubleValue]);
                [view_setAddressMap.mapView setCenterCoordinate:_coordinate animated:YES];
                [view_setAddressMap.mapView setZoomLevel:17.2 animated:YES];
                
            }
    }
}

#pragma mark -  初始化
-(void)internalInitalAddressMapView
{
    if(view_setAddressMap)
        return;
    
    view_setAddressMap = (FGSetAddressMapView *)[[[NSBundle mainBundle] loadNibNamed:@"FGSetAddressMapView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_setAddressMap];
    CGRect _frame = view_setAddressMap.frame;
    _frame.origin.y = self.tf_search.frame.size.height + self.tf_search.frame.origin.y;
    _frame.size.height = 200 * ratioH;
    view_setAddressMap.frame = _frame;
    [self.view addSubview:view_setAddressMap];
    view_setAddressMap.layer.shadowColor = [UIColor blackColor].CGColor;
    view_setAddressMap.layer.shadowRadius = .5;
    view_setAddressMap.layer.shadowOffset = CGSizeMake(0,0);
    view_setAddressMap.layer.shadowOpacity = 1;
    
    _frame = tb.frame;
    _frame.origin.y = view_setAddressMap.frame.origin.y + view_setAddressMap.frame.size.height;
    _frame.size.height = H - _frame.origin.y;
    tb.frame = _frame;
    
}

-(void)realodData:(id)_data
{
    [arr_data removeAllObjects];
    [arr_data addObjectsFromArray:_data];
    [tb reloadData];
}
@end

#pragma mark - FGSetAddressViewController (TableView)
@implementation FGSetAddressViewController (TableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 54 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AMapPOI *_poi = (AMapPOI *)[arr_data objectAtIndex:indexPath.row];
    if([_poi.address isEmptyStr])//如果没有地址信息 那么用名称代替
        _poi.address = _poi.name;
    if(str_defaultAddressKEY)
    {
        
        [commond setUserDefaults:_poi.address forKey:str_defaultAddressKEY]; //KEY_DEFAULT_ADDRESS1 , KEY_DEFAULT_ADDRESS2
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
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

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
}
@end

