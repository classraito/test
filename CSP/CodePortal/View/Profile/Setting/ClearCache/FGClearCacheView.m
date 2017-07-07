//
//  FGClearCacheView.m
//  CSP
//
//  Created by JasonLu on 17/1/20.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGClearCacheView.h"
#import "FGSettingViewCell.h"

@implementation FGClearCacheView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self internalInitalData];
  [self internalInitalView];
  
  [commond useDefaultRatioToScaleView:self.tb_settings];
}

- (void)internalInitalData {
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
  
  _arr_data = [NSMutableArray arrayWithArray:@[
                                               @{
                                                 @"title":multiLanguage(@"Clear Images Cache"),
                                                 @"type":[NSNumber numberWithInteger:CellType_titleWithArrow],
                                                @"value":[NSNumber numberWithFloat:_flt_picSize]
                                                 },
                                               @{
                                                 @"title":multiLanguage(@"Clear Post Videoes Cache"),
                                                 @"type":[NSNumber numberWithInteger:CellType_titleWithArrow],
                                                 @"value":[NSNumber numberWithFloat:_flt_postVideoSize]
                                                 },
                                               @{
                                                 @"title":multiLanguage(@"Clear Download Training Video Files"),
                                                 @"type":[NSNumber numberWithInteger:CellType_titleWithArrow],
                                                 @"value":[NSNumber numberWithFloat:_flt_videoSize]
                                                 },
                                               ]];
}

- (void)internalInitalView {
  self.tb_settings.dataSource = self;
  self.tb_settings.delegate   = self;
  
  self.tb_settings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_settings reloadData];
}

-(void)internalInitalFeedbackPopupView
{
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

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [self settingsViewCell:tableView];
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:_arr_data[indexPath.row]];
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSLog(@"indexPath==%@", indexPath);
  if (indexPath.row == 0) {
    //打开email
    //[self internalInitalFeedbackPopupView];
    [commond removeLoading];
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Clear caches?!") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
      if(buttonIndex == 0)
      {
        [commond clearSDWebImageCachedSize];
        [self updateArrDataWithValue:0 atIndex:indexPath.row];
      }
      else
      {
        
      }
    }];
    
  }
  else if (indexPath.row == 1) {
    //打开email
    //      [self internalInitalFeedbackPopupView];
    [commond removeLoading];
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Clear caches?!") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
      if(buttonIndex == 0)
      {
        [commond clearCachedPostVideoFileSize];
        [self updateArrDataWithValue:0 atIndex:indexPath.row];
      }
      else
      {
        
      }
    }];
  }
  else if (indexPath.row == 2) {
    //打开email
    //      [self internalInitalFeedbackPopupView];
    [commond removeLoading];
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Clear caches?!") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
      if(buttonIndex == 0)
      {
        [commond clearTrainingDownloadVideoSize];
        [self updateArrDataWithValue:0 atIndex:indexPath.row];
          [commond setUserDefaults:nil forKey:KEY_SAVEDWORKOUTLIST_DATAS];//TODO: rui.gong add it 删除saved workout 数据
          [commond setUserDefaults:nil forKey:KEY_SAVEDWORKOUT_DATAS];
      }
      else
      {
        
      }
    }];
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)settingsViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier   = @"FGSettingViewCell";
  FGSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGSettingViewCell" owner:self options:nil] lastObject];
  }
  cell.delegate = nil;
  return cell;
}

#pragma mark - 事件
- (void)updateArrDataWithValue:(float)_flt atIndex:(NSInteger)_int_idx {
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary: self.arr_data[_int_idx]];
  [_mdic setValue:@0 forKey:@"value"];
  [self.arr_data replaceObjectAtIndex:_int_idx withObject:_mdic];
  [FGUtils reloadCellWithTableView:self.tb_settings atIndex:_int_idx];
}
@end
