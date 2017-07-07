//
//  FGLocationJoinGroupPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGLocationJoinGroupPopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_share;
@property(nonatomic,weak)IBOutlet UILabel *lb_share;
@property(nonatomic,weak)IBOutlet UIButton *btn_share;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;


@end
