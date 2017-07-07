//
//  FGContactsViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGContactsViewController.h"
#import "FGUserPickupTableViewCell.h"
#import "YContactsManager.h"
#import "YContactObject.h"
#import "UIScrollView+MJRefresh.h"
#import <MessageUI/MessageUI.h>

//#import "WXApiWrapper.h"

#define MESSAGE_TITLE @"测试"
#define MESSAGE_CONTENT @"一起来csp吧http://www.baidu.com"

@interface FGContactsViewController () <MFMessageComposeViewControllerDelegate> {
}
@property (nonatomic, strong)NSMutableArray <YContactObject *> *  marr_backupData;
@property (nonatomic, strong)NSMutableArray <YContactObject *> *  marr_data;
@property (nonatomic, strong) YContactsManager * contactManager;
@end

@implementation FGContactsViewController
@synthesize delegate;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self internalInitalViewController];
}

- (void)internalInitalViewController {
  self.tb.delegate = self;
  self.tb.dataSource = self;
  self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  if (self.marr_backupData == nil) {
    self.marr_backupData = [NSMutableArray array];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  self.delegate = nil;
  self.marr_backupData = nil;
  self.marr_data = nil;
  self.contactManager = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

-(void)setupByListType:(ListType)_listType
{
  self.listType = _listType;
  __weak id weakSelf = self;
  if (self.listType == ListType_Contacts){
    [self bindDataToUI_Contacts];
    // 下拉刷新
    self.tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock: ^{
      [weakSelf bindDataToUI_Contacts];
    }];
  }
  else if (self.listType == ListType_WeChatContacts) {
    [self bindDataToUI_WeChatContacts];
    // 下拉刷新
    self.tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock: ^{
      [weakSelf bindDataToUI_WeChatContacts];
    }];
  }
    

  
  
  NSLog(@"self.tb.mj_header==%@",self.tb.mj_header);
  [self.tb.mj_header beginRefreshing];
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
  return [self.marr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = nil;
  
  cell = [self giveMePickupCellView:tableView];
  ((FGUserPickupTableViewCell *)cell).listType = self.listType;
  if (self.marr_data.count > 0){
  //fetch Model
  YContactObject * contactObject = [self.marr_data objectAtIndex:indexPath.row];
  NSDictionary * _dic = @{
                          @"UserIcon": contactObject.headImage == nil ? IMGWITHNAME(@"ic_user_default"):contactObject.headImage,
                          @"UserName": contactObject.nameObject.name,
                          @"UserId":@""};
  [cell updateCellViewWithInfo:_dic];
  }
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
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  return cell;
}

#pragma mark - 获取联系人信息
-(void)bindDataToUI_Contacts
{
  self.marr_data = nil;
  self.marr_data = [NSMutableArray array];
  
  self.contactManager = [YContactsManager shareInstance];
  __weak typeof(self) weakSelf = self;
  //开始请求
  [self.contactManager requestContactsComplete:^(NSArray<YContactObject *> * _Nonnull contacts) {
    //开始赋值
    weakSelf.marr_data = [NSMutableArray arrayWithArray:contacts];
    weakSelf.marr_backupData = [NSMutableArray arrayWithArray:contacts];
//    dispatch_async(dispatch_get_main_queue(), ^{
      //刷新
      [weakSelf.tb reloadData];
      [weakSelf.tb.mj_header endRefreshing];
//    });
  }];
}

#pragma mark - 获取微信联系人
-(void)bindDataToUI_WeChatContacts
{
  self.marr_data = nil;
  self.marr_data = [NSMutableArray array];
}

-(void)bindDataToUI_ContactsWithKey:(NSString *)key {
  self.marr_data = nil;
  NSMutableArray *_marr_tmp = [[NSMutableArray alloc] init];
  
  //fetch Model
  for (YContactObject * contactObject in self.marr_backupData) {
    NSString * _str_name = contactObject.nameObject.name;
    if ([_str_name rangeOfString:key].location != NSNotFound) {
      [_marr_tmp addObject:contactObject];
    }
  }
  self.marr_data = _marr_tmp;
  [self.tb reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tb deselectRowAtIndexPath:indexPath animated:YES];
  YContactObject * contactObject = [self.marr_data objectAtIndex:indexPath.row];
  if (contactObject.phoneObject.count <= 0) {
    [self showAlertWithContent:multiLanguage(@"This user don't have contact info")];
    return;
  }
  __block NSString * _str_phone = contactObject.phoneObject[0].phoneNumber;
  [self.popupController dismissWithCompletion:nil];
  [self.delegate didClickContactWithPhones:@[_str_phone]];
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
    [self bindDataToUI_Contacts];
  }
  else
  {
    if (self.listType == ListType_Contacts) {
      [self bindDataToUI_ContactsWithKey:_newString];
    }
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
  [textField resignFirstResponder];
  return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.tf_search resignFirstResponder];
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
}

- (void)buttonAction_right:(id)_sender {
}

- (void)showAlertWithContent:(NSString *)str_content {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:multiLanguage(@"ALERT")
                                                  message:str_content
                                                 delegate:nil
                                        cancelButtonTitle:multiLanguage(@"OK")
                                        otherButtonTitles:nil, nil];
  [alert show];
}
@end
