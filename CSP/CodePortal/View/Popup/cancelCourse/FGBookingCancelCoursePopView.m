//
//  FGBookingCancelCoursePopView.m
//  CSP
//
//  Created by JasonLu on 16/12/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingCancelCoursePopView.h"
#import "UIImageView+Circle.h"
@implementation FGBookingCancelCoursePopView
@synthesize iv_userAvatar;
@synthesize lb_userName;
-(void)awakeFromNib
{
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:iv_userAvatar];
  [commond useDefaultRatioToScaleView:lb_userName];
  
  self.lb_warningTitle.text = multiLanguage(@"Do you want to cancel the session?");
  self.lb_warningTip.text = multiLanguage(@"You have less than 1 hour to get from one session to another.");
  self.lb_warningTip.hidden = YES;
  self.lb_warningTip.textColor = color_homepage_lightGray;
  self.lb_userName.textColor = color_homepage_black;
  self.lb_userName.font = font(FONT_TEXT_REGULAR, 24);
  self.lb_userName.textAlignment = NSTextAlignmentCenter;
  
  [iv_userAvatar makeCicleWithRaduis:iv_userAvatar.bounds.size.width/2];
}


- (void)setupViewWithInfo:(NSDictionary *)_dic {
  NSLog(@"_dic==%@", _dic);
  NSDictionary *_dic_user = _dic[@"user"];
  [self.iv_userAvatar sd_setImageWithURL:[NSURL URLWithString:_dic_user[@"UserIcon"]] placeholderImage:IMG_PLACEHOLDER];
  
  NSString *_str_userName = _dic_user[@"UserName"];
  self.lb_userName.text = _str_userName;
  
  NSString *_str_bookingDate = [_dic[@"date"] stringByReplacingOccurrencesOfString:@"Date: " withString:@""];
  NSString *_str_bookingTime = [_dic[@"dateTime"] stringByReplacingOccurrencesOfString:@"Time: " withString:@""];
  NSString *_str_location = _dic[@"location"];
  NSString *_str_detail = _dic[@"locationDetail"];


  NSArray *detailInfo = [NSArray arrayWithObjects:
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_bookingDate font:font(FONT_TEXT_REGULAR, 22) color:color_homepage_lightGray paragraphSpacing:3 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_bookingTime font:font(FONT_TEXT_REGULAR, 20) color:color_homepage_lightGray paragraphSpacing:3 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_location font:font(FONT_TEXT_REGULAR, 18) color:color_homepage_lightGray paragraphSpacing:3 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
                                ]
                            },
                         @{ @"content" : @[
                                [FGUtils createAttributeTextInfo:_str_detail font:font(FONT_TEXT_REGULAR, 18) color:color_homepage_lightGray paragraphSpacing:3 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]
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
