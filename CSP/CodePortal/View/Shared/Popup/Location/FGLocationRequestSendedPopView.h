//
//  FGLocationRequestSendedPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCircularUploadProgressView.h"
typedef enum{
    OrderStatus_Canceled = 0,
    OrderStatus_Sended = 1,
    OrderStatus_Accepted = 2,
    OrderStatus_Payed = 3,
    OrderStatus_Finished = 4,
    OrderStatus_Commented = 5
}OrderStatus;

@interface FGLocationRequestSendedPopView : FGPopupView
{
    
}
@property OrderStatus orderStatus;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancelRequest;
@property long discount;
@property(nonatomic,strong)FGCircularUploadProgressView *view_uploading;
-(void)cancelTimer;
-(void)setupProgressOnce;
-(void)updateAcceptStatus;
-(void)postRequest_location_requestSended_checkOrder;
@end
