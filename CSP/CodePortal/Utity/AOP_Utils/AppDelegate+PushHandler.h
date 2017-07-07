//
//  AppDelegate+PushHandler.h
//  RuntimeTestProject
//
//  Created by JasonLu on 16/9/2.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (PushHandler)
#pragma mark - 推送解析
- (void)action_parsePushWithInfo:(NSDictionary *)_dic_pushInfo;
@end
