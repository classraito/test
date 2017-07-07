//
//  FGCalendarDetailInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCalendarDetailInfoCellView.h"

@implementation FGCalendarDetailInfoCellView
@synthesize lb_left;
@synthesize lb_right;
@synthesize btn_right;
@synthesize btn_cellInfo;
@synthesize iv_status;
@synthesize view_sepeator;
@synthesize delegate;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  //  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator];
  [commond useDefaultRatioToScaleView:lb_left];
  [commond useDefaultRatioToScaleView:lb_right];
  [commond useDefaultRatioToScaleView:btn_right];
  [commond useDefaultRatioToScaleView:iv_status];
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 0.5) toScaleView:view_sepeator];
  [commond useDefaultRatioToScaleView:self.btn_cellInfo];
  
  self.btn_cellInfo.hidden = YES;

  self.lb_left.font = font(FONT_TEXT_REGULAR, 12);
  self.btn_right.titleLabel.font = font(FONT_TEXT_REGULAR, 12);
  self.backgroundColor = color_calendar_lightGray;
  
  [self.btn_right addTarget:self action:@selector(buttonAction_rightClick:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.btn_cellInfo addTarget:self action:@selector(buttonAction_clickCell:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

//- (void)updateCellViewWithInfo:(id)_dataInfo {
////  NSInteger _int_status = [_dataInfo[@"status"] integerValue];
//  NSString *str_time = _dataInfo[@"time"];
//  NSString *str_session = _dataInfo[@"session"];
//  BOOL _bool_isPastTime = [_dataInfo[@"isPastTime"] boolValue];
//  
//  if (_bool_isPastTime) {
//    self.btn_right.hidden = YES;
//    self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
//    self.backgroundColor = color_calendar_lightGray;
//    [self.lb_left setTextColor:color_calendar_darkLightGray];
//    self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
//
//    return;
//  }
//  
//  if ([str_session isEqualToString:@""]){
//    self.btn_right.hidden = YES;
//    self.lb_left.text = str_time;
//    
//    [self.lb_left setTextColor:[UIColor blackColor]];
//    self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
//    self.backgroundColor = color_calendar_lightGray;
//  } else {
//    self.backgroundColor = color_calendar_darkLightGray;
//    self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
//    self.btn_right.hidden = NO;
//    self.view_sepeator.backgroundColor = color_calendar_lightGray;
//    [self.lb_left setTextColor:[UIColor whiteColor]];
//
//    [self.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
//    [self.btn_right setTitle:multiLanguage(@"DETAILS") forState:UIControlStateNormal];
//    
//  }
//}

- (void)updateCellViewWithInfo:(id)_dataInfo isEditing:(BOOL)editing hiddenSepeator:(BOOL)hiddenSepeator{
  NSLog(@"_dataInfo==%@",_dataInfo);
  NSInteger _int_status = [_dataInfo[@"status"] integerValue];
  NSString *str_session = _dataInfo[@"session"];
  NSString *str_time = _dataInfo[@"time"];
  BOOL _bool_isPastTime = [_dataInfo[@"isPastTime"] boolValue];

  self.btn_cellInfo.hidden = YES;
  self.btn_right.hidden = NO;
  if (editing) {
    //编辑状态
    [self.btn_right setTitle:@"" forState:UIControlStateNormal];
    self.iv_status.hidden = NO;
    self.btn_right.hidden = NO;
    
    self.lb_left.text = str_time;
    self.lb_left.textColor = [UIColor blackColor];
    
      if (_int_status == 0) {
        self.iv_status.image = IMGWITHNAME(@"available");
        self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
        
        self.backgroundColor = color_calendar_lightGray;
      } else if (_int_status == 1) {
        self.iv_status.image = IMGWITHNAME(@"nonavailable");
        self.view_sepeator.backgroundColor = [UIColor whiteColor];
        self.lb_left.textColor = [UIColor whiteColor];
        self.backgroundColor = color_calendar_darkGray;
      } else if (_int_status == 2) {
        //不能关闭，已有课程
        self.iv_status.hidden = YES;
        self.btn_right.hidden = YES;

        self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
        self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
        self.lb_left.textColor = [UIColor whiteColor];
        
        self.backgroundColor = color_calendar_darkLightGray;
      }
  }
  else {
    self.iv_status.hidden = YES;
    self.btn_right.hidden = YES;
    
    self.lb_left.text = str_time;
    self.lb_left.textColor = [UIColor blackColor];
    
    if (_int_status == 0) {
      self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
      self.backgroundColor = color_calendar_lightGray;
      self.btn_cellInfo.hidden = NO;
    } else if (_int_status == 1) {
      self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
      self.backgroundColor = color_calendar_lightGray;
      [self.lb_left setTextColor:color_calendar_darkLightGray];
    } else if (_int_status == 2) {
      if ([commond isUser]) {
        self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
        self.backgroundColor = color_calendar_lightGray;
        [self.lb_left setTextColor:color_calendar_darkLightGray];
        self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
      } else {
        self.backgroundColor = color_calendar_darkLightGray;
        self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
        self.lb_left.textColor = [UIColor whiteColor];
        
        self.btn_right.hidden = NO;
        [self.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
        [self.btn_right setTitle:multiLanguage(@"DETAILS") forState:UIControlStateNormal];
        self.view_sepeator.backgroundColor = color_calendar_lightGray;
      }
    }
  }
  self.view_sepeator.hidden = hiddenSepeator;
  
  //时间过了就不能编辑了
  if (_bool_isPastTime) {
    self.btn_right.hidden = YES;
    self.iv_status.hidden  = YES;
    
    self.view_sepeator.backgroundColor = color_calendar_darkLightGray;
    self.backgroundColor = color_calendar_lightGray;
    [self.lb_left setTextColor:color_calendar_timePassed];
    self.lb_left.text = [NSString stringWithFormat:@"%@  %@", str_time, str_session];
    
    if ([commond isUser]== NO && _int_status == 2) {
      self.btn_right.hidden = NO;
      [self.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
      [self.btn_right setTitle:multiLanguage(@"DETAILS") forState:UIControlStateNormal];
      self.view_sepeator.backgroundColor = color_calendar_lightGray;
    }
  }
  
}

- (void)setupCannotEditCloseStatus {
  self.iv_status.image = IMGWITHNAME(@"nonavailable");
}

- (void)setupCanEditCloseStatus {
  self.iv_status.image = IMGWITHNAME(@"nonavailable");
}

- (void)setupCanEditOpenStatus {
  self.iv_status.image = IMGWITHNAME(@"available");
}

- (void)setupViewStatus {
  
}

#pragma mark - 按钮点击事件，通过代理模式响应
-(void)buttonAction_rightClick:(UIButton *)btn
{
  [self.delegate didClickButton:btn];
}

- (void)buttonAction_clickCell:(UIButton *)btn {
  [self.delegate didClickCell:btn];
}

@end
