//
//  QQActivity.m
//  CSP
//
//  Created by YangLu on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "QQActivity.h"
//#import "QQApiWrapper.h"

@implementation QQActivity

- (UIImage *)activityImage
{
  return [UIImage imageNamed:@"qq_icon"];
}

- (NSString *)activityTitle
{
  return multiLanguage(@"QQ");
}


// 预处理分享数据
- (void)prepareWithActivityItems:(NSArray *)activityItems {
  [super prepareWithActivityItems:activityItems];
  // 解析分享数据时调用，可以进行一定的处理
}

// 执行分享
- (void)performActivity {
//  [[QQApiWrapper shareInstance] qqloginActionWithCompletionHandler:^(id result, NSError *err) {
//    BOOL _bool_isLogined = [[QQApiWrapper shareInstance] isLogined];;
//    NSLog(@"QQ IS logined:%d", _bool_isLogined);
//  }];
//  [[QQApiWrapper shareInstance] qqShareWithTitle:title desctiption:content shareURL:url.absoluteString sharePreviewURL:nil toShareType:QQ_ZONE];
}
@end
