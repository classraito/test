//
//  FGFriendProfileView.h
//  CSP
//
//  Created by JasonLu on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FGProfileMyBadgesCellView.h"
#import "FGUserProfileInfoCellView.h"
#import "FGUserProfileInfoCellView.h"
#import "FGPostCommentMorePopupView.h"

@interface FGFriendProfileView : UIView <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb_friendProfile;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, copy) NSString *str_friendId;
@property (nonatomic, assign) BOOL bool_isFollow;
@property(nonatomic,strong)NSString *str_currentReportPostId;
@property(nonatomic,strong)NSString *str_currentReportUserID;
@property (nonatomic, strong) FGProfileMyBadgesCellView *cv_badges;
@property (nonatomic, strong) FGProfileMyBadgesCellView *cv_friends;
@property (nonatomic, strong) FGUserProfileInfoCellView *cv_profileInfo;
@property (nonatomic,strong) FGPostCommentMorePopupView *view_commentMorePopup;
- (void)beginRefresh;
- (void)bindDataToUI;
- (void)loadMorePosts;
- (void)gotoProfilePost;
- (void)refreshFollowStatus;
-(void)afterDeletePost;
-(void)reloadPosts;
- (FGUserProfileInfoCellView *)getUserProfileViewCell;
-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes;
- (BOOL)hasNoFollowList;
- (BOOL)hasNoFollowerList;
- (BOOL)hasNoPostList;
- (void)runRequest_getUserProfiler;
@end
