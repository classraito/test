//
//  FGMyFriendsListView.h
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  Friends_Follow,
  Friends_Follower,
} enum_FollowType;


@protocol FGMyFriendsListViewDelegate <NSObject>
- (void)buttonAction_selectWithFriend:(id)obj;
@end

@interface FGMyFriendsListView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger cursor;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) enum_FollowType followType;
@property (nonatomic, assign) id<FGMyFriendsListViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (weak, nonatomic) IBOutlet UITableView *tb_friendsList;
@property (nonatomic, copy) NSString *str_id;
- (void)bindDataToUI;
- (void)loadMoreUsers;
- (void)refreshMyFollowList;
-(void)postRequest_getUserList_followWithId:(NSString *)str_id;
- (void)postRequest_getUserList_followerWithId:(NSString *)str_id;
- (UITableViewCell *)commonSimpleInfoViewCell:(UITableView *)tableView;
@end
