//
//  FGTimeCounterLabel.h
//  CSP
//
//  Created by JasonLu on 16/9/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TimeCompletionHander)();
@interface FGTimeCounterLabel : UILabel
- (void)startCounterWithTime:(NSInteger)totalTime timeInterval:(NSTimeInterval)timeInterval completionHandler:(TimeCompletionHander)handler;
@end
