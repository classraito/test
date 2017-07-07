//
//  FGLocationFindATrainerViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindATrainerViewController.h"
#import "Global.h"
@interface FGLocationFindATrainerViewController ()
{
    NSString *str_trainingID;
    NSString *str_date;
    NSString *str_timeStr;
    BOOL isMultiClass;
}
@end

@implementation FGLocationFindATrainerViewController
@synthesize view_mapView;
@synthesize view_fillLocation;
@synthesize view_multiClassFillLocation;
#pragma mark - 初始化
/*
 @_str_trainingID : 教练ID
 @_str_date : 预订日期
 @timeStr: 预订时间
 @isMultiClass : 是否预订多节课程
 */

/*再次预订多节课程时 从这里初始化*/
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID dateStr:(NSString *)_str_date timeStr:(NSString *)_str_timeStr isMultiClass:(BOOL)_isMultiClass
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_trainingID = [_str_trainingID mutableCopy];
        str_date = [_str_date mutableCopy];
        str_timeStr = [_str_timeStr mutableCopy];
        isMultiClass = _isMultiClass;
        
    }
    return self;
}

/*再次预订单节课程时 从这里初始化*/
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID dateStr:(NSString *)_str_date timeStr:(NSString *)_str_timeStr
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_trainingID = [_str_trainingID mutableCopy];
        str_date = [_str_date mutableCopy];
        str_timeStr = [_str_timeStr mutableCopy];
        isMultiClass = NO;
        
    }
    return self;
}

/*首次预订单节课程时 从这里初始化*/
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_trainingID = @"";
        str_date = nil;
        str_timeStr = nil;
        isMultiClass = NO;
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self internalInitalMapView];
    view_mapView.view_addressBg.alpha = .8;
    [self hideBottomPanelWithAnimtaion:NO];
    
    if(isMultiClass)
    {
        [self internalInitalMultiClassFillLocation];
        [self setupMultiClassFillLocationView];//设置多个课程界面
        
    }//初始化预订多个课程界面
    else
    {
        [self internalInitalFillLocation];
        if(str_date)
        {
            if(!isMultiClass)
                [self setupFillLocationView];//设置单个课程界面
        }//单个课程rebook教练时的界面显示
        else
        {
            self.view_topPanel.str_title = multiLanguage(@"FIND A TRAINER");
        }//单个课程普通booking的界面显示
        
    }//初始化预订单个课程界面
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    if(view_fillLocation)
        [view_fillLocation removeAllInputView];
    if(view_multiClassFillLocation)
        [view_multiClassFillLocation removeAllInputView];
    
    view_mapView = nil;
    view_fillLocation = nil;
    view_multiClassFillLocation = nil;
    str_trainingID = nil;
    str_date = nil;
    str_timeStr = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CURRENTADDRESS object:nil];
}


#pragma mark - 初始化地图界面
/*初始化地图*/
-(void)internalInitalMapView
{
    if(view_mapView)
        return;
    view_mapView = (FGLocationFindATrainerMapView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationFindATrainerMapView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_mapView];
    CGRect _frame = view_mapView.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    _frame.size.height = H - self.view_topPanel.frame.size.height;
    view_mapView.frame = _frame;
    [self.view addSubview:view_mapView];
}

#pragma mark - 预订单个课程的表单
/*初始化单个课程的界面*/
-(void)internalInitalFillLocation
{
    if(view_fillLocation)
        return;
    
    
    view_fillLocation = (FGLocationFindATrainerFillLocationView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationFindATrainerFillLocationView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_fillLocation];
    CGRect _frame = view_fillLocation.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_fillLocation.frame = _frame;
    [self.view addSubview:view_fillLocation];
    [view_fillLocation setupByOriginalContentSize:view_fillLocation.bounds.size];
    
    [view_fillLocation.cb_bookNow.button addTarget:self action:@selector(buttonAction_bookNow:) forControlEvents:UIControlEventTouchUpInside];
    if(str_date)
        view_fillLocation.tf_date.text = str_date;
    if(str_timeStr)
        view_fillLocation.tf_time.text = str_timeStr;
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsure_hideFillLocation:)];
    _tap.cancelsTouchesInView = NO;
    _tap.delegate = self;
    _tap.enabled = YES;
    UIPanGestureRecognizer *_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(getsure_hideFillLocation:)];
    _pan.cancelsTouchesInView = NO;
//    _pan.delegate = self;
//    _pan.enabled = YES;
    [view_fillLocation addGestureRecognizer:_tap ];
    [view_fillLocation addGestureRecognizer:_pan ];
    _tap = nil;
    _pan = nil;
    
    _frame = view_fillLocation.frame;
    _frame.origin.y = self.view.frame.size.height;
    view_fillLocation.frame = _frame;
}

/*设置单个课程的界面*/
-(void)setupFillLocationView
{
    if(!view_fillLocation)
        return;
    
    view_fillLocation.tf_date.text = str_date;
    view_fillLocation.tf_time.text = str_timeStr;
    view_fillLocation.tf_date.userInteractionEnabled = NO;
    view_fillLocation.tf_time.userInteractionEnabled = NO;
    view_fillLocation.btn_date.userInteractionEnabled = NO;
    view_fillLocation.btn_time.userInteractionEnabled = NO;
    view_fillLocation.tf_date.textColor = [UIColor lightGrayColor];
    view_fillLocation.tf_time.textColor = [UIColor lightGrayColor];
    
    self.view_topPanel.str_title = multiLanguage(@"REBOOK TRAINER");
    self.view_fillLocation.cb_bookNow.lb_title.text = multiLanguage(@"REBOOK NOW");
    [self showFillLocation];

}

/*从上往下拉出单个课程的界面*/
-(void)hideFillLocation
{
    [UIView animateWithDuration:.3 animations:^{
        [view_fillLocation removeAllInputView];
        [view_fillLocation.tv_otherMessage resignFirstResponder];
        CGRect _frame = view_fillLocation.frame;
        _frame.origin.y = self.view.frame.size.height;
        view_fillLocation.frame = _frame;
        view_mapView.view_addressBg.alpha = .8;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

/*从下往上拉出单个课程的界面*/
-(void)showFillLocation
{
    [UIView animateWithDuration:.3 animations:^{
        CGRect _frame = view_fillLocation.frame;
        _frame.origin.y = self.view_topPanel.frame.size.height;
        view_fillLocation.frame = _frame;
        view_mapView.view_addressBg.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

/*单个课程界面数据检查*/
-(BOOL)isCheckDataPassed
{
    NSString *_str_failedReason = nil;
    NSString *_str_date = view_fillLocation.tf_date.text;
    NSString *_str_time = view_fillLocation.tf_time.text;
    NSString *_str_location = view_fillLocation.tf_location.text;
    NSString *_str_locationDeatil = view_fillLocation.lb_locationDetail_address.text;
    if(!_str_date || [_str_date isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking date");
    }
    if(!_str_time || [_str_time isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking time");
    }
    if(!_str_location || [_str_location isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking location");
    }
    if(!_str_locationDeatil || [_str_locationDeatil isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking location detail");
    }
    
    if(_str_failedReason)
    {
        [commond alert:multiLanguage(@"ALERT") message:_str_failedReason callback:nil];
        return NO;
    }
    return YES;
}

/*根据预订单个课程表单信息初始化支付模型*/
-(FGPaymentModel *)setupPaymentModel
{
    NSString *str_dateFormatter;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }
    NSString *_str_date = view_fillLocation.tf_date.text;
    NSString *_str_time = view_fillLocation.tf_time.text;
    NSString *_str_startTime = [_str_time componentsSeparatedByString:@" - "][0];
    NSString *_str_fullDate = [NSString stringWithFormat:@"%@ %@",_str_date,_str_startTime];
    NSString *_str_fullFormatter = [NSString stringWithFormat:@"%@ %@",str_dateFormatter,@"HH:mm"];
    
    NSDate *date = [commond dateFromString:_str_fullDate formatter:_str_fullFormatter];
    long since1970 = [date timeIntervalSince1970]; //将时间转换为 自1970年开始的秒数
    
    FGLocationManagerWrapper *wrapper = [FGLocationManagerWrapper sharedManager];
    long _lat = [commond EnCodeCoordinate:wrapper.currentLatitude];
    long _lng = [commond EnCodeCoordinate:wrapper.currentLontitude];
    
    NSString *_str_address = view_fillLocation.tf_location.text;
    NSString *_str_addressDetail = view_fillLocation.lb_locationDetail_address.text;
    NSString *_str_otherMessage = view_fillLocation.tv_otherMessage.text;
    
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    paymentModel.str_trainerId = str_trainingID;
    paymentModel.bookTime = since1970;
    paymentModel.lat = _lat;
    paymentModel.lng = _lng;
    paymentModel.str_address = _str_address;
    paymentModel.str_addressDetail = _str_addressDetail;
    paymentModel.str_otherMessage = _str_otherMessage;

    return paymentModel;
}

/*根据预订多个课程表单信息初始化支付模型*/
-(FGPaymentModel *)setupMultiPaymentModel
{

    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    paymentModel.str_trainerId = str_trainingID;
   /* paymentModel.multiClass_startDate = since1970;  //TODO: 预订多个订单时的开始时间
    paymentModel.arr_multiClass_bookClocks = nil;//TODO: 预订多个订单时的时钟时间
    paymentModel.multiClass_numberOfTimes = 0; //TODO: 预订多个订单时的循环次数*/
    
    FGLocationManagerWrapper *wrapper = [FGLocationManagerWrapper sharedManager];
    long _lat = [commond EnCodeCoordinate:wrapper.currentLatitude];
    long _lng = [commond EnCodeCoordinate:wrapper.currentLontitude];
    NSString *_str_address = view_multiClassFillLocation.tf_location.text;
    NSString *_str_addressDetail = view_multiClassFillLocation.lb_locationDetail_address.text;
    NSString *_str_otherMessage = view_multiClassFillLocation.tv_otherMessage.text;
    
    paymentModel.lat = _lat;
    paymentModel.lng = _lng;
    paymentModel.str_address = _str_address;
    paymentModel.str_addressDetail = _str_addressDetail;
    paymentModel.str_otherMessage = _str_otherMessage;
    
    return paymentModel;
}

#pragma mark - 预订多个课程的表单
/*初始化多个课程界面*/
-(void)internalInitalMultiClassFillLocation
{
    if(view_multiClassFillLocation)
        return;
    view_multiClassFillLocation = (FGLocationFindAMultiClassFillLocationView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationFindAMultiClassFillLocationView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_multiClassFillLocation];
    CGRect _frame = view_multiClassFillLocation.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_fillLocation.frame = _frame;
    [self.view addSubview:view_multiClassFillLocation];
    [view_multiClassFillLocation setupByOriginalContentSize:view_multiClassFillLocation.bounds.size];
    
    [view_multiClassFillLocation.cb_bookNow.button addTarget:self action:@selector(buttonAction_bookNow:) forControlEvents:UIControlEventTouchUpInside];
    if(str_date)
        view_multiClassFillLocation.tf_date.text = str_date;
    if(str_timeStr)
        view_multiClassFillLocation.tf_time.text = str_timeStr;
    
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsure_hideFillLocation:)];
    _tap.cancelsTouchesInView = NO;
    _tap.delegate = self;
    _tap.enabled = YES;
    UIPanGestureRecognizer *_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(getsure_hideFillLocation:)];
    _pan.cancelsTouchesInView = NO;
    //    _pan.delegate = self;
    //    _pan.enabled = YES;
    [view_multiClassFillLocation addGestureRecognizer:_tap ];
    [view_multiClassFillLocation addGestureRecognizer:_pan ];
    _tap = nil;
    _pan = nil;
    
    _frame = view_multiClassFillLocation.frame;
    _frame.origin.y = self.view.frame.size.height;
    view_multiClassFillLocation.frame = _frame;
}

/*设置多个课程界面*/
-(void)setupMultiClassFillLocationView
{
    if(!view_multiClassFillLocation)
        return;
    
    view_multiClassFillLocation.tf_date.text = str_date;
    view_multiClassFillLocation.tf_date.userInteractionEnabled = NO;
    view_multiClassFillLocation.tf_time.userInteractionEnabled = NO;
    view_multiClassFillLocation.btn_date.userInteractionEnabled = NO;
    view_multiClassFillLocation.btn_time.userInteractionEnabled = NO;
    view_multiClassFillLocation.tf_date.textColor = [UIColor lightGrayColor];
    view_multiClassFillLocation.tf_time.textColor = [UIColor lightGrayColor];
    
    self.view_topPanel.str_title = multiLanguage(@"REBOOK TRAINER");
    self.view_multiClassFillLocation.cb_bookNow.lb_title.text = multiLanguage(@"NEXT");//TODO:text change
    [self showMultiClassFillLocation];
}

/*从上往下拉回多个课程的界面*/
-(void)hideMultiClassFillLocation
{
    [UIView animateWithDuration:.3 animations:^{
        [view_multiClassFillLocation removeAllInputView];
        [view_multiClassFillLocation.tv_otherMessage resignFirstResponder];
        CGRect _frame = view_multiClassFillLocation.frame;
        _frame.origin.y = self.view.frame.size.height;
        view_multiClassFillLocation.frame = _frame;
        view_mapView.view_addressBg.alpha = .8;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

/*从下往上拉出多个课程的界面*/
-(void)showMultiClassFillLocation
{
    [UIView animateWithDuration:.3 animations:^{
        CGRect _frame = view_multiClassFillLocation.frame;
        _frame.origin.y = self.view_topPanel.frame.size.height;
        view_multiClassFillLocation.frame = _frame;
        view_mapView.view_addressBg.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

/*多个课程数据检查*/
-(BOOL)isMultiClassCheckDataPassed
{
    NSString *_str_failedReason = nil;
    NSString *_str_location = view_multiClassFillLocation.tf_location.text;
    NSString *_str_locationDeatil = view_multiClassFillLocation.lb_locationDetail_address.text;
    if(!_str_location || [_str_location isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking location");
    }
    if(!_str_locationDeatil || [_str_locationDeatil isEmptyStr])
    {
        _str_failedReason = multiLanguage(@"Please fill in booking location detail");
    }

    if(_str_failedReason)
    {
        [commond alert:multiLanguage(@"ALERT") message:_str_failedReason callback:nil];
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate  用于在指定区域内接收手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
        CGPoint currentPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    
        if([gestureRecognizer.view isKindOfClass:[FGLocationFindAMultiClassFillLocationView class]])
        {
            if (CGRectContainsPoint(CGRectMake(0, 0, W, view_multiClassFillLocation.view_panel.frame.origin.y), currentPoint) ) {
                return YES;
            }
        }//如果在预订多个课程的背景区域内的手势则向下传递
        else if([gestureRecognizer.view isKindOfClass:[FGLocationFindATrainerFillLocationView class]])
        {
            if (CGRectContainsPoint(CGRectMake(0, 0, W, view_fillLocation.view_panel.frame.origin.y), currentPoint) ) {
                return YES;
            }
        }//如果在预订单个课程的背景区域内的手势则向下传递
    return NO;
}

#pragma mark - gesture show map
/*隐藏表单事件*/
-(void)getsure_hideFillLocation:(id)_sender
{
    NSLog(@"_sender = %@",_sender);
    if([_sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *_pan = (UIPanGestureRecognizer *)_sender;
        CGPoint _velocity = [_pan velocityInView:_pan.view];
        NSLog(@"_velocity = %@",NSStringFromCGPoint(_velocity));
        if(_velocity.y > 0 )//向下滑动时
        {
            if(isMultiClass)
                [self hideMultiClassFillLocation]; //隐藏多个课程表单
            else
                [self hideFillLocation]; //隐藏单个课程表单
            
        }
    }//滑动手势时
    else
    {
        if(isMultiClass)
        {
            [self hideMultiClassFillLocation]; //隐藏多个课程表单
        }
        else
        {
             [self hideFillLocation];//隐藏单个课程表单
        }
       
    }//点击手势时
}

/*进入到教练接受界面*/
-(void)go2RequestSended
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGPopupViewController *vc_popup = [[FGPopupViewController alloc] initWithNibName:@"FGPopupViewController" bundle:nil];
    [vc_popup inital_location_requestSended];
    [manager pushController:vc_popup navigationController:nav_current];
}

#pragma mark - buttonAction
/*预订按钮*/
-(void)buttonAction_bookNow:(id)_sender
{
    if(view_multiClassFillLocation)
    {
        if(![self isMultiClassCheckDataPassed])
            return;
    }//多个课程界面的数据检查
    else if(view_fillLocation)
    {
        if(![self isCheckDataPassed])
            return;
    }//单个课程界面的数据检查
   
    if(![commond isUser])
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Trainer can not book a trainer") callback:nil];
    }//教练不能预订一个教练
    
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees lat, CLLocationDegrees lng) {
       if(lat != DEFAULT_LATITUDE && lng != DEFAULT_LONTITUDE)
       {
           NSString *str_message = multiLanguage(@"Do you want to book a trainer now?");
           if(isMultiClass)
               str_message = multiLanguage(@"Do you want to book a trainer now?");//TODO: text change
           
           [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:str_message callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
               if(buttonIndex == 0)
               {
                   if(isMultiClass)
                   {
                       [self go2BookMultiClassPIckDateVC];
                   }
                   else
                   {
                       [self postRequest_preCheckOrder];   //预检查状态 ，如果订单异常 就取消 然后再预订
                       FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
                       if([paymentModel.str_trainerId isEmptyStr])
                           [NetworkEventTrack track:KEY_MIXPANEL_EVENTID_BOOKNOW attrs:nil]; //mixpanel数据 用户点击了预订教练
                       else
                           [NetworkEventTrack track:KEY_MIXPANEL_EVENTID_REBOOK attrs:nil];  //mixpanel数据 用户点击了再次预订教练
                   }
                   
                   
               }
           }];
       }
    }];
}

-(void)go2BookMultiClassPIckDateVC
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationBookMultiClassPIckDateViewController *vc_bookMulti = [[FGLocationBookMultiClassPIckDateViewController alloc] initWithNibName:@"FGLocationBookMultiClassPIckDateViewController" bundle:nil];
    [manager pushController:vc_bookMulti navigationController:nav_current];
    
    [self setupMultiPaymentModel];
}

/*预检查订单状态接口*/
-(void)postRequest_preCheckOrder
{
    if(!view_fillLocation)
        return;
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [_dic_info setObject:@"preCheckOrder" forKey:@"preCheckOrder"];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkOrder:_dic_info];
}

-(void)postRequest_book
{
    
    FGPaymentModel *paymentModel = [self setupPaymentModel];
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    

    
    [[NetworkManager_Location sharedManager] postRequest_Locations_orderTrain:paymentModel.str_trainerId bookTime:paymentModel.bookTime Lat:paymentModel.lat Lng:paymentModel.lng address:paymentModel.str_address addressDetail:paymentModel.str_addressDetail otherMsg:paymentModel.str_otherMessage userinfo:_dic_info];
    

}

#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    //预检查有没有已发送的订单请求
    if ([HOST(URL_LOCATION_CheckOrder) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:@"preCheckOrder"])
        {
            NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckOrder)];
            NSLog(@"_dic_result = %@",_dic_result);
            int Code = [[_dic_result objectForKey:@"Code"] intValue];
            if(Code == 0)
            {
                int orderStatus = [[_dic_result objectForKey:@"Status"] intValue];
                FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
                paymentModel.str_currentRequestedOrderId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"OrderId"]];
                paymentModel.str_trainerId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"TrainerId"]];
                paymentModel.oneSessionPrice = [[_dic_result objectForKey:@"Price"] floatValue];
                paymentModel.sessionCount = [[_dic_result objectForKey:@"SessionCount"] intValue];
                NSLog(@"paymentModel.sessionCount = %d",paymentModel.sessionCount);
                paymentModel.str_trainerId = str_trainingID;
                paymentModel.bookTime = [[_dic_result objectForKey:@"BookTime"] longValue];
                paymentModel.lat = [[_dic_result objectForKey:@"Lat"] longValue];
                paymentModel.lng = [[_dic_result objectForKey:@"Lng"] longValue];
                paymentModel.str_address = [_dic_result objectForKey:@"Address"];
                paymentModel.str_addressDetail = [_dic_result objectForKey:@"AddressDetial"];;
                paymentModel.str_otherMessage = [_dic_result objectForKey:@"OtherMsg"];
                
                paymentModel.currentRequestedOrderStatus = orderStatus;
                NSLog(@"orderStatus = %d",orderStatus);
                //0:订单已取消
                //1:订单已发送
                //2:订单已接受
                //3:订单已付款
                //4:订单已完成
                //5:订单已评论
                if(orderStatus == OrderStatus_Sended || orderStatus == OrderStatus_Accepted)//订单发送状态或接受状态
                {
                    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
                    [[NetworkManager_Location sharedManager] postRequest_Locations_orderCancel:paymentModel.str_currentRequestedOrderId userinfo:_dic_info];
                }
            }//取消前一个订单
            else
            {
                [self postRequest_book];
            }//发送新订单
        }
    }
    
    if([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url])
    {
         [self postRequest_book];
    }//取消上一个订单后 再定
    
   
    if ([HOST(URL_LOCATION_OrderTrain) isEqualToString:_str_url]) {
        if(view_fillLocation)
        {
            NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderTrain)];
            int resultCode = [[_dic_info objectForKey:@"Code"] intValue];
            if(resultCode == 0)
            {
                if([[_dic_requestInfo allKeys] containsObject:@"SendAgain"])
                {
                    [self go2RequestSended];
                }
                else
                {
                    [self go2RequestSended];
                }

            }
        }
        
    }
    
}


@end
