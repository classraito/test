//
//  FGMyFriendsViewController.h
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGMyFriendsListView.h"
@interface FGMyFriendsViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong) FGMyFriendsListView *view_myFriendsList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
- (void)internalInitalMyFriendsView;
@end
