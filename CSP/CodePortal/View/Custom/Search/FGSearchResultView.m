//
//  FGSearchResultView.m
//  CSP
//
//  Created by JasonLu on 16/10/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGSearchResultView.h"
#import "UIScrollView+FGRereshHeader.h"
@interface FGSearchResultView ()

@end

@implementation FGSearchResultView
@synthesize arr_data;
@synthesize tb_serachResult;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:tb_serachResult];
  [self internalInitalSearchResultView];

  [self bindDataToUI];
}

- (void)internalInitalSearchResultView {
}

- (void)dealloc {
  self.arr_data = nil;
  self.delegate = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44 * ratioH;
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
  cell                  = [self searchResultViewCell:tableView];

  NSString *str_search = self.arr_data[indexPath.row];
  cell.textLabel.text  = str_search;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.delegate didSelectedWithResult:self.arr_data[indexPath.row]];
}

#pragma mark - 自定义cell
- (UITableViewCell *)searchResultViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGSearchCellView";
  UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.textColor = [UIColor blackColor];
  return cell;
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  NSDictionary *dic = nil;
  // TODO: 从数据中心获取信息，更新arr_data数组数据
  
  NSArray *_arr_searchKeys_tmp = [FGUtils searchKeys];
  NSMutableArray *_marr_searchKeys = [NSMutableArray array];
  for (NSString *_str_key in _arr_searchKeys_tmp) {
    if ([_str_key isEmptyStr]) {
      continue;
    }
    [_marr_searchKeys addObject:_str_key];
  }
  
  
  self.arr_data = _marr_searchKeys;
  [self.tb_serachResult reloadData];
}

- (void)action_loadingData {
//  [self.tb_serachResult setupLoadingMaskLayerHidden:NO withAlpha:0.8f];
}
@end
