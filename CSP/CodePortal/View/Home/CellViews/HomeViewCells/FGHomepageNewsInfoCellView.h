//
//  FGHomepageNewsInfoCellView.h
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGHomepageNewsInfoCellViewDelegate <NSObject>
@optional
-(void)didClickButton:(UIButton *)button;
@end

@interface FGHomepageNewsInfoCellView : UITableViewCell
@property (nonatomic, assign) id<FGHomepageNewsInfoCellViewDelegate> delegate;

@end
