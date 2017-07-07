//
//  FGTrainingDetailView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGTrainingDetailTopVideoThumbnailCellView.h"
#import "FGTrainingDetailCommentsTitleSectionView.h"
#import "FGDialogTextInputView.h"
#import "FGPostCommentMorePopupView.h"
@interface FGTrainingDetailView : UIView<UITableViewDelegate,UITableViewDataSource,FGDialogTextInputViewDelegate,UIActionSheetDelegate>
{
    
}
@property(nonatomic,strong)NSString *str_workoutId;
@property(nonatomic,strong)NSString *str_userCalories;
@property(nonatomic,strong)FGTrainingDetailCommentsTitleSectionView *view_commentSectionTitle;
@property(nonatomic,strong)FGDialogTextInputView *view_dialog;
@property(nonatomic,strong)FGPostCommentMorePopupView *view_commentMorePopup;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)NSString *str_currentSelectedCommentUserID;
@property(nonatomic,strong)NSString *str_currentSelectedCommentID;
@property(nonatomic,strong)NSIndexPath *currentSelectedIndexPath;
@property BOOL isNeedRemoveComments;
-(void)refreshDownloadButtonStatus;
-(void)bindDataToUI;
- (void)loadMoreComments;
-(void)afterSubmitComment;
-(void)postRequest;
-(void)reloadComments;
#pragma mark - 刷新Likes后
-(void)afterUpdateTranLikes;
-(void)afterUpdateTranDetail;
-(void)clearMemory;
-(void)addPullToRefresh;
-(NSMutableDictionary *)giveMeOriginalData;
- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName fromDatas:(NSMutableDictionary *)_dic_result;
@end
