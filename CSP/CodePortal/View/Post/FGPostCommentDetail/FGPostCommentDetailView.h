//
//  FGPostCommentDetailView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGTrainingDetailCommentsTitleSectionView.h"
#import "FGDialogTextInputView.h"
#import "FGPostsCommonCellView.h"
#import "FGPostCommentMorePopupView.h"
typedef enum{
    MoreButtonType_Post = 1,
    MoreButtonType_Comment = 2
}MoreButtonType;


@interface FGPostCommentDetailView : UIView<UITableViewDelegate,UITableViewDataSource,FGDialogTextInputViewDelegate>
{
    
}
@property MoreButtonType moreButtonType;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)NSMutableArray *arr_commentData;
@property(nonatomic,copy)NSMutableDictionary *dic_postData;
@property(nonatomic,strong)FGDialogTextInputView *view_dialog;
@property(nonatomic,strong)FGTrainingDetailCommentsTitleSectionView *view_commentTitle;
@property(nonatomic,strong)NSString *str_currentSelectedCommentUserID;
@property(nonatomic,strong)NSString *str_currentSelectedCommentID;
@property(nonatomic,strong)NSString *str_currentSelectedPostID;
@property(nonatomic,strong)NSIndexPath *currentSelectedIndexPath;
@property(nonatomic,strong)FGPostCommentMorePopupView *view_commentMorePopup;
- (void)loadMoreComments;
-(void)bindDataToUI:(NSMutableDictionary *)_dic_postInfo;
-(void)setupPostId:(NSString *)_str_postId;
-(void)clearMemory;
-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes;
@end
