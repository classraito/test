//
//  FGManagingBookTitleView.m
//  CSP
//
//  Created by JasonLu on 16/11/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManagingBookTitleView.h"

@implementation FGManagingBookTitleView
@synthesize view_leftSeparator_horizontal;
@synthesize view_righSeparator_horizontal;
@synthesize view_separator;
@synthesize btn_pending;
@synthesize btn_accepted;
@synthesize btn_history;
@synthesize delegate;
#pragma mark - 生命周期
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
     [self internalInitalView];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalView];
}

- (void)internalInitalView {
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_leftSeparator_horizontal];
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_righSeparator_horizontal];
  //  [commond useRatio:CGRectMake(ratioW, ratioH, 1, ratioH) toScaleView:view_separator];
  
  [commond useDefaultRatioToScaleView:view_separator];
  [commond useDefaultRatioToScaleView:self.btn_pending];
  [commond useDefaultRatioToScaleView:self.btn_accepted];
  [commond useDefaultRatioToScaleView:self.btn_history];
  
  [btn_pending setTitle:multiLanguage(@"PENDING") forState:UIControlStateNormal];
  [btn_pending setTitle:multiLanguage(@"PENDING") forState:UIControlStateHighlighted];
  
  [btn_accepted setTitle:multiLanguage(@"ACCEPTED") forState:UIControlStateNormal];
  [btn_accepted setTitle:multiLanguage(@"ACCEPTED") forState:UIControlStateHighlighted];
  
  [btn_history setTitle:multiLanguage(@"HISTORY") forState:UIControlStateNormal];
  [btn_history setTitle:multiLanguage(@"HISTORY") forState:UIControlStateHighlighted];
  
  btn_pending.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
  btn_accepted.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
  btn_history.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
}

- (void)setupSectionFirstButtonTitle:(NSString *)firstTitle secondButtonTitle:(NSString *)secondTitle thirdButtonTitle:(NSString *)thirdTitle {
  [btn_pending setTitle:firstTitle forState:UIControlStateNormal];
  [btn_pending setTitle:firstTitle forState:UIControlStateHighlighted];
  
  [btn_accepted setTitle:secondTitle forState:UIControlStateNormal];
  [btn_accepted setTitle:secondTitle forState:UIControlStateHighlighted];
  
  [btn_history setTitle:thirdTitle forState:UIControlStateNormal];
  [btn_history setTitle:thirdTitle forState:UIControlStateHighlighted];
}

-(void)setPendingHighlighted {
  [btn_pending setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn_pending setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [btn_accepted setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_accepted setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

-(void)setAcceptedHighlighted {
  [btn_pending setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_pending setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [btn_accepted setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn_accepted setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

-(void)setHistoryHighlighted {
  [btn_pending setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_pending setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [btn_accepted setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [btn_accepted setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [btn_history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btn_history setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)internalInitalTitleProfileHomeView{
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)setupSectionStatus:(enum_section)section {
  if (section == SECTION_PENDING) {
    [self setPendingHighlighted];
  } else if (section == SECTION_ACCEPTED) {
    [self setAcceptedHighlighted];
  } else if (section == SECTION_HISTORY) {
    [self setHistoryHighlighted];
  }
}

- (IBAction)buttonAction_pending:(id)sender {
  [self setupSectionStatus:SECTION_PENDING];
  [self.delegate action_handleSection:SECTION_PENDING];
}

- (IBAction)buttonAction_accepted:(id)sender {
  [self setupSectionStatus:SECTION_ACCEPTED];
  [self.delegate action_handleSection:SECTION_ACCEPTED];
}

- (IBAction)buttonAction_history:(id)sender {
  [self setupSectionStatus:SECTION_HISTORY];
  [self.delegate action_handleSection:SECTION_HISTORY];
}
@end
