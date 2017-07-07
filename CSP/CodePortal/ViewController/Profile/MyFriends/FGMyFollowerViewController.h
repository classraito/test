//
//  FGMyFollowerViewController.h
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyFriendsViewController.h"
#import "FGMyFriendsListView.h"

@interface FGMyFollowerViewController : FGBaseViewController
#pragma mark - 属性
@property (nonatomic, strong) FGMyFriendsListView *view_myFriendsList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id;
@end
