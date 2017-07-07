//
//  SharedItem.m
//  CSP
//
//  Created by JasonLu on 17/1/13.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "SharedItem.h"

@implementation SharedItem
-(instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file andTitle:(NSString *)title
{
  self = [super init];
  if (self) {
    _img = img;
    _path = file;
    _title = title;
  }
  return self;
}

-(instancetype)init
{
  //不期望这种初始化方式，所以返回nil了。
  return nil;
}

#pragma mark - UIActivityItemSource
-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
  return _img;
}

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
  return _path;
}

-(NSString*)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
  // 这里对我这分享图好像没啥用....   是的 没啥用....
  return _title;
}
@end
