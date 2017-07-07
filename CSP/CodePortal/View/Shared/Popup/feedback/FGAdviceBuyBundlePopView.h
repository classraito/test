//
//  FGAdviceBuyBundlePopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGAdviceBuyBundlePopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_description;
@property(nonatomic,weak)IBOutlet UIButton *btn_go2BuyBundle;
@property(nonatomic,weak)IBOutlet UIButton *btn_no;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@end
