//
//  FGHomepageFeaturedUserCellView.h
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGHomepageFeaturedUserCellViewDelegate <NSObject>
@optional
-(void)didClickButton:(UIButton *)button;
-(void)didClickInfoButtonWithType:(NSString *)type objAtIndex:(NSInteger)_idx;
@end

@interface FGHomepageFeaturedUserCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UIView *view_title;
@property (weak, nonatomic) IBOutlet UIView *view_content;

@property (nonatomic, assign) id<FGHomepageFeaturedUserCellViewDelegate> delegate;
@end
