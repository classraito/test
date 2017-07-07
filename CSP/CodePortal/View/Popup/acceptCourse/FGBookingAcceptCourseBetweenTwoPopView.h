//
//  FGBookingAcceptCourseBetweenTwoPopView.h
//  CSP
//
//  Created by JasonLu on 16/12/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGBookingAcceptCourseBetweenTwoPopView : FGPopupView
@property(nonatomic,copy)NSString *str_orderId;
@property(nonatomic,strong)NSDictionary *dic_orderInfo;
@property (weak, nonatomic) IBOutlet UIView *view_Bg;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UILabel *lb_warningTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_warningTip;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

- (void)setupViewWithInfo:(NSDictionary *)_dic;
@end
