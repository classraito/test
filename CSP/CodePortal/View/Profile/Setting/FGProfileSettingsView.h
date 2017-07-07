//
//  FGProfileSettingsView.h
//  CSP
//
//  Created by JasonLu on 17/1/18.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FGProfileSettingsView : UIView <UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb_settings;
@property (nonatomic, strong, readonly) NSMutableArray *arr_data;
- (void)reload;
@end
