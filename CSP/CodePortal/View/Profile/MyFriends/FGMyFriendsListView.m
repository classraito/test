//
//  FGMyFriendsListView.m
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommonSimpleCellView.h"
#import "FGMyFriendsListView.h"

@interface FGMyFriendsListView () {
  NSInteger int_selectedFollow;
}
@end

@implementation FGMyFriendsListView
@synthesize arr_data;
@synthesize tb_friendsList;
@synthesize delegate;
@synthesize str_id;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalView];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:tb_friendsList];
  self.arr_data = [NSMutableArray array];
  
  self.tb_friendsList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_friendsList addPullToRefreshWithActionHandler:nil];
  [self.tb_friendsList setShowsPullToRefresh:NO];
  [self.tb_friendsList triggerRecoveryAnimationIfNeeded];
  
  self.cursor = 0;
  __weak __typeof(self) weakSelf = self;
  [self.tb_friendsList addInfiniteScrollingWithActionHandler:^{
    if (weakSelf.followType == Friends_Follow) {
      [weakSelf runRequst_getMoreFollow];
    }
    else {
      [weakSelf runRequest_getMoreFollower];
    }
  }];

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
  [self.delegate buttonAction_selectWithFriend:self.arr_data[indexPath.row]];
}

#pragma mark - 自定义cell
- (UITableViewCell *)commonSimpleInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGCommonSimpleCellView";
  FGCommonSimpleCellView *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGCommonSimpleCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  
  if (self.followType == Friends_Follow) {
    [cell setupViewWithRightButtonTitle:multiLanguage(@"UNFOLLOW") font:font(FONT_TEXT_REGULAR, 14) color:[UIColor redColor] borderWidth:1.0 borderColor:[UIColor redColor] backgroundColor:[UIColor whiteColor] cornerRadius:5.0f];
    [cell.btn_right addTarget:self action:@selector(buttonAction_unfollow:) forControlEvents:UIControlEventTouchUpInside];
  } else {
    [cell setupViewHiddenRightBtn:YES];
  }
  return cell;
}


#pragma mark - post
-(void)postRequest_getUserList_followWithId:(NSString *)_str_id
{
  self.str_id = _str_id;
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"id": _str_id}];
  [[NetworkManager_User sharedManager] postRequest_GetUserList:str_id keywords:@"" cursor:self.cursor count:100 userinfo:_mdic];
}

-(void)postRequest_getUserList_followerWithId:(NSString *)_str_id
{
  self.str_id = _str_id;
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"id": _str_id, @"follower":@"follower"}];
  [[NetworkManager_User sharedManager] postRequest_GetUserList:[NSString stringWithFormat:@"@%@",str_id] keywords:@"" cursor:self.cursor count:100 userinfo:_mdic];
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  //NSDictionary *dic = nil;
  // TODO: 从数据中心获取信息，更新arr_data数组数据
  [self.arr_data removeAllObjects];

  NSMutableDictionary *_dic_users = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_GetUserList)];
  ;
  
  self.cursor = [_dic_users[@"Cursor"] intValue];
  NSArray *_arr_users = _dic_users[@"Users"];
  NSMutableArray *_marr_tmp = [NSMutableArray array];
  [_arr_users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic = (NSDictionary *)obj;
    
    [_marr_tmp addObject:@{ @"title" : @"follow",
                            @"url" : _dic[@"UserIcon"],
                            @"name" : _dic[@"UserName"],
                            @"id" : _dic[@"UserId"]
                            }];
  }];
  _arr_users = _marr_tmp;
  
//  _arr_users =
//  @[
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : [NSString stringWithFormat:@"5"]
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @2
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne3",
//       @"id" : @3
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : @4
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @5
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//                @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//                @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne3",
//       @"id" : @6
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : @1
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @2
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne3",
//       @"id" : @3
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : @4
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @5
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne3",
//       @"id" : @6
//       }
//  ];
//  self.cursor = 3423;
//  self.total = 12;
  
  [self.arr_data addObjectsFromArray:_arr_users];
  [self.tb_friendsList reloadData];
  [self hideFooterLoadingIfNeeded];
}

-(void)runRequst_getMoreFollow {
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"loadMore": @"follow"}];
  [[NetworkManager_User sharedManager] postRequest_GetUserList:str_id keywords:@"" cursor:self.cursor count:100 userinfo:_mdic];
}

- (void)runRequest_getMoreFollower {
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"loadMore": @"follower"}];
  [[NetworkManager_User sharedManager] postRequest_GetUserList:str_id keywords:@"" cursor:self.cursor count:100 userinfo:_mdic];
}

- (void)loadMoreUsers {
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_GetUserList)];
  
  self.cursor = [_dic_result[@"Cursor"] intValue];
  NSArray *arr_tmp = _dic_result[@"Users"];
//  arr_tmp =
//  @[
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : @1
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @2
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne3",
//       @"id" : @3
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne1",
//       @"id" : @4
//       },
//    @{ @"title" : @"trainer",
//       @"url" : @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//       @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//       @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//       @"name" : @"Dianne2",
//       @"id" : @5
//       }
//    ];

  [self.arr_data addObjectsFromArray:arr_tmp];
  [self.tb_friendsList reloadData];
  [self hideFooterLoadingIfNeeded];
}

- (void)buttonAction_unfollow:(id)sender {
  UIButton *_btn = (UIButton *)sender;
  FGCommonSimpleCellView* myCell = (FGCommonSimpleCellView *)[[_btn superview] superview];
  NSIndexPath *_index_cell = [self.tb_friendsList indexPathForCell:myCell];
  NSLog(@"indexPath==%@", _index_cell);
  NSDictionary * _dic_users = self.arr_data[_index_cell.row];
  int_selectedFollow = _index_cell.row;
  //许取消关注
  [[NetworkManager_Post sharedManager] postRequest_setFollow:_dic_users[@"id"] isFollow:NO userinfo:[NSMutableDictionary dictionaryWithDictionary:@{@"friendList":@"friendList",@"userid":_dic_users[@"id"]}]];
}

- (void)refreshMyFollowList {
  NSMutableArray * marr_users = [NSMutableArray arrayWithArray:self.arr_data];
  [marr_users removeObjectAtIndex:int_selectedFollow];
  
  self.arr_data = marr_users;
  [self.tb_friendsList reloadData];
}

-(void)hideFooterLoadingIfNeeded {
  
  [self.tb_friendsList.refreshFooter endRefreshing];
  if (self.cursor == -1 || self.total == 0)
    [self.tb_friendsList allowedShowActivityAtFooter:NO];
  else
    [self.tb_friendsList allowedShowActivityAtFooter:YES];
}
@end
