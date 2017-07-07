//
//  FGLocationPopupViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupViewController.h"
#import "Global.h"
@interface FGPopupViewController ()
{
    FGPaymentModel *paymentModel;
}
@end

@implementation FGPopupViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self hideTitle];
    [self hideBottomPanelWithAnimtaion:NO];
    paymentModel = [FGPaymentModel sharedModel];
}

-(void)showTitle:(NSString *)_str_title
{
    self.view_topPanel.hidden = NO;
    self.view_topPanel.str_title = _str_title;
    self.view_topPanel.iv_left.hidden = YES;
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_left.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)hideTitle
{
    self.view_topPanel.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
    view_location_requestSended = nil;
    view_location_noAccept = nil;
    view_payment_requestAccepted = nil;
}



#pragma mark - 初始化
-(void)inital_bookingDeatilWithInfo:(NSDictionary *)_dic_info {
  if(view_bookingDetailInfo)
    return;
  
  view_bookingDetailInfo = (FGBookingDetailInfoPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookingDetailInfoPopView" owner:nil options:nil] objectAtIndex:0];
  [view_bookingDetailInfo setupBookingDetailWithInfo:_dic_info];
  [commond useDefaultRatioToScaleView:view_bookingDetailInfo];
  [self.view addSubview:view_bookingDetailInfo];
  self.view_topPanel.hidden = YES;
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
  [view_bookingDetailInfo.btn_cancel addTarget:self action:@selector(buttonAction_backToBookingList:) forControlEvents:UIControlEventTouchUpInside];
  
}
//============location->requestSended

-(void)inital_badgeInfoWithInfo:(NSDictionary *)_dic_info {
  if(view_badgeInfo)
    return;
  view_badgeInfo = (FGBadgeDetailInfoPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBadgeDetailInfoPopView" owner:nil options:nil] objectAtIndex:0];
  [view_badgeInfo setupBadgeWithInfo:_dic_info];
  [commond useDefaultRatioToScaleView:view_badgeInfo];
  [self.view addSubview:view_badgeInfo];
  self.view_topPanel.hidden = YES;
  [[UIApplication sharedApplication] setStatusBarHidden:NO];

  [view_badgeInfo.btn_cancel addTarget:self action:@selector(buttonAction_backToBadgeList:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)inital_location_requestSended
{
    if(view_location_requestSended)
        return;
    [paymentModel resetPayment_requestOrder];
    
    view_location_requestSended = (FGLocationRequestSendedPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationRequestSendedPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_location_requestSended];
    [self.view addSubview:view_location_requestSended];
    [self hideTitle];
    [self fadeinView:view_location_requestSended];
    [view_location_requestSended.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_location_requestSended postRequest_location_requestSended_checkOrder];
}

//==============location->noAccepting
-(void)inital_location_noAccepting
{
    if(view_location_noAccept)
        return;
    view_location_noAccept = (FGLocationNoAcceptingPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationNoAcceptingPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_location_noAccept];
    [self.view addSubview:view_location_noAccept];
    [self hideTitle];
    [self fadeinView:view_location_noAccept];
    [view_location_noAccept.btn_sendAgain addTarget:self action:@selector(buttonAction_location_noAccepting_sendAgain:) forControlEvents:UIControlEventTouchUpInside];
    [view_location_noAccept.btn_cancel addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
}

//==============location->joinGroup
-(FGLocationJoinGroupPopView *)inital_joinGroup
{
    if(view_joinGroup)
        return view_joinGroup;
    view_joinGroup = (FGLocationJoinGroupPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationJoinGroupPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_joinGroup];
    [self.view addSubview:view_joinGroup];
    [self hideTitle];
    [self fadeinView:view_joinGroup];
    
    [view_joinGroup.btn_done addTarget:self action:@selector(buttonAction_joinGroup_done:) forControlEvents:UIControlEventTouchUpInside];
    [view_joinGroup.btn_share addTarget:self action:@selector(buttonAction_joinGroup_share:) forControlEvents:UIControlEventTouchUpInside];
    
    return view_joinGroup;
}




-(void)buttonAction_joinGroup_done:(id)_sender
{
    SAFE_RemoveSupreView(view_joinGroup);
    view_joinGroup = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)buttonAction_joinGroup_share:(id)_sender
{
    SAFE_RemoveSupreView(view_joinGroup);
    view_joinGroup = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
    
  // FIXME: share
//  [[FGSNSManager shareInstance] actionToShareWithTitle:@"" text:@"" url:@"" images:@[]];
  [[FGSNSManager shareInstance] actionToShareTrainingOnView:self.view
                                                      title:@""
                                                       text:[NSString stringWithFormat:@"%@;%@;%@",                         share_training_content1,                                     share_training_content2,share_training_link]
                                                        url:share_training_link];
}


//==============payment->requestAccepted
-(void)inital_payment_requestAccepted
{
    if(view_payment_requestAccepted)
        return;
    view_payment_requestAccepted = (FGPaymentRequestAcceptedPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPaymentRequestAcceptedPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_payment_requestAccepted];
    [self.view addSubview:view_payment_requestAccepted];
    [self hideTitle];
    [self fadeinView:view_payment_requestAccepted];
    [view_payment_requestAccepted.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_requestAccepted.btn_pay1Session addTarget:self action:@selector(buttonAction_payment_requestAccepted_pay1Session:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_requestAccepted.btn_go2PayBundle addTarget:self action:@selector(buttonAction_payment_requestAccepted_payBundle:) forControlEvents:UIControlEventTouchUpInside];
    [self postReuqest_getTrainerProfile];
}

//==============payment->buyBundle
-(void)inital_payment_buyBundle
{
    if(view_payment_buyBundle)
        return;
    view_payment_buyBundle = (FGPaymentBuyBundlePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPaymentBuyBundlePopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_payment_buyBundle];
    [self.view addSubview:view_payment_buyBundle];
    [self hideTitle];
    [self fadeinView:view_payment_buyBundle];
    [view_payment_buyBundle.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_buyBundle.btn_confirmToPay addTarget:self action:@selector(buttonAction_buyBundle_confirmToPay:) forControlEvents:UIControlEventTouchUpInside];
}

//==============payment->bundleBuyed
-(void)inital_payment_bundleBuyed
{
    if(view_payment_bundleBuyed)
        return;
    view_payment_bundleBuyed = (FGPaymentBundleBuyedPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPaymentBundleBuyedPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_payment_bundleBuyed];
    [self.view addSubview:view_payment_bundleBuyed];
    [self hideTitle];
    [self fadeinView:view_payment_bundleBuyed];
    [view_payment_bundleBuyed.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_bundleBuyed.btn_use1BundleSession addTarget:self action:@selector(buttonAction_bundleBuyed_use1Bundle:) forControlEvents:UIControlEventTouchUpInside];
    
}

//==============payment->buy1Session
-(void)inital_payment_buy1Session
{
    if(view_payment_buy1Session)
        return;
    view_payment_buy1Session = (FGPaymentBuy1SessionPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPaymentBuy1SessionPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_payment_buy1Session];
    [self.view addSubview:view_payment_buy1Session];
    [self hideTitle];
    [self fadeinView:view_payment_buy1Session];
    [view_payment_buy1Session.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_buy1Session.btn_confirmToPay addTarget:self action:@selector(buttonAction_buy1Session_confirmToPay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self postRequest_getCouponList];
}

//==============payment->requestAccepted_haveBundle
-(void)inital_payment_requestAccepted_haveBundle
{
    if(view_payment_requestAccepted_haveBundle)
        return;
    view_payment_requestAccepted_haveBundle = (FGPaymentRequestAcceptedHaveBundlePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPaymentRequestAcceptedHaveBundlePopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_payment_requestAccepted_haveBundle];
    [self.view addSubview:view_payment_requestAccepted_haveBundle];
    [self hideTitle];
    [self fadeinView:view_payment_requestAccepted_haveBundle];
    [view_payment_requestAccepted_haveBundle.btn_cancelRequest addTarget:self action:@selector(buttonAction_cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_requestAccepted_haveBundle.btn_pay1Session addTarget:self action:@selector(buttonAction_payment_requestAccepted_haveBundle_pay1Session:) forControlEvents:UIControlEventTouchUpInside];
    [view_payment_requestAccepted_haveBundle.btn_payByBundle addTarget:self action:@selector(buttonAction_payment_requestAccepted_haveBundle_payBundle:) forControlEvents:UIControlEventTouchUpInside];
    [self postReuqest_getTrainerProfile];
    
}

//==============book->sucess
-(void)inital_book_sucess
{
    if(view_bookSucess)
        return;
    view_bookSucess = (FGBookSucessPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookSucessPopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_bookSucess];
    [self.view addSubview:view_bookSucess];
    [self hideTitle];
    [self fadeinView:view_bookSucess];
    [view_bookSucess.btn_done addTarget:self action:@selector(buttonAction_bookSucess_done:) forControlEvents:UIControlEventTouchUpInside];
}

//==============invitationCode->inputInvitationCode
-(void)inital_inputInvitationCode;
{
    if(view_inputInvitationCode)
        return;
    view_inputInvitationCode = (FGInputInvitationCodePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGInputInvitationCodePopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_inputInvitationCode];
    [view_inputInvitationCode setupByOriginalContentSize:view_inputInvitationCode.bounds.size];
    [self.view addSubview:view_inputInvitationCode];
    [self hideTitle];
    [self fadeinView:view_inputInvitationCode];
    [view_inputInvitationCode.btn_done addTarget:self action:@selector(buttonAction_inputInvitationCode_done:) forControlEvents:UIControlEventTouchUpInside];
    [view_inputInvitationCode.btn_cancel addTarget:self action:@selector(buttonAction_inputInvitationCode_cancel:) forControlEvents:UIControlEventTouchUpInside];
}

//==============feedback->writeFeedback
-(void)inital_writeFeedback;
{
    if(view_writeFeedback)
        return;
    view_writeFeedback = (FGWriteFeedBackView *)[[[NSBundle mainBundle] loadNibNamed:@"FGWriteFeedBackView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_writeFeedback];
    [view_writeFeedback setupByOriginalContentSize:view_writeFeedback.bounds.size];
    [self.view addSubview:view_writeFeedback];
    [self showTitle:multiLanguage(@"WRITE FEEDBACK")];
    [self fadeinView:view_writeFeedback];
}

//==============feedback->adviceToBuyBundle
-(void)inital_adviceToBuyBundle;
{
    if(view_adviceToBuyBundle)
        return;
    view_adviceToBuyBundle = (FGAdviceBuyBundlePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGAdviceBuyBundlePopView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_adviceToBuyBundle];
    [self.view addSubview:view_adviceToBuyBundle];
    [self hideTitle];
    [self fadeinView:view_adviceToBuyBundle];
}

#pragma mark - 动画
-(void)fadeinView:(UIView *)_aView
{
    _aView.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        _aView.alpha = 1;
    }completion:^(BOOL finished) {
    }];
}


#pragma mark - 跳转
-(void)go2NoRequestAccepting
{
    [view_location_requestSended cancelTimer];
    SAFE_RemoveSupreView(view_location_requestSended);
    view_location_requestSended = nil;
    [self inital_location_noAccepting];
}

-(void)go2InputInviteCode
{
    SAFE_RemoveSupreView(view_payment_buy1Session);
    view_payment_buy1Session = nil;
    [self inital_inputInvitationCode];
}

- (void)buttonAction_backToBookingList:(id)_sender {
//  SAFE_RemoveSupreView(view_bookingDetailInfo);
//  view_bookingDetailInfo = nil;
  [nav_current dismissViewControllerAnimated:YES completion:^{
    SAFE_RemoveSupreView(view_bookingDetailInfo);
    view_bookingDetailInfo = nil;
  }];
}

- (void)buttonAction_backToBadgeList:(id)_sender {
  [nav_current dismissViewControllerAnimated:YES completion:^{
    SAFE_RemoveSupreView(view_badgeInfo);
    view_badgeInfo = nil;
  }];
}

-(void)go2PaymentSuccess
{
    if(view_payment_buy1Session)
    {
        SAFE_RemoveSupreView(view_payment_buy1Session);
        view_payment_buy1Session = nil;
    }
    if(view_payment_bundleBuyed)
    {
        SAFE_RemoveSupreView(view_payment_bundleBuyed)
        view_payment_bundleBuyed = nil;
    }
    if(view_payment_requestAccepted_haveBundle)
    {
        SAFE_RemoveSupreView(view_payment_requestAccepted_haveBundle);
        view_payment_requestAccepted_haveBundle = nil;
    }
    
    [self inital_book_sucess];
    
}

-(void)go2BundleBuyed
{
    if(view_payment_buyBundle)
    {
        SAFE_RemoveSupreView(view_payment_buyBundle);
        view_payment_buyBundle = nil;
        [self inital_payment_bundleBuyed];
    }
}

#pragma mark - 按钮事件
-(void)buttonAction_cancelRequest:(id)_sender
{
    [self postRequest_location_cancelRequest];
}

-(void)buttonAction_location_noAccepting_sendAgain:(id)_sender
{
    SAFE_RemoveSupreView(view_location_noAccept);
    view_location_noAccept = nil;
    [nav_current popViewControllerAnimated:NO];
    
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"SendAgain" forKey:@"SendAgain"];
    [[NetworkManager_Location sharedManager] postRequest_Locations_orderTrain:paymentModel.str_trainerId bookTime:paymentModel.bookTime Lat:paymentModel.lat Lng:paymentModel.lng address:paymentModel.str_address addressDetail:paymentModel.str_addressDetail otherMsg:paymentModel.str_otherMessage userinfo:_dic_info];
    NSLog(@":::::::>%s %d paymentModel.str_trainerId = %@",__FUNCTION__,__LINE__,paymentModel.str_trainerId);
}

-(void)buttonAction_payment_requestAccepted_pay1Session:(id)_sender
{
    SAFE_RemoveSupreView(view_payment_requestAccepted);
    view_payment_requestAccepted = nil;
    [self inital_payment_buy1Session];
}

-(void)buttonAction_payment_requestAccepted_payBundle:(id)_sender
{
    SAFE_RemoveSupreView(view_payment_requestAccepted);
    view_payment_requestAccepted = nil;
    [self inital_payment_buyBundle];
    NSLog(@":::::>购买3000元的课程卡");
}

-(void)buttonAction_payment_requestAccepted_haveBundle_pay1Session:(id)_sender
{
    SAFE_RemoveSupreView(view_payment_requestAccepted_haveBundle);
    view_payment_requestAccepted_haveBundle = nil;
    [self inital_payment_buy1Session];
}

-(void)buttonAction_payment_requestAccepted_haveBundle_payBundle:(id)_sender
{
    [self postRequest_buyLesson_useBundle];
}

-(void)buttonAction_inputInvitationCode_done:(id)_sender
{
    if(!view_inputInvitationCode)
        return;
    
    NSString *_str_invitationCode = view_inputInvitationCode.tf_invitationCode.text;
    if(_str_invitationCode && ![_str_invitationCode isEmptyStr])
    {
        
         [self postRequest_verifyInvitationCode];
    }
    else
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"please fill in invitation code.") callback:nil];
    }
   
}

-(void)buttonAction_inputInvitationCode_cancel:(id)_sender
{
    SAFE_RemoveSupreView(view_inputInvitationCode);
    view_inputInvitationCode = nil;
    [self inital_payment_buy1Session];
}

-(void)buttonAction_bundleBuyed_use1Bundle:(id)_sender
{
    [self postRequest_getBundleList];
   
}

-(void)buttonAction_buyBundle_confirmToPay:(id)_sender
{
    [self postRequest_buyBundle];
    NSLog(@":::::>点击购买课程");
}

-(void)buttonAction_buy1Session_confirmToPay:(id)_sender
{
    [self postRequest_buyLesson];
}

-(void)buttonAction_bookSucess_done:(id)_sender
{
    SAFE_RemoveSupreView(view_bookSucess);
    [self buttonAction_left:nil];
}
@end


#pragma mark - FGPopupViewController (Network)
@implementation FGPopupViewController(Network)
#pragma mark - postRequest
- (void)postRequest_trainerAcceptOrderWithOrderId:(NSString *)_str_orderId {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerAcceptOrderBetweenTwoCourses" forKey:@"trainerAcceptOrderBetweenTwoCourses"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_update_OrderAccept:_str_orderId absoulte:YES userinfo:_dic_info];
}

-(void)postRequest_getBundleList
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_bundleList:_dic_info];
}

-(void)postRequest_location_cancelRequest
{
    if(!paymentModel.str_currentRequestedOrderId)
        return;
    
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_orderCancel:paymentModel.str_currentRequestedOrderId userinfo:_dic_info];
}

-(void)postReuqest_getTrainerProfile
{
    [commond showLoading];
    NSString *_str_trainerId = paymentModel.str_trainerId;
    
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Profile sharedManager] postRequest_Profile_GetTrainerProfile:_str_trainerId userinfo:_dic_info];
}

-(void)postRequest_getCouponList
{
    
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_couponList:_dic_info];
}

-(void)postRequest_verifyInvitationCode
{
    if(!view_inputInvitationCode)
        return;
    
    view_inputInvitationCode.lb_warningInfo.hidden = YES;
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_invitationExchange:view_inputInvitationCode.tf_invitationCode.text userinfo:_dic_info];
}

-(void)postRequest_buyLesson
{
    NSString *str_orderId =  paymentModel.str_currentRequestedOrderId;
    NSMutableArray *arr_coupons = [paymentModel.dic_coupon_inviteCodeInfo objectForKey:@"Coupons"];
    NSMutableDictionary *dic_inviteCoupons = [paymentModel.dic_coupon_inviteCodeInfo objectForKey:@"InviteCoupon"];
    
     NSMutableArray *_arr_couponIDs = [NSMutableArray arrayWithCapacity:1];
    NSString *_str_inviteCoupon = @"";
    
    if(paymentModel.paymentCouponType == PaymentCouponType_InviteCoupon)
    {
        if([[dic_inviteCoupons allKeys] count]>0)
        {
            _str_inviteCoupon = [dic_inviteCoupons objectForKey:@"CouponId"];
        }//邀请码优惠券信息
    }
    else if(paymentModel.paymentCouponType == PaymentCouponType_Normal)
    {
        for(NSMutableDictionary *_dic_singleinfo in arr_coupons)
        {
            NSString *_str_couponId = [_dic_singleinfo objectForKey:@"CouponId"];
            [_arr_couponIDs addObject:_str_couponId];
        }//普通优惠券信息
    }
    
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkByLesson:str_orderId coupons:_arr_couponIDs inviteCoupon:_str_inviteCoupon bundle:(NSMutableArray *)@[] gatewary:paymentModel.paymentGateWay userinfo:_dic_info];
    

}

-(void)postRequest_buyLesson_useBundle
{
    NSString *str_orderId =  paymentModel.str_currentRequestedOrderId;
    NSString *_str_bundleLId = @"";
    NSMutableArray *_arr_bundleList = [NSMutableArray arrayWithCapacity:1];
    if([paymentModel.arr_bundles count] > 0)
    {
        for(NSMutableDictionary *_dic_bundle in paymentModel.arr_bundles)
        {
            _str_bundleLId = [_dic_bundle objectForKey:@"BundleId"];
            [_arr_bundleList addObject:_str_bundleLId];
        }
        
    }

    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkByLesson:str_orderId coupons:nil  inviteCoupon:@"" bundle:_arr_bundleList gatewary:PaymentGateWay_JustUseTicket userinfo:_dic_info];
    

    
}

-(void)postRequest_buyBundle
{
    NSString *_str_bundleLessonId = @"";
    if([paymentModel.arr_bundleLessons count] > 0)
    {
        _str_bundleLessonId = [[paymentModel.arr_bundleLessons objectAtIndex:0] objectForKey:@"BundleLessonId"];
    }
    NSLog(@"::::>请求购买课程卡:%@",paymentModel.arr_bundleLessons);
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkBuyBundle:_str_bundleLessonId gateWay:paymentModel.paymentGateWay userinfo:_dic_info];
    
}

-(void)postRequest_checkOrderDetail
{
    NSLog(@"::::>刷新请求订单状态，获得异步支付结果");
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"From3rdPayment" notifyOnVC:nil];
    [[NetworkManager_Location sharedManager] postRequest_Locations_orderDetailWithOrderId:paymentModel.str_currentRequestedOrderId userinfo:_dic_info];
}

-(void)postRequest_getBundleInfo
{
    NSLog(@":::::>刷新请求订单状态，获得异步购买课程卡结果");
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"From3rdPayment" notifyOnVC:nil];
    [[NetworkManager_Location sharedManager] postRequest_Locations_GetBundleInfo:_dic_info];
}

#pragma mark - 从父类继承的
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  
    //=====================检查订单状态=========================
    if ([HOST(URL_LOCATION_CheckOrder) isEqualToString:_str_url]) {
        if(view_location_requestSended)
        {
            
            [view_location_requestSended setupProgressOnce];
            [view_location_requestSended updateAcceptStatus];
        }
        
    }
    
    //=====================取消订单=======================
    if([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url])
    {
        if(view_location_requestSended)
        {
            [view_location_requestSended cancelTimer];
            SAFE_RemoveSupreView(view_location_requestSended);
            [self buttonAction_left:nil];
        }
        if(view_payment_requestAccepted)
        {
            SAFE_RemoveSupreView(view_payment_requestAccepted);
            [self buttonAction_left:nil];
        }
        if(view_location_noAccept)
        {
            SAFE_RemoveSupreView(view_location_noAccept);
            [self buttonAction_left:nil];
        }
        if(view_payment_buyBundle)
        {
            SAFE_RemoveSupreView(view_payment_buyBundle);
            [self buttonAction_left:nil];
        }
        if(view_payment_requestAccepted_haveBundle)
        {
            SAFE_RemoveSupreView(view_payment_requestAccepted_haveBundle);
            [self buttonAction_left:nil];
        }
        if(view_payment_buy1Session)
        {
            SAFE_RemoveSupreView(view_payment_buy1Session);
            [self buttonAction_left:nil];
        }
        if(view_payment_bundleBuyed)
        {
            SAFE_RemoveSupreView(view_payment_bundleBuyed)
            [self buttonAction_left:nil];
        }
        
    }
    
    //========================获得课程卡信息=======================
    if ([HOST(URL_LOCATION_BundleList) isEqualToString:_str_url]) {
        NSLog(@"::::::>检查课程卡列表");
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_BundleList)];
        paymentModel.arr_bundleLessons = nil;
        paymentModel.arr_bundleLessons = [[_dic_result objectForKey:@"BundleLessons"] mutableCopy];
        paymentModel.arr_bundles = nil;
        paymentModel.arr_bundles = [[_dic_result objectForKey:@"Bundles"] mutableCopy];
        

        if(view_location_requestSended)
            [view_location_requestSended cancelTimer];
        SAFE_RemoveSupreView(view_location_requestSended);
        view_location_requestSended = nil;
        
        NSInteger bundleCount = [paymentModel.arr_bundles count];
        NSLog(@":::::>有多少张课程券: %ld",bundleCount);
        [view_location_requestSended cancelTimer];
        SAFE_RemoveSupreView(view_location_requestSended);
        view_location_requestSended = nil;
        
        if(view_payment_bundleBuyed)
        {
            
            paymentModel.arr_bundleLessons = nil;
            paymentModel.arr_bundleLessons = [[_dic_result objectForKey:@"BundleLessons"] mutableCopy];
            paymentModel.arr_bundles = nil;
            paymentModel.arr_bundles = [[_dic_result objectForKey:@"Bundles"] mutableCopy];
            [self postRequest_buyLesson_useBundle];  //使用bundle
        }//如果当前是已购买bundle课程界面
        else
        {
            if(bundleCount == 0)
            {
                [self inital_payment_requestAccepted];
                NSLog(@":::::>没有买过课程,进入第一次购买课程卡界面: FGPaymentRequestAcceptedPopView");
            }//没有买过bundle
            else
            {
                [self inital_payment_requestAccepted_haveBundle];
                NSLog(@":::::>买过课程,进入已有课程卡界面: FGPaymentRequestAcceptedHaveBundlePopView");
            }//买过bundle
        }//如果当前是订单请求等待界面
        
    }
    
    //========================获得教练信息=========================
    if([HOST(URL_PROFILE_GetTrainerProfile) isEqualToString:_str_url])
    {
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_GetTrainerProfile)];
        if(view_payment_requestAccepted)
        {
            paymentModel.dic_acceptedTrainerInfo = nil;
            paymentModel.dic_acceptedTrainerInfo = [_dic_result mutableCopy];
            [view_payment_requestAccepted bindDataToUI];
        }
        if(view_payment_requestAccepted_haveBundle)
        {
            paymentModel.dic_acceptedTrainerInfo = nil;
            paymentModel.dic_acceptedTrainerInfo = [_dic_result mutableCopy];
            [view_payment_requestAccepted_haveBundle bindDataToUI];
        }
    }
    
    //=====================获得优惠券信息=======================
    if([HOST(URL_LOCATION_CouponList) isEqualToString:_str_url])
    {
        if(view_payment_buy1Session)
        {
            [view_payment_buy1Session bindDataToUI];
        }
    }
    
    //=====================获得邀请码信息=======================
    if([HOST(URL_LOCATION_InvitationExchange) isEqualToString:_str_url])
    {
        if(view_inputInvitationCode)
        {
            [view_inputInvitationCode bindDataToUI];
        }
    }
    
    //=============================购买单个课程========================
    if([HOST(URL_LOCATION_CheckBuyLesson) isEqualToString:_str_url])
    {
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckBuyLesson)];
        //TODO:1.判断GateWay 2.如果GateWay是现金支付，跳转到支付宝或微信 3.如果不是现金支付，跳转到成功
        int GateWay = [[_dic_result objectForKey:@"GateWay"] intValue];
        if(GateWay == PaymentGateWay_JustUseTicket)
        {
            [self go2PaymentSuccess];
        }//使用券支付单个课程
        else if(GateWay == PaymentGateWay_AliPay)
        {
            paymentModel.paymentCheckType = PaymentCheckType_Buy1Session;
            NSString *_str_signed = [_dic_result objectForKey:@"Sign"];
            NSLog(@"::::>支付宝::::::获得购买单个课程的签名字串:%@",_str_signed);
            FGAlipayWrapper *aliPayWrapper = [FGAlipayWrapper shareInstance];
            [aliPayWrapper doAlipayPay:_str_signed];
        }//使用支付宝
        else if(GateWay == PaymentGateWay_Wechat)
        {
            paymentModel.paymentCheckType = PaymentCheckType_Buy1Session;
            NSString *_str_signed = [_dic_result objectForKey:@"Sign"];
            NSLog(@"::::>微信::::::获得购买打包课程卡的签名字串:%@",_str_signed);
            FGWechatWrapper *weChatWrapper = [FGWechatWrapper shareInstance];
            [weChatWrapper doWechatPay:_str_signed];
            //TODO: 拉出微信支付界面
            
        }//使用微信支付单个课程
    }//购买单次课程 可使用券 也可使用现金
    
    
    //=============================购买打包课程卡========================
    if([HOST(URL_LOCATION_CheckBuyBundle) isEqualToString:_str_url])
    {
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckBuyBundle)];
        NSLog(@"_dic_result = %@",_dic_result);
        //TODO:1.判断GateWay,用哪种现金支付
        //TODO:1.判断GateWay 2.如果GateWay是现金支付，跳转到支付宝或微信 3.如果不是现金支付，跳转到成功
        int GateWay = paymentModel.paymentGateWay;
        if(GateWay == PaymentGateWay_AliPay)
        {
            paymentModel.paymentCheckType = PaymentCheckType_BuyBundle;
            NSString *_str_signed = [_dic_result objectForKey:@"Sign"];
            NSLog(@"::::>支付宝::::::获得购买打包课程卡的签名字串:%@",_str_signed);
            FGAlipayWrapper *aliPayWrapper = [FGAlipayWrapper shareInstance];
            [aliPayWrapper doAlipayPay:_str_signed];
            
        }//使用支付宝
        else if(GateWay == PaymentGateWay_Wechat)
        {
            paymentModel.paymentCheckType = PaymentCheckType_BuyBundle;
            NSString *_str_signed = [_dic_result objectForKey:@"Sign"];
            NSLog(@"::::>微信::::::获得购买打包课程卡的签名字串:%@",_str_signed);
            FGWechatWrapper *weChatWrapper = [FGWechatWrapper shareInstance];
            [weChatWrapper doWechatPay:_str_signed];
            //TODO: 使用微信支付bundle券
            
        }//使用微信支付
    }//购买打包课程卡，不可使用券 只能使用现金

    //==============================检查服务器订单状态 ，是否完成购买一次课程====================
    if([HOST(URL_LOCATION_OrderDetail) isEqualToString:_str_url])
    {
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderDetail) alias:@"From3rdPayment"];
        NSLog(@"_dic_result = %@",_dic_result);
        if(!_dic_result)
            return;
        
        /*
         0:订单已取消
         1:订单已发送
         2:订单已接受
         3:订单已付款
         4:订单已完成
         5:订单已评论
         */
        int status = [[_dic_result objectForKey:@"Status"] intValue];
        if(status == 3)//订单已付款
        {
            [self go2PaymentSuccess];
            [NetworkEventTrack track:KEY_MIXPANEL_EVENTID_PAYSESSION attrs:nil]; //mixpanel 用户付款时
        }
        else if(status == 0)
        {
            
        }
        else
        {
            [self performSelector:@selector(postRequest_checkOrderDetail) withObject:nil afterDelay:3];
        }
    }
    
    //====================================检查服务器订单状态 ，是否完成购买一个打包课程卡============================
    if([HOST(URL_LOCATION_GetBundleInfo) isEqualToString:_str_url])
    {
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_GetBundleInfo) alias:@"From3rdPayment"];
        NSLog(@"_dic_result = %@",_dic_result);
        if(!_dic_result)
            return;
        
        /*
         0:订单已取消
         1:订单已发送
         2:订单已接受
         3:订单已付款
         4:订单已完成
         5:订单已评论
         */
        int bundleLessonId = [[_dic_result objectForKey:@"BundleLessonId"] intValue];
        if(bundleLessonId <= 0)//TODO: 请检查这里的返回值
        {
             [self performSelector:@selector(postRequest_Locations_GetBundleInfo:) withObject:nil afterDelay:3];
        }
        else
        {
            [self go2BundleBuyed];
        }//订单已付款

    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
    
   
    
}
@end






