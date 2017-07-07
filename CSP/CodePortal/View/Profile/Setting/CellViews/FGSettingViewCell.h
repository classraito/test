//
//  FGSettingViewCell.h
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger {
  CellType_normal,
  CellType_titleWithArrow,
  CellType_optionButton,
} CellType;

@protocol FGSettingViewCellDelegate <NSObject>

- (void)action_swtichToStatus:(BOOL)_bool_newStatus;

@end



@interface FGSettingViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UISwitch *btn_switch;

@property (assign, nonatomic) id<FGSettingViewCellDelegate> delegate;

@end
