//
//  FGAddFriendView.h
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomSearchViewWithButtonView.h"
#import <UIKit/UIKit.h>
@protocol FGAddFriendViewDelegate <NSObject>
@optional
-(void)didClickCellWithName:(NSString *)_name;
@end

@interface FGAddFriendView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<FGAddFriendViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet FGCustomSearchViewWithButtonView *view_searchBar;
@property (weak, nonatomic) IBOutlet UIView *view_searchBarbg;
- (void)bindDataToUI;
@end
