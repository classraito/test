//
//  FGCustomAlertView.h
//  Pureit
//
//  Created by Ryan Gong on 16/3/25.
//  Copyright © 2016年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomButton.h"
@interface FGCustomAlertView : UIView
{
    
}
@property(nonatomic,assign) NSInteger int_dismissButtonIndex;
@property(nonatomic,assign)IBOutlet UIView *view_alertBox;
@property(nonatomic,assign)IBOutlet UILabel *lb_title;
@property(nonatomic,assign)IBOutlet UILabel *lb_message;
@property(nonatomic,assign)IBOutlet FGCustomButton *cb1;
@property(nonatomic,assign)IBOutlet FGCustomButton *cb2;
@property(nonatomic,assign)IBOutlet FGCustomButton *cb3;
@property(nonatomic,assign)IBOutlet UIView *view_bg;
-(void)setupWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock;
-(void)show;
@end
