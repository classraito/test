//
//  FGBookingAcceptCourseBetweenTwoPopView.m
//  CSP
//
//  Created by JasonLu on 16/12/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingAcceptCourseBetweenTwoPopView.h"

@implementation FGBookingAcceptCourseBetweenTwoPopView
@synthesize str_orderId;
@synthesize dic_orderInfo;

@synthesize lb_warningTitle;
@synthesize lb_warningTip;
@synthesize lb_content;
@synthesize view_Bg;
@synthesize view_whiteBG;
@synthesize btn_done;
@synthesize btn_cancel;

-(void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
  
  [commond useDefaultRatioToScaleView:view_whiteBG];
  [commond useDefaultRatioToScaleView:view_Bg];
  [commond useDefaultRatioToScaleView:self.lb_warningTitle];
  [commond useDefaultRatioToScaleView:self.lb_warningTip];
  [commond useDefaultRatioToScaleView:self.lb_content];
  
  [commond useDefaultRatioToScaleView:self.btn_cancel];
  [commond useDefaultRatioToScaleView:self.btn_done];
  
  
  self.lb_warningTitle.textColor = color_homepage_black;
  self.lb_warningTitle.font = font(FONT_TEXT_BOLD, 28);
  self.lb_warningTitle.textAlignment = NSTextAlignmentCenter;
  
  self.lb_warningTip.textColor = color_deepgreen;
  self.lb_warningTip.font = font(FONT_TEXT_BOLD, 22);
  self.lb_warningTip.textAlignment = NSTextAlignmentCenter;
  
  self.view_bg.backgroundColor = rgba(255, 255, 255, 1.0);
  
    self.lb_warningTitle.text = multiLanguage(@"Are you sure you want to accept this?");
    self.lb_warningTip.text = multiLanguage(@"You have less than 1 hour to get from one session to another.");
}

- (void)setupViewWithInfo:(NSDictionary *)_dic {
  self.str_orderId = _dic[@"orderId"];
  
  NSArray *_arr_orders = _dic[@"Orders"];
  NSDictionary *_dic_firstOrderInfo = _arr_orders[0];
  NSDictionary *_dic_secondOrderInfo = _arr_orders[1];
  
  NSString *_str_firstBookingTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_firstOrderInfo[@"BookTime"] doubleValue] withFormat:@"h:mm a"];
  NSString *_str_firstLocation = [NSString stringWithFormat:@"%@: %@,%@",multiLanguage(@"Location"), _dic_firstOrderInfo[@"Address"],_dic_firstOrderInfo[@"AddressDetial"]];
  
  NSString *_str_secondBookingTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_secondOrderInfo[@"BookTime"] doubleValue] withFormat:@"h:mm a"];
  NSString *_str_secondLocation = [NSString stringWithFormat:@"%@: %@,%@",multiLanguage(@"Location"),_dic_secondOrderInfo[@"Address"],_dic_secondOrderInfo[@"AddressDetial"]];
  
  NSString *_str_date = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_firstOrderInfo[@"BookTime"] doubleValue] withFormat:@"yyyy.MM.dd"];
  
  //解析Mybadges
  NSArray *detailInfo = [NSArray arrayWithObjects:
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_date font:font(FONT_TEXT_REGULAR, 18) color:color_homepage_black paragraphSpacing:10 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_firstBookingTime font:font(FONT_TEXT_REGULAR, 24) color:color_red_panel paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_firstLocation font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_secondBookingTime font:font(FONT_TEXT_REGULAR, 24) color:color_red_panel paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_secondLocation font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         nil];
  
  __block NSMutableAttributedString *resultAStr = [[NSMutableAttributedString alloc] init];
  [detailInfo enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSDictionary *dic        = (NSDictionary *)obj;
    NSArray *contentInfoArr  = dic[@"content"];
    NSAttributedString *aStr = [FGUtils createAttributedStringWithContentInfo:contentInfoArr];
    [resultAStr appendAttributedString:aStr];
  }];
  
  self.lb_content.attributedText = resultAStr;
}
@end
