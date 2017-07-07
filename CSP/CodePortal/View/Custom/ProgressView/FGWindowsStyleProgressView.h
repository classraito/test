//  CSP
//
//  Created by Ryan Gong on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum
{
    ProgressStatus_Inital = 0,
    ProgressStatus_Pull = 1,
    ProgressStatus_Refreshing = 2,
    ProgressStatus_Refreshed = 3
    
}ProgressStatus;


@interface FGWindowsStyleProgressView : UIView<UIScrollViewDelegate>
@property CGFloat pullPower;
@property (nonatomic, strong) NSMutableArray   * progressChunks;
@property (nonatomic, strong) UIColor   * progressTintColor;
@property (nonatomic, strong) UIColor   * trackTintColor;

@property (nonatomic, readonly) ProgressStatus progressStatus;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, copy) void (^pullToRefreshActionHandler)(void);
- (void)startAnimating;
- (void)stopAnimating;
-(void)recoveryAnimtaionIfNeeded;
- (void)setProgressTintColor:(UIColor *)progressTintColor;
@end
