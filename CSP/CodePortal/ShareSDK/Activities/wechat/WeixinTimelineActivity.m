//
//  WeixinTimelineActivity.m
//  WeixinActivity
//
//  Created by Johnny iDay on 13-12-2.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "WeixinTimelineActivity.h"
//#import "Global.h"
//#import "WXApiWrapper.h"

@implementation WeixinTimelineActivity

- (id)init
{
    self = [super init];
    if (self) {
        scene = WXSceneTimeline;
    }
    return self;
}

- (UIImage *)activityImage
{
    return [[[UIDevice currentDevice] systemVersion] intValue] >= 8 ? [UIImage imageNamed:@"icon_timeline-8"] : [UIImage imageNamed:@"icon_timeline"];
}

- (NSString *)activityTitle
{
    return multiLanguage( @"WeChat Timeline");
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
//  if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//    for (id activityItem in activityItems) {
//      if ([activityItem isKindOfClass:[UIImage class]]) {
//        return YES;
//      }
//      if ([activityItem isKindOfClass:[NSURL class]]) {
//        return YES;
//      }
//    }
//  }
  return NO;
}

- (void)performActivity
{
//  [[WXApiWrapper sharedManager] sendLinkContent:url.absoluteString tagName:@"" title:title thumbImage:image description:content inScene:WXSceneTimeline];
//  [self activityDidFinish:YES];
}

- (void)setThumbImage:(SendMessageToWXReq *)req
{
    if (image) {
      CGFloat width = 100.0f;
      CGFloat height = image.size.height * 100.0f / image.size.width;
      UIGraphicsBeginImageContext(CGSizeMake(width, height));
      [image drawInRect:CGRectMake(0, 0, width, height)];
      UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      [req.message setThumbImage:scaledImage];
    }
}
@end
