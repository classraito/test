//
//  FGWorkoutsListView.m
//  CSP
//
//  Created by JasonLu on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkoutsListView.h"
#import "FGHomepageSearchWorkoutInfoCellView.h"
@implementation FGWorkoutsListView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  self.tb_friendsList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self bindDataToUI];
}

- (void)dealloc {
  self.arr_data       = nil;
  self.tb_friendsList = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100 * ratioH;
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
  cell               = [self workoutInfoViewCell:tableView];
  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:info];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.delegate buttonAction_selectWithFriend:self.arr_data[indexPath.row]];
}

#pragma mark - 自定义cell
- (UITableViewCell *)workoutInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier           = @"FGHomepageSearchWorkoutInfoCellView";
  FGHomepageSearchWorkoutInfoCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageSearchWorkoutInfoCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  return cell;
}


#pragma mark - 成员方法
- (void)bindDataToUI {
  NSDictionary *dic = nil;
  // TODO: 从数据中心获取信息，更新arr_data数组数据
  NSArray *workouts = @[ @{
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"title" : @"FEARLESS FOCUS",
                           @"content" : @"this is kdkf fjdjfdjf jdjkfjdkjfd fjkdjfkd jfkdjkf djkfjdkj kfdfjkdj kjfkdjfkjdkj kjfdkjfkdjfkdjksfjlkdjfkdjafdksajkfdjsfdfsdalfjdajfldajkdjalfa jkfdafdafdaf"
                           },
                         @{ @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                            @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                            @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                            @"title" : @"FEARLESS FOCUS",
                            @"content" : @"this is kdkf fjdjfdjf jdjkfjdkjfd fjkdjfkd jfkdjkf djkfjdkj kfdfjkdj kjfkdjfkjdkj kjfdkjfkdjfkdjksfjlkdjfkdjafdksajkfdjsfdfsdalfjdajfldajkdjalfa jkfdafdafdaf" },
                         @{ @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                            @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                            @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                            @"title" : @"FEARLESS FOCUS",
                            @"content" : @"this is kdkf fjdjfdjf jdjkfjdkjfd fjkdjfkd jfkdjkf djkfjdkj kfdfjkdj kjfkdjfkjdkj kjfdkjfkdjfkdjksfjlkdjfkdjafdksajkfdjsfdfsdalfjdajfldajkdjalfa jkfdafdafdaf" }
                         ];
  
  self.arr_data =  [NSMutableArray arrayWithArray: workouts];
  [self.tb_friendsList reloadData];
}
@end
