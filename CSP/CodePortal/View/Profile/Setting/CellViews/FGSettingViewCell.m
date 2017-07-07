//
//  FGSettingViewCell.m
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGSettingViewCell.h"

@implementation FGSettingViewCell
@synthesize lb_title;
@synthesize lb_content;
@synthesize btn_switch;
@synthesize delegate;
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  //  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator];
  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:lb_content];
  [commond useDefaultRatioToScaleView:btn_switch];
  
  self.lb_title.textColor = color_homepage_lightGray;
  self.lb_title.font = font(FONT_TEXT_REGULAR, 15);
  
  self.lb_content.textColor = color_homepage_lightGray;
  self.lb_content.font = font(FONT_TEXT_REGULAR, 15);
  
  self.lb_content.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSInteger _int_type = [_dataInfo[@"type"] integerValue];
  float _flt_value = 0;
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.btn_switch.hidden = YES;
  self.lb_title.text = _dataInfo[@"title"];
  if (_int_type == CellType_normal) {
  }
  else if (_int_type == CellType_titleWithArrow) {
    _flt_value = [_dataInfo[@"value"] floatValue];
    self.lb_content.hidden = NO;
    self.lb_content.text = [NSString stringWithFormat:@"%.1fM", _flt_value];
  }
  else if (_int_type == CellType_optionButton) {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btn_switch.hidden = NO;
    [self.btn_switch addTarget:self action:@selector(action_swtichStatus:) forControlEvents:UIControlEventValueChanged];
  }
}

- (void)action_swtichStatus:(id)sender {
  BOOL _bool_isOn = [self.btn_switch isOn];
  [self.delegate action_swtichToStatus:_bool_isOn];
}

@end
