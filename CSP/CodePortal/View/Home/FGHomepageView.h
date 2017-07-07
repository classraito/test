//
//  FGHomepageView.h
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FGHomepageFeaturedUserCellView.h"
#import "FGHomepageTrendingWorkoutCellView.h"
#import "FGHomepageNewsInfoCellView.h"
#import "FGHomepageTopScrollCellView.h"
#import <WebKit/WebKit.h>

@protocol FGHomepageViewDelegate <NSObject>
@optional
-(void)didClickWithViewControllerName:(NSString *)name withInfo:(id)obj;
@end


@interface FGHomepageView : UIView <UITableViewDelegate, UITableViewDataSource, FGHomepageFeaturedUserCellViewDelegate, FGHomepageTrendingWorkoutCellViewDelegate, FGHomepageNewsInfoCellViewDelegate, FGHomepageTopScrollCellViewDelegate>
{
    
}
#pragma mark - 属性
@property (nonatomic, weak) IBOutlet UITableView *tb_homepage;
@property (nonatomic, strong) NSString *str_progressView_notificationKey;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) FGHomepageTitleView *view_newsTitle;
@property (nonatomic, assign) id<FGHomepageViewDelegate> delegate;
- (void)bindDataToUI;
- (void)loadMoreNews;
@end
