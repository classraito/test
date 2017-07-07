//
//  FGHomepageTopScrollCellView.h
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "SDCycleScrollView.h"
#import <UIKit/UIKit.h>

@protocol FGHomepageTopScrollCellViewDelegate <NSObject>

- (void)action_didSelectTopScrollAtIndex:(NSInteger)_int_idx;

@end

@interface FGHomepageTopScrollCellView : UITableViewCell
@property (nonatomic, strong) SDCycleScrollView *view_topInfoScroll;

@property (nonatomic, assign) NSInteger currentScollIndex;
@property (nonatomic, assign) id<FGHomepageTopScrollCellViewDelegate> delegate;
- (UIImage *)currentScollImage;
@end
