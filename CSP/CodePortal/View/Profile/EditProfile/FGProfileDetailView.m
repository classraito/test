//
//  FGProfileDetailView.m
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGDataPickeriView.h"
#import "FGHomepageTitleView.h"
#import "FGProfileDetailView.h"
#import "FGProfileInfoDetailCellView.h"
#import "Global.h"
#import "UITableView+InputPageView.h"
#import "UIView+ViewController.h"
@interface FGProfileDetailView () <FGDataPickerViewDelegate, TableViewInputDelegate, UITextFieldDelegate> {
  UIImage* _img_avatar;
  NSUInteger hash_originData;
}
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, strong) FGHomepageTitleView *view_myDetailsTitle;
@property (nonatomic, strong) FGHomepageTitleView *view_myFitnessTitle;
@property (nonatomic, strong) FGDataPickeriView *dp_singleData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL isInputStatus;

@end

@implementation FGProfileDetailView
@synthesize dp_singleData;
@synthesize arr_data;
@synthesize imgPicker_userPic;
@synthesize str_id;
@synthesize delegate;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:self.tb_userInfo];
  self.tb_userInfo.hidden = YES;
  [self internalInitalProfileSectionTitleView];
  [self internalNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify_updateMobile:) name:NOTIFICATION_UpdateUserMobile object:nil];
    

    
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
    [self.tb_userInfo removeAllInputView];
  [self.tb_userInfo clearMemory];
  self.tb_userInfo = nil;
  self.view_myDetailsTitle = nil;
  self.view_myFitnessTitle = nil;
  self.dp_singleData       = nil;
  self.selectedIndexPath   = nil;
  self.imgPicker_userPic   = nil;
  self.str_id              = nil;
  
  _img_avatar              = nil;
  self.arr_data  = nil;
  [self clearNotification];
}

-(void)notify_updateMobile:(NSNotification *)_notification
{
   
    NSString *str_mobileNum = _notification.object;
    NSLog(@"str_mobileNum = %@",str_mobileNum);
    
    str_mobileNum = [str_mobileNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self updateArrDataWithNewValue:str_mobileNum withSpecialValue:@""];
  [FGUtils reloadCellWithTableView:self.tb_userInfo atSection:0 atIndex:3];
}

#pragma mark - 初始化
- (void)internalInitalProfileSectionTitleView {
  FGHomepageTitleView *titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"My Details") color:color_homepage_lightGray andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  [titleView setupWithBgColor:color_bgGray leftTitleFont:font(FONT_TEXT_REGULAR, 14) rightTitleFont:font(FONT_TEXT_REGULAR, 14)];
  titleView.frame          = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  self.view_myDetailsTitle = titleView; //添加标题信息
  
  titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"My Fitness") color:color_homepage_lightGray andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  [titleView setupWithBgColor:color_bgGray leftTitleFont:font(FONT_TEXT_REGULAR, 14) rightTitleFont:font(FONT_TEXT_REGULAR, 14)];
  titleView.frame          = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  self.view_myFitnessTitle = titleView;
  
  self.tb_userInfo.delegate   = self;
  self.tb_userInfo.dataSource = self;
}




- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_selectCityWithInfo:) name:NOTIFICATION_SELECTCITY object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SELECTCITY object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UpdateUserMobile object:nil];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50 * ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data[section] count]; //[arr_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
  if (section == 0)
    return self.view_myDetailsTitle.frame.size.height;
  else
    return self.view_myFitnessTitle.frame.size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0)
    return self.view_myDetailsTitle;
  else
    return self.view_myFitnessTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSDictionary *info    = self.arr_data[indexPath.section][indexPath.row];
  NSLog(@"info = %@,title = %@", info, info[@"title"]);
  cell = [self profileInfoViewCell:tableView withIndexPath:indexPath];

  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:info];
    //    FGProfileInfoDetailCellView *gcell = (FGProfileInfoDetailCellView *)cell;
    //    NSString *content                  = [NSString stringWithFormat:@"section=%d,index=%d", indexPath.section, indexPath.row];
    //    [gcell.lb_rightTitle setupHTMLLabelWithContent:content linkFont:[UIFont boldSystemFontOfSize:14] linkColor:[UIColor blueColor] activeLinkFont:[UIFont boldSystemFontOfSize:14] activeColor:[UIColor blueColor] delegate:self inWidth:200];
    //    gcell.lb_rightTitle.backgroundColor = [UIColor lightGrayColor];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  self.selectedIndexPath = indexPath;

  NSDictionary *info  = self.arr_data[indexPath.section][indexPath.row];
  NSString *str_title = info[@"title"];
  if ([str_title isEqualToString:multiLanguage(@"Age")]){
    [self selectedPickerWithAge:[info[@"content"] integerValue]];
  } else if ([str_title isEqualToString:multiLanguage(@"Gender")]) {
    [self selectedPickerWithGender:GenderToInteger(info[@"content"])];
  } else if ([str_title isEqualToString:multiLanguage(@"Boxing Level")]) {
    [self selectedPickerWithBoxingLevel:BoxingLevelToInteger(info[@"content"])];
  } else if ([str_title isEqualToString:multiLanguage(@"Goal")]) {
    [self selectedPickerWithGoal:GoalToInteger(info[@"content"])];
  } else if ([str_title isEqualToString:multiLanguage(@"Profile Picture")]) {
    [self actionSheetWithSelectedUserPic];
  } else if ([str_title isEqualToString:multiLanguage(@"Notinality")]) {
    [commond presentCitiesPickViewFromController:[self viewController]];
  }
  else if([str_title isEqualToString:multiLanguage(@"Phone Number")])
  {
      NSLog(@"info = %@",info);
      NSString *str_mobileNumber = info[@"content"];
      NSLog(@"str_mobileNumber = %@",str_mobileNumber);
      if(str_mobileNumber && ![str_mobileNumber isEmptyStr])
      {
          FGControllerManager *manager = [FGControllerManager sharedManager];
          FGBindPhoneNumberViewController *vc_bindPhoneNum = [[FGBindPhoneNumberViewController alloc] initWithNibName:@"FGBindPhoneNumberViewController" bundle:nil mobileNum:info[@"content"]];
          [manager pushController:vc_bindPhoneNum navigationController:nav_current];
      }
      else{
          FGControllerManager *manger = [FGControllerManager sharedManager];
          FGBindPhoneNumberNewPhoneViewController *vc_bindPhoneNumNew = [[FGBindPhoneNumberNewPhoneViewController alloc] initWithNibName:@"FGBindPhoneNumberNewPhoneViewController" bundle:nil];
          [manger pushController:vc_bindPhoneNumNew navigationController:nav_current];
      }//没有填写过手机号码
     
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)profileInfoViewCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier   = @"FGProfileInfoDetailCellView";
  FGProfileInfoDetailCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileInfoDetailCellView" owner:self options:nil] lastObject];
  }

  if (indexPath.section == 0 && indexPath.row == 0) {
    [cell setupCellInfoWithHidden:NO];
  } else {
    [cell setupCellInfoWithHidden:YES];
    cell.tf_content.delegate = self;
    [cell.tf_content addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
      [cell.tf_content addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventTouchUpInside];
  }
  [cell setupCellInfoWithLeftFont:font(FONT_TEXT_REGULAR, 14) leftColor:color_homepage_lightGray rightFont:font(FONT_TEXT_REGULAR, 14) rightColor:color_homepage_black];

  return cell;
}

#pragma mark - 成员方法
- (void)bindDataToUI {

  [self.arr_data removeAllObjects];
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_GetUserProfile)];
  NSLog(@"user profile=%@",_dic_result);
  NSDictionary *_dic_userInfo = _dic_result;
  self.tb_userInfo.hidden = NO;
  
  NSString *_str_userIconUrl = @"";
  if ([_dic_userInfo[@"UserIcon"] hasPrefix:@"http"]) {
    _str_userIconUrl = _dic_userInfo[@"UserIcon"];
  }
  //先把头像保存本地
  NSString *_str_cityName = [FGUtils getCityNameWithId:_dic_userInfo[@"Nationality"]];
  UIImage *_img = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATAR]);

  NSArray *_arr_tmp = @[ @[
                      @{ @"title" : multiLanguage(@"Profile Picture"),
                         @"content" : _img,//[FGUtils pathInDocumentsWithPNG:USERAVATAR],
                         //@"bgBlur" : _img_blur,
                         @"userIcon": _img,
                         @"type" : @"actionsheet",
                         @"thumbnailUrl" : _str_userIconUrl},
                      @{ @"title" : multiLanguage(@"Username"),
                         @"content" : _dic_userInfo[@"UserName"],
                         @"type" : @"input" },
                      @{ @"title" : multiLanguage(@"Location"),
                         @"content" : _dic_userInfo[@"Location"],
                         @"type" : @"input" },
                      @{ @"title" : multiLanguage(@"Phone Number"),
                         @"content" : _dic_userInfo[@"Mobile"],
                         @"type" : @"input" },
                      @{ @"title" : multiLanguage(@"Name"),
                         @"content" : _dic_userInfo[@"Name"],
                         @"type" : @"input" },
                      @{ @"title" : multiLanguage(@"Age"),
                         @"content" : [NSString stringWithFormat:@"%@",_dic_userInfo[@"Age"]],
                         @"type" : @"picker" },
                      @{ @"title" : multiLanguage(@"Gender"),
                         @"content" : GenderToString([_dic_userInfo[@"Gender"] intValue]),//@"Female",
                         @"type" : @"picker" },
                      @{ @"title" : multiLanguage(@"Notinality"),
                         @"content" : _str_cityName,//_dic_userInfo[@"Nationality"],
                         @"type" : @"picker" },
                      @{ @"title" : multiLanguage(@"Weight(kg)"),
                         @"content" : [NSString stringWithFormat:@"%@",_dic_userInfo[@"Weight"]],
                         @"type" : @"input" },
                      @{ @"title" : multiLanguage(@"Height(cm)"),
                         @"content" : [NSString stringWithFormat:@"%@",_dic_userInfo[@"Height"]],
                         @"type" : @"input" },
                    ],
                     @[
                       @{ @"title" : multiLanguage(@"Goal"),
                          @"content" : GoalToString([_dic_userInfo[@"Goal"] intValue]),
                          @"type" : @"picker" },
                       @{ @"title" : multiLanguage(@"Boxing Level"),
                          @"content" : BoxingLevelToString([_dic_userInfo[@"Boxing_Level"] intValue]),
                          @"type" : @"picker" },
                       @{ @"title" : multiLanguage(@"Gym"),
                          @"content" : _dic_userInfo[@"Gym"],
                          @"type" : @"input" }
                     ] ];

  self.arr_data = [NSMutableArray arrayWithArray:_arr_tmp];
  [self.tb_userInfo reloadData];
  __weak __typeof(self) weakSelf = self;
  __weak __typeof(UITableView *) weakSelf_tb_userInfo = self.tb_userInfo;
  [self.tb_userInfo setupByOriginalContentSize:self.tb_userInfo.contentSize delegate:weakSelf inView:weakSelf_tb_userInfo];
  
  hash_originData = [[self profileDetailInfo] hash];
    
}

- (void)updateArrDataWithNewValue:(NSString *)str_value pickerType:(PickerType)pickerType {
  NSMutableArray *tmp_dataArr         = [NSMutableArray arrayWithArray:self.arr_data];
  NSMutableArray *tmp_section_dataArr = [NSMutableArray arrayWithArray:tmp_dataArr[self.selectedIndexPath.section]];
  NSDictionary *oldInfo               = tmp_section_dataArr[self.selectedIndexPath.row];
  NSDictionary *newInfo               = @{
    @"title" : oldInfo[@"title"],
    @"content" : str_value,
    @"type": oldInfo[@"type"]
  };
  [tmp_section_dataArr replaceObjectAtIndex:self.selectedIndexPath.row withObject:newInfo];
  [tmp_dataArr replaceObjectAtIndex:self.selectedIndexPath.section withObject:tmp_section_dataArr];
  self.arr_data = [NSMutableArray arrayWithArray:tmp_dataArr];
  [self.tb_userInfo reloadRowsAtIndexPaths:@[ self.selectedIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateArrDataWithNewValue:(NSString *)str_value withSpecialValue:(NSString *)_str_special {
  NSMutableArray *tmp_dataArr         = [NSMutableArray arrayWithArray:self.arr_data];
  NSMutableArray *tmp_section_dataArr = [NSMutableArray arrayWithArray:tmp_dataArr[self.selectedIndexPath.section]];
  NSDictionary *oldInfo               = tmp_section_dataArr[self.selectedIndexPath.row];
  NSDictionary *newInfo               = @{
                                          @"title" : oldInfo[@"title"],
                                          @"content" : str_value,
                                          @"type": oldInfo[@"type"],
                                          @"special":_str_special
                                          };
  [tmp_section_dataArr replaceObjectAtIndex:self.selectedIndexPath.row withObject:newInfo];
  [tmp_dataArr replaceObjectAtIndex:self.selectedIndexPath.section withObject:tmp_section_dataArr];
  self.arr_data = [NSMutableArray arrayWithArray:tmp_dataArr];
}

- (void)notification_selectCityWithInfo:(id)sender {
  NSDictionary *_dic_info = (NSDictionary *)[sender object];
  NSString *_str_code = [NSString stringWithFormat:@"%@",_dic_info[@"cityId"]];
  NSString *_str_cityAll = [NSString stringWithFormat:@"%@",_dic_info[@"cityAll"]];
  [self updateArrDataWithNewValue:[FGUtils getCityNameWithId:_str_code] withSpecialValue:[FGUtils getCityNameWithString:_str_cityAll]];
  [self.tb_userInfo reloadData];
}

#pragma mark - 自定义事件
- (void)selectedPickerWithAge:(NSInteger)age {
  [self.tb_userInfo removeAllInputView];
  [self internalInitalDataPickerView:[NSNumber numberWithInt:PickerType_Age] currentVal:age];
}

- (void)selectedPickerWithGender:(enum_Gender)gender {
  [self.tb_userInfo removeAllInputView];
  [self internalInitalDataPickerView:[NSNumber numberWithInt:PickerType_Gender] currentVal:gender];
}

- (void)selectedPickerWithBoxingLevel:(enum_BoxingLevel)boxingLevel {
  [self.tb_userInfo removeAllInputView];
  [self internalInitalDataPickerView:[NSNumber numberWithInteger:PickerType_BoxingLevel] currentVal:boxingLevel];
}

- (void)selectedPickerWithGoal:(enum_Goal)goal {
  [self.tb_userInfo removeAllInputView];
  [self internalInitalDataPickerView:[NSNumber numberWithInteger:PickerType_Goal] currentVal:goal];
}

- (void)actionSheetWithSelectedUserPic {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:multiLanguage(@"Choose Image") delegate:self cancelButtonTitle:multiLanguage(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:multiLanguage(@"Camera"),multiLanguage(@"Photos"), nil];
  [actionSheet showInView:self];
}

#pragma mark - 初始化 FGDataPickerView
- (void)internalInitalDataPickerView:(NSNumber *)_hhmmssPickerType currentVal:(NSInteger)val {
  if (self.dp_singleData)
    return;

  self.dp_singleData          = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
  self.dp_singleData.delegate = self;
  self.dp_singleData.tag      = [_hhmmssPickerType integerValue];

  NSMutableArray *arr_numbers = nil;
  if (self.dp_singleData.tag == PickerType_Age) {
    arr_numbers = [NSMutableArray arrayWithCapacity:99];
    for (int i = 1; i < 100; i++) {
      [arr_numbers addObject:[commond numberMinDigitsFormatter:1 num:i]];
    }
  } else if (self.dp_singleData.tag == PickerType_Gender) {
    arr_numbers = [NSMutableArray arrayWithObjects:GenderToString(Gender_Male), GenderToString(Gender_Female), nil];
  } else if (self.dp_singleData.tag == PickerType_BoxingLevel) {
    arr_numbers = [NSMutableArray arrayWithObjects:BoxingLevelToString(BL_Beginner), BoxingLevelToString(BL_Intermediate), BoxingLevelToString(BL_Advanced), nil];
  } else if (self.dp_singleData.tag == PickerType_Goal) {
    arr_numbers = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
      [arr_numbers addObject:GoalToString(i)];
    }
  }
  [dp_singleData setupDatas:arr_numbers];

  CGRect _frame             = self.dp_singleData.frame;
  _frame.size.width         = self.frame.size.width;
  _frame.origin.y           = H;
  self.dp_singleData.frame  = _frame;
  self.dp_singleData.center = CGPointMake(self.frame.size.width / 2, self.dp_singleData.center.y);
  [appDelegate.window addSubview:self.dp_singleData];

  [UIView beginAnimations:nil context:nil];
  _frame                   = self.dp_singleData.frame;
  _frame.origin.y          = H - self.dp_singleData.frame.size.height;
  self.dp_singleData.frame = _frame;
  [UIView commitAnimations];

  [self.tb_userInfo adjustVisibleRegion:self.dp_singleData.frame.size.height];
  [self.dp_singleData.pv selectRow:(val - 1) inComponent:0 animated:YES];
}

#pragma mark - 更新地址栏
-(void)updateLocationAddress:(NSString *)_str_address
{
    FGProfileInfoDetailCellView *cell_location = [self.tb_userInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell_location.tf_content.text = _str_address;
  self.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
  [self updateArrDataWithNewValue:_str_address withSpecialValue:@""];
}



#pragma mark - TextFieldDelegate
- (void) textFieldDidChange:(UITextField *)textField{
  NSLog(@"textField==%@", textField.text);
  UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
  NSIndexPath *_indexPath_ = [self.tb_userInfo indexPathForCell:cell];
  
  if (_indexPath_.section == 0 && _indexPath_.row == 8) {
    //限制体重
    float flt_val = [textField.text floatValue];
    if (![self isValiateWithFlt:flt_val limit:1000]) {
      textField.text = [textField.text substringToIndex:textField.text.length-1];
    }

  } else if (_indexPath_.section == 0 && _indexPath_.row == 9) {
    //限制身高
    float flt_val = [textField.text floatValue];
    if (![self isValiateWithFlt:flt_val limit:1000]) {
      textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
  }
  
  self.selectedIndexPath = _indexPath_;
  [self updateArrDataWithNewValue: textField.text withSpecialValue:@""];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *_indexPath_ = [self.tb_userInfo indexPathForCell:cell];
    self.selectedIndexPath = _indexPath_;
    
    if(self.selectedIndexPath.section==0 &&
       self.selectedIndexPath.row == 2)
    {
        [textField resignFirstResponder];
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGProfileSetDefaultAddressViewController *vc = [[FGProfileSetDefaultAddressViewController alloc] initWithNibName:@"FGProfileSetDefaultAddressViewController" bundle:nil address:textField.text];
        [manager pushController:vc navigationController:nav_current];
        
    }//去地址编辑页
}

#pragma mark -  FGDataPickerViewDelegate
- (void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
  if ([_dataPicker isKindOfClass:[FGDataPickeriView class]]) {
    FGDataPickeriView *tmp_dataPickerView = (FGDataPickeriView *)_dataPicker;
    PickerType pickerType                 = tmp_dataPickerView.tag;
    if (pickerType == PickerType_Age ||
        pickerType == PickerType_Gender ||
        pickerType == PickerType_BoxingLevel ||
        pickerType == PickerType_Goal) {
      //update date
      [self updateArrDataWithNewValue:_str_selected pickerType:pickerType];
    }
  }
  //  [self saveSettings];
}

- (void)didCloseDataPicker:(NSString *)_str_selected picker:(id)_dataPicker;
{
  [self clearTableViewInput];
}

#pragma mark - 从父类继承的方法 实现移除全部弹出控件 父类只实现了移除所有键盘 其他自定义控件要在此实现移除
- (void)clearTableViewInput {
  if (dp_singleData) {
    CGRect _frame       = dp_singleData.frame;
    _frame.origin.y     = H;
    [self.tb_userInfo resetVisibleRegion];

    //动画
    [UIView animateWithDuration:0.3f animations:^{
      dp_singleData.frame = _frame;
    } completion:^(BOOL finished) {
      [dp_singleData removeFromSuperview];
      dp_singleData = nil;
    }];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [commond dismissKeyboard:appDelegate.window];
  [self.tb_userInfo removeAllInputView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"buttonIndex==%lu",buttonIndex);
  if (buttonIndex == 0) {
    //Camera
    [self takePhoto];
  } else if (buttonIndex == 1) {
    //Photoes
    [self LocalPhoto];
  }
}

#pragma mark - image picker delegate 
//开始拍照
-(void)takePhoto
{
  UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
  if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
  {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    UIViewController *vc_selfView = [self viewController];
//    [vc_selfView presentModalViewController:picker animated:YES];
    [vc_selfView presentViewController:picker animated:YES completion:^{
      
    }];
  }else
  {
    NSLog(@"模拟其中无法打开照相机,请在真机中使用");
  }
}

//打开本地相册
-(void)LocalPhoto
{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.delegate = self;
  //设置选择后的图片可被编辑
  picker.allowsEditing = YES;
  UIViewController *vc_selfView = [self viewController];
//  [vc_selfView presentModalViewController:picker animated:YES];
  [vc_selfView presentViewController:picker animated:YES completion:^{
    
  }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
  NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
  
  //当选择的类型是图片
  if ([type isEqualToString:@"public.image"])
  {
    //先把图片转成NSData
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
      // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
      // 以下为调整图片角度的部分
      UIGraphicsBeginImageContext(image.size);
      [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
      image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      // 调整图片角度完毕
    }
    
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
      data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
      data = UIImagePNGRepresentation(image);
    }
    
    _img_avatar = image;
    [self runRequest_uploadUserIconWithImage:image];
  }
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  NSLog(@"您取消了选择图片");
  [picker dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (void)updateUserPicWithFile:(UIImage *)_img withThumbnail:(NSString *)_str_thumbnailUrl {
  
  NSMutableDictionary *mdic_userPic = [[NSMutableDictionary alloc] initWithDictionary: self.arr_data[0][0]];
  [mdic_userPic setValue:@"" forKey:@"content"];
  [mdic_userPic setValue:_str_thumbnailUrl forKey:@"thumbnailUrl"];
  [mdic_userPic setValue:_img forKey:@"userIcon"];
  
  NSMutableArray *marr_data = [NSMutableArray arrayWithArray:self.arr_data];
  NSMutableArray *marr_firstSection = [NSMutableArray arrayWithArray:marr_data[0]];
  [marr_firstSection replaceObjectAtIndex:0 withObject:mdic_userPic];
  [marr_data replaceObjectAtIndex:0 withObject:marr_firstSection];

  self.arr_data = marr_data;
  [[self viewController] dismissViewControllerAnimated:YES completion:^{
    [self.tb_userInfo reloadData];
  }];
}

#pragma mark - 上传头像请求
- (void)runRequest_uploadUserIconWithImage:(UIImage *)_img_userAvatar {
  [commond showLoading];
  UIImage *imgNeedUpload = _img_userAvatar;
  ASINetworkQueue *asiQueue = [[NetworkManager_UploadFile sharedManager] startUploadImages:(NSMutableArray *)@[imgNeedUpload]];
  asiQueue.delegate = self;
  asiQueue.requestDidFinishSelector = @selector(didFinishUploadFilesInQueue:);
  asiQueue.requestDidFailSelector = @selector(didFailedUploadFilesInQueue:);
}

#pragma mark - 上传文件结束回调
-(void)didFinishUploadFilesInQueue:(ASIHTTPRequest *)request
{
  [commond removeLoading];
  NSString *str_response = request.responseString;
  
  int responseCode = request.responseStatusCode;
  
  if (responseCode != 200) {
    [commond removeLoading];
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    return; //第一级检查返回码,(http 返回码)
  }
  
  
  NSMutableDictionary *_dic_json = [str_response mutableObjectFromJSONString]; //转json对象
  
  if (!_dic_json || [_dic_json count]<=0) //第二次检查
    return;
  
  
  NSString *_str_fileUrl1 = [_dic_json objectForKey:@"Url1"];
  
  responseCode = [[_dic_json objectForKey:@"Code"] intValue];
  if(responseCode != 0 ) {
    [commond alert:multiLanguage(@"ALERT") message:_dic_json[@"Msg"] callback:nil];
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    return;
  }
  
  
//   if ([FGUtils saveDocumentsFilePNGWithName:USERAVATAR fileData:data])
   {
   //得到选择后沙盒中图片的完整路径
     //[FGUtils pathInDocumentsWithFileName:@"userAvatar.png"];
     NSString * filePath = _str_fileUrl1;
     NSString * _url_small = _dic_json[@"Url2"];
     
     //上传成功后保存图像
     if (_img_avatar) {
       //保存模糊效果
       [FGUtils saveDocumentsFilePNGWithName:USERAVATARBLURBG fileData:[FGUtils getBlurEffectWithImage:_img_avatar]];
       [FGUtils saveDocumentsFilePNGWithName:USERAVATAR fileData:[FGUtils getDataWithImage:_img_avatar]];
       NSLog(@"Save success...");
       //得到选择后沙盒中图片的完整路径
       filePath = [FGUtils pathInDocumentsWithPNG:USERAVATAR];
       [self updateUserPicWithFile:_img_avatar withThumbnail:_str_fileUrl1];
     }
  
   }
}

-(void)didFailedUploadFilesInQueue:(ASIHTTPRequest *)request
{
  [commond removeLoading];
}

#pragma mark - 其它方法
- (NSMutableArray *)profileDetailInfo {
  NSArray *_arr_basicInfo = self.arr_data[0];
  NSArray *_arr_otherInfo = self.arr_data[1];
  NSLog(@"_marr_data==%@", self.arr_data);
  ;
  NSDictionary * _dic = nil;
  NSMutableArray *_marr_data = [NSMutableArray array];
  for (int i =0; i < _arr_basicInfo.count; i++) {
    NSDictionary *_dic_info  = _arr_basicInfo[i];
    _dic = nil;
    if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Profile Picture")]) {
      NSString * _str = _arr_basicInfo[i][@"thumbnailUrl"];
      if (!ISNULLObj(_str) && [_str hasPrefix:@"http"])
        _dic = @{@"ActionType":@"ProfilePic",@"Value":_str};
      else
        _dic = @{@"ActionType":@"ProfilePic",@"Value":@""};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Username")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      _dic = @{@"ActionType":@"UserName",@"Value":[_str trimmingWhitespace]};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Location")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      _dic = @{@"ActionType":@"Location",@"Value":_str};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Name")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
       _dic = @{@"ActionType":@"Name",@"Value":_str};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Age")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      _dic = @{@"ActionType":@"Age",@"Value":_str};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Gender")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      _dic = @{@"ActionType":@"Gender",@"Value":[NSString stringWithFormat:@"%ld", GenderToInteger(_str)]};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Notinality")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      NSString * _str_cityCode = [FGUtils getCityIdWithName:_str];
      _dic = @{@"ActionType":@"Nationality",@"Value":_str_cityCode};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Weight(kg)")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
       _dic = @{@"ActionType":@"Weight",@"Value":_str};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Height(cm)")]) {
      NSString * _str = _arr_basicInfo[i][@"content"];
      _dic = @{@"ActionType":@"Height",@"Value":_str};
    }
    if (_dic)
      [_marr_data addObject:_dic];
  }
  for (int i =0; i < _arr_otherInfo.count; i++) {
    NSDictionary *_dic_info  = _arr_otherInfo[i];
    _dic = nil;
    if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Goal")]) {
      NSString * _str = _arr_otherInfo[i][@"content"];
      _dic = @{@"ActionType":@"Goal",@"Value":[NSString stringWithFormat:@"%i",GoalToInteger(_str)]};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Boxing Level")]) {
      NSString * _str = _arr_otherInfo[i][@"content"];
      _dic = @{@"ActionType":@"Boxing_Level",@"Value":[NSString stringWithFormat:@"%i",BoxingLevelToInteger(_str)]};
    } else if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Gym")]) {
      NSString * _str = _arr_otherInfo[i][@"content"];
      _dic = @{@"ActionType":@"Gym",@"Value":_str};
    }
    if (_dic)
      [_marr_data addObject:_dic];
  }
  NSLog(@"_marr_data==%@", _marr_data);
  return _marr_data;
}

- (BOOL)hasUpdatePersonInfo {
  return YES;
}

- (BOOL)isValiadteUserName {
  NSArray *_arr_basicInfo = self.arr_data[0];
  NSString *_str_userName = @"";
  NSDictionary * _dic = nil;
  for (int i =0; i < _arr_basicInfo.count; i++) {
    NSDictionary *_dic_info  = _arr_basicInfo[i];
    _dic = nil;
    if ([_dic_info[@"title"] isEqualToString:multiLanguage(@"Username")]) {
      _str_userName = _arr_basicInfo[i][@"content"];
      break;
    }
  }
  
  if ([[_str_userName trimmingWhitespace] isEmptyStr]) {
    return NO;
  }
  return YES;
}

- (BOOL)isValiateWithFlt:(float)_flt_val limit:(float)_flt_limit {
  if (_flt_val > _flt_limit) {
    return NO;
  }
  return YES;
}
@end
