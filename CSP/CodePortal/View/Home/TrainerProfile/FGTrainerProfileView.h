//
//  FGTrainerProfileView.h
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGTrainerDescriptionInfoCellView;
@class FGAlbumInfoCellView;
@interface FGTrainerProfileView : UIView <UITableViewDelegate, UITableViewDataSource>
#pragma mark - 属性
@property (nonatomic, weak) IBOutlet UITableView *tb_trainerProfile;
@property (nonatomic, copy) NSString *str_trainerId;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) FGTrainerDescriptionInfoCellView *cv_trainerDescInfo;
@property (nonatomic, strong) FGAlbumInfoCellView *cv_albumInfo;
@property (nonatomic, strong) FGTrainingDetailCommentsTitleSectionView *view_reviewsSectionTitle;

- (void)beginRefresh;
- (void)bindDataToUI;
- (void)loadMoreComments;
- (void)runRequest_getTrainerProfiler;
@end
