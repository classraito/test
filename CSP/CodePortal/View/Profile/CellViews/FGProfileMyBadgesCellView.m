//
//  FGProfileMyBadgesCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageSmallIconView.h"
#import "FGHomepageTitleView.h"
#import "FGProfileMyBadgesCellView.h"
#import "FGViewsQueueCustomView.h"
#import "UITableViewCell+BindDataToUI.h"

#define TAG_TITLEVIEW 100

@interface FGProfileMyBadgesCellView ()
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet FGViewsQueueCustomView *qv_imagesQueue;
//@property (strong, nonatomic) FGHomepageTitleView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@end

@implementation FGProfileMyBadgesCellView
@synthesize qv_imagesQueue;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code

  [self internalInitCell];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}
#pragma mark - 私有方法
#pragma mark 初始化Cell
- (void)internalInitCell {
  [commond useDefaultRatioToScaleView:self.view_content];
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.qv_imagesQueue];

  
  //  //添加标题信息
  //  titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  //  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"My badges") color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  //  titleView.frame = CGRectMake(0, 0, self.view_content.bounds.size.width, 20);
  //  [self.view_content addSubview:titleView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}
#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
  // TODO: 从dataInfo中获取badges数量
  NSDictionary *myBadgesInfos = (NSDictionary *)_dataInfo;

  NSInteger _int_badgesTotal = [myBadgesInfos[@"badgesTotal"] integerValue];
  NSInteger _int_badgesGet = [myBadgesInfos[@"badgesGet"] integerValue];

  NSString *title     = myBadgesInfos[@"title"];
  if (ISNULLObj(title))
    title = @"";
  [self setupMyBadgesWithTitle:title num:_int_badgesTotal == 0 ? @"" : [NSString stringWithFormat:@"(%i/%i)",_int_badgesGet, _int_badgesTotal]];

  NSArray *badgesList            = myBadgesInfos[@"badgesList"];
  NSMutableArray *arr_imageNames = [NSMutableArray array];
  [badgesList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSDictionary *info = (NSDictionary *)obj;
    [arr_imageNames addObject:info[@"Thumbnail"]];
    if (idx == 4) {
      *stop = YES;
    }
  }];

  //添加更多图标
  [arr_imageNames addObject:@"more_dot"];
  
  CGRect imgBounds = CGRectMake(0, 0, 40 * ratioW, 40 * ratioH);
    NSLog(@"arr_imageNames = %@",arr_imageNames);
  [qv_imagesQueue initalQueueByImageNames:arr_imageNames highlightedImageNames:nil padding:14 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
   
}

- (void)setupMyBadgesWithTitle:(NSString *)title num:(NSString *)_str_num {
  if ([_str_num isEmptyStr]) {
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color_homepage_black
                       range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName
                       value:font(FONT_TEXT_REGULAR, 16)
                       range:NSMakeRange(0, attrString.length)];
    self.lb_title.attributedText = attrString;
    return;
  }
  
  
  NSString *string        = [NSString stringWithFormat:@"%@%@", title, _str_num];
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
