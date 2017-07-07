//
//  FGBookingHistoryViewController.h
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGBookingHistoryViewController : FGBaseViewController
@property (nonatomic, strong) NSDictionary *dic_orderInfo;
@property (nonatomic, copy) NSString *str_orderId;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOrderDetailInfo:(id)_dic_orderInfo;
@end
