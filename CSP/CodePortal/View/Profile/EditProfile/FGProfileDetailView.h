//
//  FGProfileDetailView.h
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *NOTIFICATION_SELECTCITY = @"NOTIFICATION_SELECTCITY";

#define NOTIFICATION_UpdateUserMobile @"NOTIFICATION_UpdateUserMobile"

typedef NS_ENUM(NSInteger, PickerType) {
  PickerType_Age         = 1,
  PickerType_Gender      = 2,
  PickerType_BoxingLevel = 3,
  PickerType_Goal        = 4
};
@protocol FGProfileDetailViewDelegate <NSObject>

- (void)action_uploadUserIconWithImage:(UIImage *)img;

@end

@interface FGProfileDetailView : UIView <UITableViewDelegate, UITableViewDataSource ,  UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, assign) id<FGProfileDetailViewDelegate> delegate;
@property (nonatomic, copy) NSString *str_id;
@property (weak, nonatomic) IBOutlet UITableView *tb_userInfo;
@property (strong, nonatomic) UIImagePickerController *imgPicker_userPic;
- (void)bindDataToUI;
- (void)runRequest_getUserProfile;
-(void)updateLocationAddress:(NSString *)_str_address;
- (NSMutableArray *)profileDetailInfo;
- (BOOL)hasUpdatePersonInfo;
- (BOOL)isValiadteUserName;
@end
