//
//  FGProfileHomeView.h
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGPostCommentMorePopupView.h"

@class FGProfileSettingCellView_v1;
@class FGProfileSettingCellView;
@class FGProfileInfoCellView;
@class FGProfileMyBadgesCellView;
@interface FGProfileHomeView : UIView <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>
#pragma mark - 属性
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (weak, nonatomic)IBOutlet UITableView *tb_profileHome;
@property(nonatomic,strong)FGPostCommentMorePopupView *view_commentMorePopup;
@property(nonatomic,strong)NSString *str_currentReportPostId;
@property(nonatomic,strong)NSString *str_currentReportUserID;
@property int currentSelectedRow;
- (void)internalDownloadAvatar;
- (void)beginReresh;
- (void)bindDataToUI;
- (void)loadMorePosts;
- (void)gotoProfilePost;
- (void)reload;
- (void)refreshBookingBadgeNumber;
- (void)runRequest_getUserProfile;
-(void)afterDeletePost;
- (FGProfileSettingCellView *)getProfileSettingViewCell;
- (FGProfileInfoCellView *)getProfileInfoViewCell;
- (FGProfileMyBadgesCellView *)getProfileMyBadgesViewCell;
-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes;

- (BOOL)hasNoFollowList;
- (BOOL)hasNoFollowerList;
- (BOOL)hasNoPostList;
@end
