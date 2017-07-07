//
//  ShareActivityBase.m
//  CSP
//
//  Created by YangLu on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "ShareActivityBase.h"

@implementation ShareActivityBase
+ (UIActivityCategory)activityCategory
{
  return UIActivityCategoryShare;
}

- (NSString *)activityType
{
  return NSStringFromClass([self class]);
}

// 设置是否显示分享按钮
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
  
  // 这里一般根据用户是否授权等来决定是否要隐藏分享按钮
  return YES;
}

// 预处理分享数据
- (void)prepareWithActivityItems:(NSArray *)activityItems
{
  [activityItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    id activityItem = obj;
    if ([activityItem isKindOfClass:[NSString class]]) {
      title = [NSString stringWithFormat:@"%@", activityItem];
    } else if ([activityItem isKindOfClass:[UIImage class]]) {
      image = activityItem;
    } else if ([activityItem isKindOfClass:[NSURL class]]) {
      url = activityItem;
    }
  }];
}

// 执行分享
- (UIViewController *)activityViewController {
  // 点击自定义分享按钮时调用，跳转到自定义的视图控制器
  return nil;
}

// 执行分享
- (void)performActivity
{
  // 点击自定义分享按钮时调用
}

// 完成分享
- (void)activityDidFinish:(BOOL)completed {
  
  // 分享视图控制器退出时调用
}
@end
