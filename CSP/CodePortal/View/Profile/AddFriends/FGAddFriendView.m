//
//  FGAddFriendView.m
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAddFriendView.h"
#import "FGCommonSimpleCellView.h"
#import "FGCustomSearchViewWithButtonView.h"
@interface FGAddFriendView ()
@property (weak, nonatomic) IBOutlet UITableView *tb_addList;
@property (nonatomic, strong) NSArray *arr_data;
@end

@implementation FGAddFriendView
@synthesize arr_data;
@synthesize tb_addList;
@synthesize view_searchBarbg;
@synthesize view_searchBar;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalView];
  [self bindDataToUI];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:tb_addList];
  [commond useDefaultRatioToScaleView:view_searchBarbg];
  // 删除多余行
  self.tb_addList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.arr_data                   = [[NSMutableArray alloc] initWithObjects:@[], @[], @[], @[], @[], @[], nil];

  [self.view_searchBar setupSearchViewWithButton:multiLanguage(@"Cancel") buttonColor:color_homepage_lightGray];
  self.tb_addList.scrollEnabled = NO;
}

- (void)dealloc {
  self.arr_data   = nil;
  self.tb_addList = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50 * ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;

  NSDictionary *info = self.arr_data[indexPath.row];
  cell               = [self commonSimpleInfoViewCell:tableView];

  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:info];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSLog(@"indexPath==%@", indexPath);
  NSString *_str_content = self.arr_data[indexPath.row][@"content"];
  [self.delegate didClickCellWithName:_str_content];
}

#pragma mark - 自定义cell
- (UITableViewCell *)commonSimpleInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGCommonSimpleCellView";
  FGCommonSimpleCellView *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGCommonSimpleCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  return cell;
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  NSDictionary *dic = nil;
  // TODO: 从数据中心获取信息，更新arr_data数组数据

  NSArray *arr = @[
    @{ @"title" : @"newsfeed",
       @"content" : @"Contacts",
       @"color" : color_homepage_lightGray,
       @"id" : @1 },
    @{ @"title" : @"newsfeed",
       @"content" : @"Wechat",
       @"color" : color_homepage_lightGray,
       @"id" : @2 },
    @{ @"title" : @"newsfeed",
       @"content" : @"Weibo",
       @"color" : color_homepage_lightGray,
       @"id" : @3 },
    @{ @"title" : @"newsfeed",
       @"content" : @"QQ",
       @"color" : color_homepage_lightGray,
       @"id" : @1 },
    @{ @"title" : @"newsfeed",
       @"content" : @"Facebook",
       @"color" : color_homepage_lightGray,
       @"id" : @2 },
  ];

  self.arr_data = arr;
  [self.tb_addList reloadData];
}
@end
