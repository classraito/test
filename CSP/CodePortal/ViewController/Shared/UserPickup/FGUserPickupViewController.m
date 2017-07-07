//
//  FGUserPickupViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserPickupViewController.h"
#import "Global.h"
#import "FGUserPickupTableViewCell.h"
#import "NetworkManager_Post.h"
@interface FGUserPickupViewController ()
{
    NSMutableArray *arr_data;
}
@end

@implementation FGUserPickupViewController
@synthesize tb;
@synthesize tf_search;
@synthesize listType;
- (void)viewDidLoad {
    [super viewDidLoad];
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    
    [commond useDefaultRatioToScaleView:tf_search];
    [commond useDefaultRatioToScaleView:tb];
    
    tf_search.font = font(FONT_TEXT_REGULAR, 16);
    // Do any additional setup after loading the view from its nib.
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    tf_search.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tf_search.layer.borderWidth = .5;
    tf_search.layer.cornerRadius = 4;
    tf_search.layer.masksToBounds = YES;
    tf_search.layer.shadowColor = [UIColor blackColor].CGColor;
    tf_search.layer.shadowOffset = CGSizeMake(0, -1);
    tf_search.layer.shadowOpacity = 1;
    tf_search.layer.shadowRadius = 8;
    
    tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    tf_search.leftViewMode = UITextFieldViewModeAlways;
    
    tf_search.delegate = self;
    
    [tf_search addTarget:self
             action:@selector(textFiledEditChanged:)
   forControlEvents:UIControlEventEditingChanged];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
  
    arr_data = nil;
    self.tb.mj_header=nil;
}

-(void)setupByListType:(ListType)_listType
{
    listType = _listType;
    [self internalInitalPost];
    __weak id weakSelf = self;
    // 下拉刷新
    self.tb.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf internalInitalPost];
    }];
    [self.tb.mj_header beginRefreshing];
}

-(void)internalInitalPost
{
    [self postRequest_searchByKeyword:@""];
}

-(void)postRequest_searchByKeyword:(NSString *)_str_keyword
{
    
    if(ListType_Topic == listType)
    {
        [self postRequest_getTopicListByKeyword:_str_keyword];
    }
    else if(ListType_User == listType)
    {
        [self postRequest_getUserListByKeyword:_str_keyword];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *_dic_info = [arr_data objectAtIndex:indexPath.row];
    NSString *str_content;
    NSString *str_link;
    if(listType == ListType_User)
    {
        str_content = [NSString stringWithFormat:@"%@",[_dic_info objectForKey:@"UserName"]];
        str_link = [NSString stringWithFormat:@"%@",[_dic_info objectForKey:@"UserId"]];
    }
    else if(listType == ListType_Topic)
    {
        str_content = [NSString stringWithFormat:@"%@",[_dic_info objectForKey:@"topical"]];
        str_link = [NSString stringWithFormat:@"%@",[_dic_info objectForKey:@"id"]];
        str_link = @"";
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATECONTENT object:
     @{
     @"content":str_content,

     @"link":str_link//@""
     }];
    [self.popupController dismissWithCompletion:^{
        
    }];
     
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50 * ratioH;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
        return [arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMePickupCellView:tableView];
    ((FGUserPickupTableViewCell *)cell).listType = listType;
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMePickupCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGUserPickupTableViewCell";
    FGUserPickupTableViewCell *cell = (FGUserPickupTableViewCell *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGUserPickupTableViewCell *)[nib objectAtIndex:0];
        
    }
    return cell;
}

-(void)bindDataToUI_topic
{
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_topics = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetTopicList)];
    
    NSMutableArray *tmp = [_dic_topics objectForKey:@"Topics"];
    if(tmp && [tmp count]>0)
    {
        [arr_data addObjectsFromArray:tmp];
    }
    else
    {
        NSMutableDictionary *_dic_topicInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_topicInfo setObject:tf_search.text forKey:@"topical"];
        [_dic_topicInfo setObject:@"NewTopic" forKey:@"id"];
        [arr_data addObject:_dic_topicInfo];
    }
    
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
    [self.tb.mj_header endRefreshing];
}

-(void)bindDataToUI_User
{
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_users = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_GetUserList)];
   
    [arr_data addObjectsFromArray:[_dic_users objectForKey:@"Users"]];
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
    [self.tb.mj_header endRefreshing];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength > 100)
        return NO;
//    NSString* _newString=[textField.text stringByReplacingCharactersInRange:range withString:string];
   
    return YES;
}

- (void)textFiledEditChanged:(NSNotification *)obj {
    // TODO: 需要做的逻辑处理
    UITextField *textField = (UITextField *)obj;
    NSString *_newString = textField.text;
    if(textField.markedTextRange)
        return;
    
    NSUInteger newLength = [textField.text length];
    if(newLength ==0 )
    {
        [self internalInitalPost];
    }
    else
    {
        [self postRequest_searchByKeyword:_newString];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [tf_search resignFirstResponder];
}

#pragma mark - 从父类继承的
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_USER_GetUserList) isEqualToString:_str_url]) {
        [self bindDataToUI_User];
    }
    
    if([HOST(URL_POST_GetTopicList) isEqualToString:_str_url])
    {
        [self bindDataToUI_topic];
    }

}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}


#pragma mark - post
-(void)postRequest_getUserList_follower
{
    NSString *_str_followerFilter = (NSString *)[commond getUserDefaults:KEY_API_USER_USERID];
    [[NetworkManager_User sharedManager] postRequest_GetUserList:_str_followerFilter keywords:@"" cursor:0 count:100 userinfo:nil];
}

-(void)postRequest_getUserList_following
{
    NSString *_str_followingFilter = [NSString stringWithFormat:@"@%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    [[NetworkManager_User sharedManager] postRequest_GetUserList:_str_followingFilter keywords:@"" cursor:0 count:100 userinfo:nil];
}

-(void)postRequest_getUserListByKeyword:(NSString *)_str_keyword
{
  [[NetworkManager_User sharedManager] postRequest_GetUserList:@"" keywords:_str_keyword cursor:0 count:100 userinfo:nil];
}

-(void)postRequest_getTopicListByKeyword:(NSString *)_str_keyword
{
    [[NetworkManager_Post sharedManager] postRequest_GetTopicList:_str_keyword cursor:0 count:100 userinfo:nil];
}
@end
