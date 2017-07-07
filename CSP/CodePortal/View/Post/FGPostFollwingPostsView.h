//
//  FGPostFollwingPostsView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGPostCameraButtonView.h"
#import "FGPostSectionTitleView.h"
#import "FGPostCommentMorePopupView.h"
#import "FGPostsFollowingCellView.h"
@interface FGPostFollwingPostsView : UIView<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_data;
@property(nonatomic,strong)FGPostCameraButtonView *view_cameraButton;
@property(nonatomic,strong)FGPostSectionTitleView *view_sectionTitle;
@property(nonatomic,strong)FGPostCommentMorePopupView *view_commentMorePopup;
@property(nonatomic,weak)IBOutlet UITableView *tb;

@property(nonatomic,strong)UILabel *lb_tmp;
@property(nonatomic,strong)OHAttributedLabel *ml_tmp;
@property(nonatomic,strong)NSString *str_currentReportPostId;
@property(nonatomic,strong)NSString *str_currentReportUserID;
@property NSInteger commentCursor;
@property NSInteger totalComment;
-(void)bindDataToUI;
-(void)postRequst_getPostList;
-(void)postRequst_getMorePostList;
-(void)afterDeletePost;
- (void)loadMoreFollowing;
-(void)beginRefresh;
-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes;
- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                    originalCollectionFrame:(CGRect)_originalCollectionFrame collectionImagesCount:(NSInteger)_collectionImagesCount;
- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                originalVideoContainerFrame:(CGRect)_originalVideoContainerFrame;
- (CGFloat)sizeThatAttributeString:(NSString *)content width:(CGFloat)width;
-(void)hideFooterLoadingIfNeeded;
-(UITableViewCell *)giveMePostFollowingCellView:(UITableView *)_tb;
@end
