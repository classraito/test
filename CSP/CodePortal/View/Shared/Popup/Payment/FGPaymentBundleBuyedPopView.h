//
//  FGPaymentBundleBuyedPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGPaymentBundleBuyedPopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subTitle;
@property(nonatomic,weak)IBOutlet UIButton *btn_use1BundleSession;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancelRequest;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@end
