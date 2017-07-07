//
//  FGMoreResultsView.h
//  CSP
//
//  Created by JasonLu on 17/1/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGMoreResultsViewDelegate <NSObject>
- (void)selectSearchResultWithInfo:(NSDictionary *)info;
@end

@interface FGMoreResultsView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tb_results;
@property (assign, nonatomic) id<FGMoreResultsViewDelegate>delegate;
- (void)beginRefresh;
- (void)setupWithInfo:(NSDictionary *)_dic;
- (void)bindDataToUI;
- (void)bindMoreResultsDataToUI;

@end
