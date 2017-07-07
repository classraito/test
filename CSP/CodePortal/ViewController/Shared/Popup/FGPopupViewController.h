//
//  FGLocationPopupViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGBookingAcceptCourseBetweenTwoPopView.h"
#import "FGBookingDetailInfoPopView.h"
#import "FGBadgeDetailInfoPopView.h"
#import "FGBaseViewController.h"
#import "FGLocationRequestSendedPopView.h"
#import "FGLocationNoAcceptingPopView.h"
#import "FGPaymentRequestAcceptedPopView.h"
#import "FGPaymentBuyBundlePopView.h"
#import "FGPaymentBundleBuyedPopView.h"
#import "FGBookSucessPopView.h"
#import "FGPaymentBuy1SessionPopView.h"
#import "FGInputInvitationCodePopView.h"
#import "FGPaymentRequestAcceptedHaveBundlePopView.h"
#import "FGAdviceBuyBundlePopView.h"
#import "FGWriteFeedBackView.h"
#import "FGLocationJoinGroupPopView.h"



@interface FGPopupViewController : FGBaseViewController
{

  FGBookingDetailInfoPopView *view_bookingDetailInfo;
  
  FGBadgeDetailInfoPopView *view_badgeInfo;
  
    FGLocationRequestSendedPopView *view_location_requestSended;
    
    FGLocationNoAcceptingPopView *view_location_noAccept;
    
    FGPaymentRequestAcceptedPopView *view_payment_requestAccepted;
    
    FGPaymentBuyBundlePopView *view_payment_buyBundle;
    
    FGPaymentBundleBuyedPopView *view_payment_bundleBuyed;
    
    FGBookSucessPopView *view_bookSucess;
    
    FGPaymentBuy1SessionPopView *view_payment_buy1Session;
    
    FGInputInvitationCodePopView *view_inputInvitationCode;
    
    FGPaymentRequestAcceptedHaveBundlePopView *view_payment_requestAccepted_haveBundle;
    
    FGWriteFeedBackView *view_writeFeedback;
    
    FGAdviceBuyBundlePopView *view_adviceToBuyBundle;
    
    FGLocationJoinGroupPopView *view_joinGroup;
}

#pragma mark - 初始化
-(void)inital_bookingDeatilWithInfo:(NSDictionary *)_dic_info;
-(void)inital_badgeInfoWithInfo:(NSDictionary *)_dic_info;
-(void)inital_location_requestSended;
-(void)inital_location_noAccepting;
-(void)inital_payment_requestAccepted;
-(void)inital_payment_buyBundle;
-(void)inital_payment_bundleBuyed;
-(void)inital_book_sucess;
-(void)inital_payment_buy1Session;
-(void)inital_inputInvitationCode;
-(void)inital_payment_requestAccepted_haveBundle;
-(void)inital_writeFeedback;
-(void)inital_adviceToBuyBundle;
-(FGLocationJoinGroupPopView *)inital_joinGroup;

-(void)remove_location_requestSended;


#pragma mark - 跳转
-(void)go2NoRequestAccepting;
-(void)go2InputInviteCode;
-(void)buttonAction_inputInvitationCode_cancel:(id)_sender;
@end

@interface FGPopupViewController (Network)
{
    
}
- (void)postRequest_trainerAcceptOrderWithOrderId:(NSString *)_str_orderId;
-(void)postRequest_getBundleList;
-(void)postRequest_location_cancelRequest;
-(void)postReuqest_getTrainerProfile;
-(void)postRequest_getCouponList;
-(void)postRequest_buyLesson;
-(void)postRequest_buyLesson_useBundle;
-(void)postRequest_buyBundle;
-(void)postRequest_verifyInvitationCode;

-(void)globalPopupRequestSend;

@end
