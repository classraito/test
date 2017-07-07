//
//  FGPaymentRequestAcceptedPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGViewsQueueCustomView.h"
@interface FGPaymentRequestAcceptedPopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subTitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_trainerThumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_trainerName;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *queueView_rating;
@property(nonatomic,weak)IBOutlet UIButton *btn_pay1Session;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancelRequest;
@property(nonatomic,weak)IBOutlet UIView *view_bundleBg;
@property(nonatomic,weak)IBOutlet UILabel *lb_title_bundle;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle_bundle;
@property(nonatomic,weak)IBOutlet UIButton *btn_go2PayBundle;
-(void)bindDataToUI;
@end
