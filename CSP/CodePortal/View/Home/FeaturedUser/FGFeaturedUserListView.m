//
//  FGFeaturedUserListView.m
//  CSP
//
//  Created by JasonLu on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFeaturedUserListView.h"

@implementation FGFeaturedUserListView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  self.followType = Friends_Follower;
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
  
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.delegate buttonAction_selectWithFriend:self.arr_data[indexPath.row]];
}

#pragma mark - 自定义cell
- (UITableViewCell *)commonSimpleInfoViewCell:(UITableView *)tableView {
  return [super commonSimpleInfoViewCell:tableView];;
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  NSDictionary *dic = nil;
  // TODO: 从数据中心获取信息，更新arr_data数组数据
  
  NSArray *trainers = @[
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne1",
                           @"id" : @1 },
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne2",
                           @"id" : @2 },
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne3",
                           @"id" : @3 },
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne1",
                           @"id" : @1 },
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne2",
                           @"id" : @2 },
                        @{ @"title" : @"trainer",
                           @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
                           @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
                           @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"name" : @"Dianne3",
                           @"id" : @3 },
                        ];
  
  self.arr_data = trainers;
  [self.tb_friendsList reloadData];
}
@end
