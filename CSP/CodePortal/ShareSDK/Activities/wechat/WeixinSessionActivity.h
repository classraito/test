//
//  WeixinSessionActivity.h
//  WeixinActivity
//
//  Created by Johnny iDay on 13-12-2.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "ShareActivityBase.h"
#import "WXApiObject.h"

@interface WeixinSessionActivity : ShareActivityBase {
  enum WXScene scene;
}
- (void)setThumbImage:(SendMessageToWXReq *)req;
@end
