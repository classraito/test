//
//  FGMyBadgesTitleCollectionHeaderView.m
//  CSP
//
//  Created by JasonLu on 16/10/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBadgesTitleCollectionHeaderView.h"
@interface FGMyBadgesTitleCollectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@end

@implementation FGMyBadgesTitleCollectionHeaderView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setupHeaderInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
  NSString *string        = [NSString stringWithFormat:@"%@(%@)", title, subTitle];
  NSRange rangeOfLeft     = [string rangeOfString:@"("];
  NSRange rangeOfRight    = [string rangeOfString:@")"];
  NSRange rangeOfBadgeCnt = NSMakeRange(rangeOfLeft.location, rangeOfRight.location - rangeOfLeft.location + 1);

  NSMutableAttributedString *attrString =
      [[NSMutableAttributedString alloc] initWithString:string];

  [attrString addAttribute:NSForegroundColorAttributeName
                     value:color_homepage_black
                     range:NSMakeRange(0, rangeOfLeft.location)];
  [attrString addAttribute:NSFontAttributeName
                     value:font(FONT_TEXT_REGULAR, 16)
                     range:NSMakeRange(0, rangeOfLeft.location)];

  [attrString addAttribute:NSForegroundColorAttributeName
                     value:color_homepage_lightGray
                     range:rangeOfBadgeCnt];
  [attrString addAttribute:NSFontAttributeName
                     value:font(FONT_TEXT_REGULAR, 12)
                     range:rangeOfBadgeCnt];

  self.lb_title.attributedText = attrString;
}
@end
