//
//  FGProfileSettingsView.m
//  CSP
//
//  Created by JasonLu on 17/1/18.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//
//  email: feedback@weboxapp.com
#define link_futiaokuan @"https://weboxapp.com/tos/"
#define link_chagnjianwenti @"https://weboxapp.com/webox-faq/"

#import "FGProfileSettingsView.h"
#import "FGHomepageTitleView.h"
#import "FGSettingViewCell.h"
#import "FGSettingForFeedbackPopupView.h"
#import "FGAboutViewController.h"
#import "FGClearCacheViewController.h"

@interface FGProfileSettingsView () <FGSettingViewCellDelegate> {
  FGHomepageTitleView *view_titleSection;
  FGSettingForFeedbackPopupView *view_feedbackPopup;
  UIView *view_bg;
}
@end

@implementation FGProfileSettingsView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
//  [self internalInitalData];
  [self internalInitalView];
  
  [commond useDefaultRatioToScaleView:self.tb_settings];
}

- (void)internalInitalData {
  NSNumber *_number_noficationStatus = (NSNumber *)[commond getUserDefaults:STATUS_NOTIFICATION];
  //计算缓存大小
  /*
   清空图片缓存
   清空动态视频缓存
   清空下载的训练视频文件
   */
  float _flt_picSize = [commond getSDWebImageCachedSize];
  NSLog(@"uint_size==%f", _flt_picSize);
  
  float _flt_postVideoSize = [commond getCachedPostVideoFileSize];
  NSLog(@"uint_size==%f", _flt_postVideoSize);
  ;
  
  float _flt_videoSize = [commond getTrainingDownloadVideoSize];
  NSLog(@"uint_size==%f", _flt_videoSize);
  ;
  float _flt_totalSize = _flt_picSize + _flt_postVideoSize + _flt_videoSize;
  
  _arr_data = [NSMutableArray arrayWithArray:@[@[
                                                 @{
                                                   @"title":multiLanguage(@"About Us"),
                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
                                                   },
                                                 @{
                                                   @"title":multiLanguage(@"Term & Condition"),
                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
                                                   },
                                                 @{
                                                   @"title":multiLanguage(@"Q&A"),
                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
                                                   },
                                                 @{
                                                   @"title":multiLanguage(@"Feedback"),
                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
                                                   }
                                                 ],
                                               @[
                                                 @{
                                                   @"title":multiLanguage(@"Notification"),
                                                   @"type":[NSNumber numberWithInteger:CellType_optionButton],
                                                   @"value":_number_noficationStatus
                                                   },
                                                 @{
                                                   @"title":multiLanguage(@"Clear Cache"),
                                                   @"type":[NSNumber numberWithInteger:CellType_titleWithArrow],
                                                   @"value":[NSNumber numberWithFloat:_flt_totalSize<0.1?0:_flt_totalSize]
                                                   },
//                                                 @{
//                                                   @"title":multiLanguage(@"Tutorial"),
//                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
//                                                   },
                                                 @{
                                                   @"title":multiLanguage(@"Sign Out"),
                                                   @"type":[NSNumber numberWithInteger:CellType_normal]
                                                   }
                                                 ]]];
}

- (void)internalInitalView {
  self.tb_settings.dataSource = self;
  self.tb_settings.delegate   = self;
  
  self.tb_settings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_settings reloadData];
}

-(void)internalInitalFeedbackPopupView
{
  if(view_feedbackPopup)
    return;
  
  view_feedbackPopup = (FGSettingForFeedbackPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGSettingForFeedbackPopupView" owner:nil options:nil] objectAtIndex:0];
  view_feedbackPopup.str_emailSubject = multiLanguage(@"");
  
  [commond useDefaultRatioToScaleView:view_feedbackPopup];
  view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
  [appDelegate.window addSubview:view_bg];
  [appDelegate.window addSubview:view_feedbackPopup];
  
  [view_feedbackPopup.btn_cancel addTarget:self action:@selector(buttonAction_removeFeedbackPopView:) forControlEvents:UIControlEventTouchUpInside];
  [view_feedbackPopup.btn_email addTarget:self action:@selector(buttonAction_sendEmail:) forControlEvents:UIControlEventTouchUpInside];
}

- (FGHomepageTitleView *)getHomepageTitleView {
  FGHomepageTitleView *titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView updateLeftTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  titleView.frame     = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  return titleView;
}

- (void)dealloc {
  _arr_data = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45 * ratioH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 20 * ratioH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  FGHomepageTitleView *view_tmpTitleView = [self getHomepageTitleView];
  return view_tmpTitleView;
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data[section] count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [self settingsViewCell:tableView];
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:_arr_data[indexPath.section][indexPath.row]];
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSLog(@"indexPath==%@", indexPath);
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      //关于我们
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGAboutViewController *_vc = [[FGAboutViewController alloc] initWithNibName:@"FGAboutViewController" bundle:nil];
      [manager pushController:_vc navigationController:nav_current];
      
    } else if (indexPath.row == 1) {
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGNewsInfoViewController *vc_newsInfo = [[FGNewsInfoViewController alloc] initWithNibName:@"FGNewsInfoViewController" bundle:nil withInfo:link_futiaokuan withTtitle:multiLanguage(@"Term & Condition")];
      [manager pushController:vc_newsInfo navigationController:nav_current];
    }
    else if (indexPath.row == 2) {
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGNewsInfoViewController *vc_newsInfo = [[FGNewsInfoViewController alloc] initWithNibName:@"FGNewsInfoViewController" bundle:nil withInfo:link_chagnjianwenti  withTtitle:multiLanguage(@"Q&A")];
      [manager pushController:vc_newsInfo navigationController:nav_current];
    }
    else if (indexPath.row == 3) {
      //打开email
//      [self internalInitalFeedbackPopupView];
      [commond removeLoading];
      [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"Feedback") message:multiLanguage(@"Please email feedback to us at\nfeedback@weboxapp.com") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            if([MFMailComposeViewController canSendMail])
            {
                [self displayComposerSheet];
            }
            else{
                [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please, setup a mail account in your phone first.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            }
        }
        else
        {
          
        }
      }];
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      
    } else if (indexPath.row == 1) {
      //清缓存界面
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGClearCacheViewController *vc_profile_group = [[FGClearCacheViewController alloc] initWithNibName:@"FGClearCacheViewController" bundle:nil];
      [manager pushController:vc_profile_group navigationController:nav_current];
    }
//    else if (indexPath.row == 2) {
//      
//    }
    else if (indexPath.row == 2) {
      [commond showAskForLogout];
    }
  }
  
}

#pragma mark - 自定义cell
- (UITableViewCell *)settingsViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier   = @"FGSettingViewCell";
  FGSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGSettingViewCell" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

#pragma mark - FGSettingViewCellDelegate
- (void)action_swtichToStatus:(BOOL)_bool_newStatus {
  NSLog(@"new status ==%d",_bool_newStatus);
  
  NSMutableArray *_marr = [NSMutableArray arrayWithArray:_arr_data[1]];
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_marr[0]];
  [_mdic setValue:[NSNumber numberWithBool:_bool_newStatus] forKey:@"Notification"];
  [_marr replaceObjectAtIndex:0 withObject:_mdic];
  [_arr_data replaceObjectAtIndex:1 withObject:_marr];
  
  [commond setUserDefaults:[NSNumber numberWithBool:_bool_newStatus] forKey:STATUS_NOTIFICATION];
}

#pragma mark - 按钮事件
- (void)buttonAction_removeFeedbackPopView:(id)sender {
  SAFE_RemoveSupreView(view_feedbackPopup);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  view_feedbackPopup = nil;
}

- (void)buttonAction_sendEmail:(id)sender {
  [self buttonAction_removeFeedbackPopView:nil];
  [self displayComposerSheet];
}

#pragma mark - 发送邮件
-(void)displayComposerSheet
{
    @try {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:multiLanguage(@"")];
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@weboxapp.com"];
        
        
        [picker setToRecipients:toRecipients];
        
        // Attach an image to the email
        /*  NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
         NSData *myData = [NSData dataWithContentsOfFile:path];
         [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];*/
        
        // Fill out the email body text
        
        [[self viewController] presentViewController:picker animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please, setup a mail account in your phone first.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    } @finally {
        
    }
    
    


  }

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  [[self viewController] dismissViewControllerAnimated:YES completion:^{
  }];
}

#pragma mark - 其它
- (void)reload{
  [self internalInitalData];
  [self.tb_settings reloadData];
}
@end
