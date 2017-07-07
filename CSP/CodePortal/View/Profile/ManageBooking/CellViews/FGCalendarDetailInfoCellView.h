//
//  FGCalendarDetailInfoCellView.h
//  CSP
//
//  Created by JasonLu on 16/11/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGCalendarDetailInfoCellViewDelegate <NSObject>
@optional
-(void)didClickButton:(UIButton *)button;
-(void)didClickCell:(UIButton *)button;
@end

@interface FGCalendarDetailInfoCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_cellInfo;
@property (weak, nonatomic) IBOutlet UILabel *lb_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_right;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) IBOutlet UIView *view_sepeator;
@property (weak, nonatomic) IBOutlet UIImageView *iv_status;
@property(nonatomic, assign) id<FGCalendarDetailInfoCellViewDelegate> delegate;

- (void)updateCellViewWithInfo:(id)_dataInfo isEditing:(BOOL)editing hiddenSepeator:(BOOL)hiddenSepeator;
@end
