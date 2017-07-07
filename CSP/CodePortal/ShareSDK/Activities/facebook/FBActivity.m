//
//  FBActivity.m
//  CSP
//
//  Created by JasonLu on 17/1/15.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FBActivity.h"
#import <Social/Social.h>

@implementation FBActivity
@synthesize _controller;
@synthesize _arr_img;

- (UIImage *)activityImage
{
  return [UIImage imageNamed:@"fb_icon"];
}

- (NSString *)activityTitle
{
  return multiLanguage(@"Facebook");
}


// 预处理分享数据
- (void)prepareWithActivityItems:(NSArray *)activityItems {
  [super prepareWithActivityItems:activityItems];
  // 解析分享数据时调用，可以进行一定的处理
}

// 执行分享
- (void)performActivity {
  
  [[FGSNSManager shareInstance] shareToPlatformWithTitle:title text:title url:url.absoluteString images:@[image] platformType:SSDKPlatformTypeFacebook contentType:SSDKContentTypeImage];
  
//  if (_arr_img.count > 1)
//  {
//    [[FBApiWrapper shareInstance] fbShareWithImages:_arr_img inVCtrl:_controller];
//  }
//  else
//  {
//    [[FBApiWrapper shareInstance] fbShareWithTitle:title shareURL:url.absoluteString sharePreviewURL:@"http://wcbi.info/site/wp-content/uploads/2015/09/hero-logo-botb1.png" inVCtrl:nil];
//  }
  
  
  
 //
//  if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//    NSLog(@"不可用");
//    return;
//  }
//  // 创建控制器，并设置ServiceType
//  SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//  // 添加要分享的图片
//  [composeVC addImage:_arr_img[0]];
//  // 添加要分享的文字
//  [composeVC setInitialText:@"share to PUTClub"];
//  // 添加要分享的url
//  [composeVC addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//  // 弹出分享控制器
//  [_controller presentViewController:composeVC animated:YES completion:nil];
//  // 监听用户点击事件
//  composeVC.completionHandler = ^(SLComposeViewControllerResult result){
//    if (result == SLComposeViewControllerResultDone) {
//      NSLog(@"点击了发送");
//    }
//    else if (result == SLComposeViewControllerResultCancelled)
//    {
//      NSLog(@"点击了取消");
//    }
//  };
}
@end
