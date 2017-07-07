//
//  FGHomepageSearchResultView.h
//  CSP
//
//  Created by JasonLu on 16/10/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#define TITLE_WORKOUTS multiLanguage(@"WORKOUTS")
#define TITLE_TRAINERS multiLanguage(@"TRAINERS")
#define TITLE_USERS multiLanguage(@"USERS")
#define TITLE_NEWSFEED multiLanguage(@"NEWS FEEDS")
#define TITLE_TOPICS multiLanguage(@"TOPICS")

#import <UIKit/UIKit.h>
@class FGHomepageTitleView;
@protocol FGHomepageSearchResultViewDelegate <NSObject>
- (void)selectSearchResultWithInfo:(NSDictionary *)info;
- (void)action_gotoSeeMoreInfoWithSection:(NSString *)_str_section;
@end

@interface FGHomepageSearchResultView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<FGHomepageSearchResultViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tb_searchResult;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) FGHomepageTitleView *view_title;
- (void)bindDataToUI;
@end
