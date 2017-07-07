//
//  FGBadgeCollectionViewCell.m
//  CSP
//
//  Created by JasonLu on 16/10/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBadgeCollectionViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+Circle.h"
@interface FGBadgeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iv_badge;
@end

@implementation FGBadgeCollectionViewCell
@synthesize iv_badge;
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:iv_badge];
  self.iv_badge.alpha =.3f;
  self.iv_badge.backgroundColor = [UIColor clearColor];
//  [iv_badge makeCicleWithRaduis:iv_badge.bounds.size.width/2];
//  iv_badge.layer.masksToBounds = NO;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // 初始化时加载collectionCell.xib文件
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FGBadgeCollectionViewCell" owner:self options:nil];

    // 如果路径不存在，return nil
    if (arrayOfViews.count < 1) {
      return nil;
    }
    // 如果xib中view不属于UICollectionViewCell类，return nil
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
      return nil;
    }
    // 加载nib
    self = [arrayOfViews objectAtIndex:0];
  }
  return self;
}

- (void)setupBadgeWithInfo:(NSDictionary *)info {
  
  /*
   {
   "BadgeId":"3323",
   "Brief":"登录APP",
   "Thumbnail":"http://www.ifweo.com/ifee/ixls.png",
   "Progress":7,
   "Achieve":10,
   "GotTime":12345678901
   }
   */
  NSString *_str_img = info[@"Thumbnail"];
  if (!ISNULLObj(_str_img)) {
    [self.iv_badge sd_setImageWithURL:[NSURL URLWithString:_str_img] placeholderImage:IMGWITHNAME(@"dot") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      NSTimeInterval _time_got = [info[@"GotTime"] doubleValue];
      self.iv_badge.alpha = _time_got == 0?.3f:1.0f;
      self.iv_badge.backgroundColor = [UIColor clearColor];
    }];
  }
}

@end
