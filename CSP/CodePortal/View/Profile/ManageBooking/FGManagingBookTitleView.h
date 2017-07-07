//
//  FGManagingBookTitleView.h
//  CSP
//
//  Created by JasonLu on 16/11/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  SECTION_PENDING,
  SECTION_ACCEPTED,
  SECTION_HISTORY,
} enum_section;

@protocol FGManagingBookTitleViewDelegate <NSObject>

- (void)action_handleSection:(enum_section)section;

@end


@interface FGManagingBookTitleView : UIView
@property (assign, nonatomic) id<FGManagingBookTitleViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_pending;
@property (weak, nonatomic) IBOutlet UIButton *btn_accepted;
@property (weak, nonatomic) IBOutlet UIButton *btn_history;

@property (weak, nonatomic) IBOutlet UIView *view_leftSeparator_horizontal;
@property (weak, nonatomic) IBOutlet UIView *view_righSeparator_horizontal;
@property (weak, nonatomic) IBOutlet UIView *view_separator;

- (void)setupSectionStatus:(enum_section)section;
- (void)setupSectionFirstButtonTitle:(NSString *)firstTitle secondButtonTitle:(NSString *)secondTitle thirdButtonTitle:(NSString *)thirdTitle;
@end
