//
//  FGTrainingDetailTopVideoThumnailView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGCircularWithProcessingButton;
#import "FGVideoModel.h"
@interface FGTrainingDetailTopVideoThumbnailCellView : UITableViewCell<FGVideoModelDownloadDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet FGCircularWithProcessingButton *cpb_download;
@property(nonatomic,weak)IBOutlet UIImageView *iv_videoThumbnail;
@property(nonatomic,weak)IBOutlet UIView *view_bottomPanelBG;
@property(nonatomic,weak)IBOutlet UIButton *btn_likes;
@property(nonatomic,weak)IBOutlet UIButton *btn_stepByStep;
@property(nonatomic,weak)IBOutlet UIButton *btn_favorite;
@property(nonatomic,weak)IBOutlet UIImageView *iv_likes;
@property(nonatomic,weak)IBOutlet UIImageView *iv_stepByStep;
@property(nonatomic,weak)IBOutlet UIImageView *iv_favorite;
@property(nonatomic,weak)IBOutlet UILabel *lb_likes;
@property(nonatomic,weak)IBOutlet UILabel *lb_stepByStep;
@property(nonatomic,weak)IBOutlet UILabel *lb_favorite;
@property(nonatomic,strong)NSString *_str_trainId;
@property(nonatomic,strong)NSString *str_UserCalories;

-(IBAction)buttonAction_likes:(id)_sender;
-(IBAction)buttonAction_stepByStep:(id)_sender;
-(IBAction)buttonAction_favorite:(id)_sender;
-(void)updateDownloadButtonStatus;
-(void)buttonAction_download_play:(id)_sender;
@end
