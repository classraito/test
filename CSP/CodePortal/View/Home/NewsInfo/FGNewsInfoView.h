//
//  FGNewsInfoView.h
//  CSP
//
//  Created by JasonLu on 16/11/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGNewsInfoView : UIView <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *wv_news;
- (void)setupNewsInfoWithLink:(NSString *)_link;
- (void)clearTimer;
@end
