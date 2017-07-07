//
//  FGControllerManager.h
//  Autotrader_Iphone
//
//  Created by rui.gong on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "FGWorkingLogViewController.h"
#import "FGNewsInfoViewController.h"
#import "FGHomeWorkoutsListViewController.h"
#import "FGHomepageFeaturedUserListViewController.h"
#import "FGManageBookingViewController.h"
#import "FGMyCalendarViewController.h"
//#import "FGBookingHistoryViewController.h"
#import "FGMyFollowerViewController.h"
#import "FGHomeViewController.h"
#import "FGLoadingViewController.h"
#import "FGLocationViewController.h"
#import "FGLoginViewController.h"
#import "FGPostViewController.h"
#import "FGProfileEditViewController.h"
#import "FGProfileViewController.h"
#import "FGTimerSettingViewController.h"
#import "FGTimerViewController.h"
#import "FGTrainingViewController.h"

#import "FGAddFriendViewController.h"
#import "FGChooseBoxingLevelViewController.h"
#import "FGFirstReccommendWorkoutViewController.h"
#import "FGFriendProfileViewController.h"
#import "FGLoadingViewController.h"
#import "FGLoginViewController.h"
#import "FGMyBadgesViewController.h"
#import "FGMyFriendsViewController.h"
#import "FGPostCommentDetailViewController.h"
#import "FGProfileFitnessLevelTestViewController.h"
#import "FGTrainerProfileViewController.h"
#import "FGPostCameraViewController.h"
#import "FGPostEditPhotoViewController.h"
#import "FGPostShareViewController.h"

#import "FGTrainingAllStepByStepViewController.h"
#import "FGCitiesPickupViewController.h"
#import "FGUserPickupViewController.h"

#import "FGLocationFindAGroupViewController.h"
#import "FGLocationMyGroupViewController.h"
#import "FGLocationFindAGYMDetailViewController.h"
#import "FGLocationFindAGYMViewController.h"
#import "FGLocationFindAGYMDetailViewController.h"
#import "FGLocationFindATrainerViewController.h"
#import "FGLocationSelectViewController.h"
#import "FGPopupViewController.h"
#import "FGProfileFavoriteViewController.h"
#import "FGProfileSavedWorkoutViewController.h"
#import "FGTopicViewController.h"
#import "FGSetAddressViewController.h"
#import "FGLocationFindAGroupDetailViewController.h"
#import "FGProfileSavedWorkoutDetailViewController.h"
#import "FGProfileFitnessLevelTestHomeViewController.h"
#import "FGTrainingSetPlanViewController.h"
#import "FGTrainingEditScheduleViewController.h"
#import "FGTrainingMyPlanViewController.h"
#import "FGTrainingRecoveryDayEditViewController.h"
#import "FGTrainingSetPlanSelectWorkoutHomeViewController.h"
#import "FGTrainingSetPlanWorkoutListViewController.h"
#import "FGProfileSetDefaultAddressViewController.h"
#import "FGLikesPickupViewController.h"
#import <Foundation/Foundation.h>

#import "FGLoginInputInvitationCodeViewController.h"
#import "FGLoginShareYourInvitationViewController.h"
#import "FGLoginInputNicknameViewController.h"

#import "FGSeeMoreForSearchResultViewController.h"
#import "FGProfileSettingsViewController.h"
#import "FGClearCacheViewController.h"
#import "FGAboutViewController.h"
#import "FGProfileSettingsViewController.h"
#import "FGBindPhoneNumberViewController.h"
#import "FGBindPhoneNumberNewPhoneViewController.h"
#import "FGLocationBookMultiClassPIckDateViewController.h"

extern UINavigationController *nav_home;
extern UINavigationController *nav_training;
extern UINavigationController *nav_post;
extern UINavigationController *nav_location;
extern UINavigationController *nav_profile;
extern UINavigationController *nav_current;

BOOL isSameClass(Class _class, Class _class2);
BOOL isSubClassByClassName(Class _class, NSString *_className);

typedef enum {
  NavigationStatus_Location = 0,
  NavigationStatus_Training = 1,
  NavigationStatus_Home     = 2,
  NavigationStatus_Post     = 3,
  NavigationStatus_Profile  = 4
} NavigationStatus;

@interface FGControllerManager : NSObject <UINavigationControllerDelegate> {
}
@property NavigationStatus currentNavigationStatus;

#pragma mark - 初始化NavigationController
- (void)initNavigation:(UINavigationController *__strong *)_nav rootControllerName:(NSString *)_rootControllerName;
- (void)initNavigation:(UINavigationController *__strong *)_nav rootController:(UIViewController *)_rootController;
#pragma mark - 向指定navigationController中push 一个 controller
- (void)pushControllerByName:(NSString *)_controllerName inNavigation:(UINavigationController *)_nav;
- (void)pushControllerByName:(NSString *)_controllerName inNavigation:(UINavigationController *)_nav withAnimtae:(BOOL)_animate;
- (void)pushController:(UIViewController *)_controller navigationController:(UINavigationController *)_navController;
#pragma mark - 从指定navigationController中pop
- (void)popAllViewControllerAndReleaseNavigation:(UINavigationController *__strong *)_nav;
- (void)popToRootViewControlerInNavigation:(UINavigationController *__strong *)_nav animated:(BOOL)_animated;
- (void)popToViewControllerInNavigation:(UINavigationController *__strong *)_nav controller:(UIViewController *)_controller animated:(BOOL)_animated;
- (void)popViewControllerInNavigation:(UINavigationController *__strong *)_nav animated:(BOOL)_animated;
#pragma mark - 获得一个navigationController中所有的viewController
- (NSArray *)getAllControllersByNaviion:(UINavigationController *)_nav;
#pragma mark - 获得指定navigationController中当前的viewController
- (UIViewController *)getCurrentViewControllerInNav:(UINavigationController *)_nav;
#pragma mark - 销毁
- (void)purgeManager;
#pragma mark - 获得单例
+ (FGControllerManager *)sharedManager;
@end
