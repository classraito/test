//
//  FGAboutusView.m
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGAboutusView.h"
#import "FGAboutusTitleView.h"

@interface FGAboutusView () <FGSectionHeaderDelegate> {
  
}
@property (nonatomic, strong) NSMutableArray *arr_data;
@end

@implementation FGAboutusView
@synthesize arr_data;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self internalInitalData];
  [self internalInitalView];
  
  [commond useDefaultRatioToScaleView:self.tb_aboutus];
}

- (void)internalInitalData {
  arr_data = [NSMutableArray arrayWithObjects:@{@"status":@NO, @"tag":@0},@{@"status":@NO,@"tag":@1}, nil];
}

- (void)internalInitalView {
  self.tb_aboutus.dataSource = self;
  self.tb_aboutus.delegate   = self;
  
  self.tb_aboutus.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_aboutus reloadData];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([arr_data[indexPath.row] isEqualToNumber:@YES]) {
    return 100 * ratioH;
  }
  
  return 45 * ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
  return 50 * ratioH;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [NSString stringWithFormat:@"Title %ld",section];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//  if (section == 0)
//    return self.view_myDetailsTitle;
//  else
//    return self.view_myFitnessTitle;
//  
//  YUFoldingSectionHeader *sectionHeaderView = [[YUFoldingSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [self tableView:self heightForHeaderInSection:section])  withTag:section];
//  
//  [sectionHeaderView setupWithBackgroundColor:[self backgroundColorForSection:section]
//                                  titleString:[self titleForSection:section]
//                                   titleColor:[self titleColorForSection:section]
//                                    titleFont:[self titleFontForSection:section]
//                            descriptionString:[self descriptionForSection:section]
//                             descriptionColor:[self descriptionColorForSection:section]
//                              descriptionFont:[self descriptionFontForSection:section]
//                                   arrowImage:[self arrowImageForSection:section]
//                                arrowPosition:[self perferedArrowPosition]
//                                 sectionState:((NSNumber *)self.statusArray[section]).integerValue];
//  
//  sectionHeaderView.tapDelegate = self;
  
  FGAboutusTitleView *view_tmpTitleView = [self getHomepageTitleView];
  [view_tmpTitleView updateLeftTitleHidden:NO withTitle:[NSString stringWithFormat:@"Title %ld",section] color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  view_tmpTitleView.tapDelegate = self;
  return view_tmpTitleView;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSDictionary *info    = self.arr_data[indexPath.section][indexPath.row];
  NSLog(@"info = %@,title = %@", info, info[@"title"]);
  cell = [self aboutusInfoViewCell:tableView withIndexPath:indexPath];
  
  
  
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
  

  
//  self.selectedIndexPath = indexPath;
//  NSDictionary *info  = self.arr_data[indexPath.section][indexPath.row];
//  NSString *str_title = info[@"title"];
//  if ([str_title isEqualToString:multiLanguage(@"Age")]){
//    [self selectedPickerWithAge:[info[@"content"] integerValue]];
//  } else if ([str_title isEqualToString:multiLanguage(@"Gender")]) {
//    [self selectedPickerWithGender:GenderToInteger(info[@"content"])];
//  } else if ([str_title isEqualToString:multiLanguage(@"Boxing Level")]) {
//    [self selectedPickerWithBoxingLevel:BoxingLevelToInteger(info[@"content"])];
//  } else if ([str_title isEqualToString:multiLanguage(@"Goal")]) {
//    [self selectedPickerWithGoal:GoalToInteger(info[@"content"])];
//  } else if ([str_title isEqualToString:multiLanguage(@"Profile Picture")]) {
//    [self actionSheetWithSelectedUserPic];
//  } else if ([str_title isEqualToString:multiLanguage(@"Notinality")]) {
//    [commond presentCitiesPickViewFromController:[self viewController]];
//  }
//  else if([str_title isEqualToString:multiLanguage(@"Phone Number")])
//  {
//    NSLog(@"info = %@",info);
//    NSString *str_mobileNumber = info[@"content"];
//    NSLog(@"str_mobileNumber = %@",str_mobileNumber);
//    if(str_mobileNumber && ![str_mobileNumber isEmptyStr])
//    {
//      FGControllerManager *manager = [FGControllerManager sharedManager];
//      FGBindPhoneNumberViewController *vc_bindPhoneNum = [[FGBindPhoneNumberViewController alloc] initWithNibName:@"FGBindPhoneNumberViewController" bundle:nil mobileNum:info[@"content"]];
//      [manager pushController:vc_bindPhoneNum navigationController:nav_current];
//    }
//    else{
//      FGControllerManager *manger = [FGControllerManager sharedManager];
//      FGBindPhoneNumberNewPhoneViewController *vc_bindPhoneNumNew = [[FGBindPhoneNumberNewPhoneViewController alloc] initWithNibName:@"FGBindPhoneNumberNewPhoneViewController" bundle:nil];
//      [manger pushController:vc_bindPhoneNumNew navigationController:nav_current];
//    }//没有填写过手机号码
//    
//  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)aboutusInfoViewCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"cellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  cell.textLabel.text = [NSString stringWithFormat:@"Row %ld",indexPath.row];

  return cell;
}

- (FGAboutusTitleView *)getHomepageTitleView {
  FGAboutusTitleView *titleView = (FGAboutusTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGAboutusTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView updateLeftTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  titleView.frame     = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  return titleView;
}

#pragma mark - tapSectionHeaderDelegate
-(void)action_sectionHeaderTappedAtIndex:(NSInteger)index
{
  BOOL currentIsOpen = ((NSNumber *)arr_data[index][@"status"]).boolValue;
  
  NSMutableDictionary *_mdic = arr_data[index];
  [_mdic setValue:[NSNumber numberWithBool:!currentIsOpen] forKey:@"status"];
  [arr_data replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
  NSLog(@"arr_data==%@", arr_data);
  
  //是否展开
  BOOL status = [arr_data[index][@"status"] boolValue];
  ;
//  NSNumber *num = status? @NO :@YES;
//  [arr_data replaceObjectAtIndex:indexPath.row withObject:num];
//  [self.tb_aboutus reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//  [self.tb_aboutus scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
  
//  NSInteger numberOfRow = [ yuFoldingTableView:self numberOfRowsInSection:index];
//  NSMutableArray *rowArray = [NSMutableArray array];
//  if (numberOfRow) {
//    for (NSInteger i = 0; i < numberOfRow; i++) {
//      [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
//    }
//  }
//  if (rowArray.count) {
//    if (currentIsOpen) {
//      [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
//    }else{
//      [self insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
//    }
//  }
}
@end
