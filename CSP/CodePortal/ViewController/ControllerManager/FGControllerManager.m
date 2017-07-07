//
//  FGControllerManager.m
//  Autotrader_Iphone
//
//  Created by rui.gong on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FGControllerManager.h"
#import "Global.h"

static FGControllerManager *manager;
UINavigationController *nav_home;
UINavigationController *nav_training;
UINavigationController *nav_post;
UINavigationController *nav_location;
UINavigationController *nav_profile;
UINavigationController *nav_current;

BOOL isSameClass(Class _class, Class _class2) {
  if ([NSStringFromClass(_class) isEqualToString:NSStringFromClass(_class2)]) {
    return YES;
  } else
    return NO;
}

BOOL isSubClassByClassName(Class _class, NSString *_className) {
  if ([_class isSubclassOfClass:NSClassFromString(_className)]) {
    return YES;
  } else
    return NO;
}

extern id instanceXibClass(NSString *_str) {
  id ret = [[NSClassFromString(_str) alloc] initWithNibName:_str bundle:nil];
  return ret;
}

@implementation FGControllerManager
@synthesize currentNavigationStatus;
#pragma mark - 生命周期
+ (FGControllerManager *)sharedManager {
  @synchronized(self) {
    if (!manager) {
      manager = [[FGControllerManager alloc] init];
      NSLog(@"init FGControllerManager");
      return manager;
    }
  }
  return manager;
}

+ (id)alloc {
  @synchronized(self) {
    NSAssert(manager == nil, @"企圖創建一個singleton模式下的FGControllerManager");
    return [super alloc];
  }
  return nil;
}

- (void)purgeManager {
  manager = nil;
}

- (void)dealloc {
  NSLog(@":::::>dealloc FGControllerManager");
}

#pragma mark - 初始化NavigationController
- (void)initNavigation:(UINavigationController *__strong *)_navController rootControllerName:(NSString *)_rootControllerName {
  if (!(*_navController)) {
    NSLog(@":::::>-(void)addNavigationByControllerByRootName:(NSString *)=%@", _rootControllerName);
    UIViewController *_viewController     = [self initializeViewControllerByName:_rootControllerName];
    *_navController                       = [[UINavigationController alloc] initWithRootViewController:_viewController];
    (*_navController).delegate            = self;
    (*_navController).navigationBarHidden = YES;
    //[appDelegate.window addSubview:(*_navController).view];
  } else {
    //[appDelegate.window bringSubviewToFront:(*_navController).view];
  }
    
    nav_current = *_navController;
    nav_current.automaticallyAdjustsScrollViewInsets = NO;
  appDelegate.window.rootViewController = *_navController;
  NSLog(@"(*_navController).view] = %@", (*_navController).view);
  NSLog(@"window subviews=%@", [appDelegate.window subviews]);
}

- (void)initNavigation:(UINavigationController *__strong *)_navController rootController:(UIViewController *)_rootController {
  NSLog(@":::::>-(void)initNavigationByControllerRootController:(NSString *)=%@", _rootController);
  NSLog(@"_rootController=%@", _rootController);
  if (!(*_navController)) {
    *_navController                       = [[UINavigationController alloc] initWithRootViewController:_rootController];
    (*_navController).delegate            = self;
    (*_navController).navigationBarHidden = YES;
    //        [appDelegate.window addSubview:(*_navController).view];
  } else {
    //        [appDelegate.window bringSubviewToFront:(*_navController).view];
  }

  nav_current = *_navController;
  nav_current.automaticallyAdjustsScrollViewInsets = NO;
  appDelegate.window.rootViewController = *_navController;
  NSLog(@"(*_navController).view] = %@", (*_navController).view);
  NSLog(@"window subviews=%@", [appDelegate.window subviews]);
}

#pragma mark - 向指定navigationController中push 一个 controller
- (void)pushControllerByName:(NSString *)_controllerName inNavigation:(UINavigationController *)_nav {
  [self pushControllerByName:_controllerName navigationController:_nav withAnimation:YES];
}

- (void)pushControllerByName:(NSString *)_controllerName inNavigation:(UINavigationController *)_nav withAnimtae:(BOOL)_animate {
  [self pushControllerByName:_controllerName navigationController:_nav withAnimation:_animate];
}

- (void)pushController:(UIViewController *)_controller navigationController:(UINavigationController *)_navController {
  assert(_navController);

 /* for (id viewController in _navController.viewControllers) {
    if ([viewController isKindOfClass:[_controller class]]) {
      NSLog(@"已经在navigationController中存在相同的类了");
      return;
    }
  }*/


  [_navController pushViewController:_controller animated:YES];
}

- (void)pushControllerByName:(NSString *)_controllerName navigationController:(UINavigationController *)_navController withAnimation:(BOOL)_animation {
  NSLog(@":::::>-(void)pushControllerByName:(NSString *)=%@ navigationController:(UINavigationController *)=%@", _controllerName, _navController);
  assert(_controllerName);
  assert(_navController);
 /* for (id viewController in _navController.viewControllers) {
    if ([viewController isKindOfClass:NSClassFromString(_controllerName)]) {
      NSLog(@"已经在navigationController中存在相同的类了");
      return;
    }
  }*/
  UIViewController *_viewController = [self initializeViewControllerByName:_controllerName];
  [_navController pushViewController:_viewController animated:_animation];
}

#pragma mark - 从指定navigationController中pop
- (void)popAllViewControllerAndReleaseNavigation:(UINavigationController *__strong *)_nav {
  NSLog(@"popAllViewControllerByNavigation:%@", *_nav);
  if (*_nav != nil) {
    NSArray *arr_poped = [(*_nav) popToRootViewControllerAnimated:NO];
    for (UIViewController *vc __strong in arr_poped) {
      vc = nil;
    }
    (*_nav) = nil;
  }
}

- (void)popToRootViewControlerInNavigation:(UINavigationController *__strong *)_nav animated:(BOOL)_animated {
  if ((*_nav)) {
    NSArray *arr_poped = [(*_nav) popToRootViewControllerAnimated:_animated];
    for (UIViewController *vc __strong in arr_poped) {
      vc = nil;
    }
  }
}

- (void)popToViewControllerInNavigation:(UINavigationController *__strong *)_nav controller:(UIViewController *)_controller animated:(BOOL)_animated {
  NSLog(@":::::>-(void)popToViewControllerInNavigationByName");
  if ((*_nav)) {
    if ([(*_nav).viewControllers count] == 1) {
      NSLog(@"just have one controller in UINavigationController back to home");
      //(* _nav)=nil;
    } else {
      NSArray *arr_poped = [(*_nav) popToViewController:_controller animated:_animated];
      for (UIViewController *vc __strong in arr_poped) {
        vc = nil;
      }
    }
  }
}

- (void)popViewControllerInNavigation:(UINavigationController *__strong *)_nav animated:(BOOL)_animated {
  NSLog(@":::::>-(void)popViewControllerInNavigation");
  assert((*_nav));
  if ([(*_nav).viewControllers count] == 1) {
    NSLog(@"just have one controller in UINavigationController back to home");
  } else {
    UIViewController *vc = [(*_nav) popViewControllerAnimated:_animated];
    vc                   = nil;
  }
}
#pragma mark - 在这里初始化viewcontroller
- (UIViewController *)initializeViewControllerByName:(NSString *)_controllerName create:(BOOL)_isCreate {
  NSLog(@":::::>-(UIViewController *)initializeViewControllerByName:(NSString *)=%@", _controllerName);

  if (isSubClassByClassName([FGLoadingViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGChooseBoxingLevelViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGFirstReccommendWorkoutViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGLoginViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGTimerViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGTimerSettingViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGHomeViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGHomepageFeaturedUserListViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGHomeWorkoutsListViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGNewsInfoViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGSeeMoreForSearchResultViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGTrainingViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGPostViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGLocationViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGProfileViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGMyFriendsViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGMyFollowerViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGFriendProfileViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGMyCalendarViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGTrainerProfileViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  

  if (isSubClassByClassName([FGAddFriendViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGProfileFitnessLevelTestViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGProfileEditViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGManageBookingViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGWorkingLogViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
//  if (isSubClassByClassName([FGBookingHistoryViewController class], _controllerName)) {
//    if (_isCreate)
//      return instanceXibClass(_controllerName);
//  }
  
  
  
  if (isSubClassByClassName([FGMyBadgesViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

  if (isSubClassByClassName([FGPostCommentDetailViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }

    if (isSubClassByClassName([FGPostCameraViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGPostEditPhotoViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGPostShareViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGTrainingAllStepByStepViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGLocationFindAGroupViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationMyGroupViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationFindAGYMDetailViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationFindAGYMViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationFindAGYMDetailViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationFindATrainerViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationSelectViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGPopupViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGProfileSavedWorkoutViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGProfileFavoriteViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGTopicViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGSetAddressViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLocationFindAGroupDetailViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGProfileSavedWorkoutDetailViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGProfileFitnessLevelTestHomeViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGTrainingSetPlanViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGTrainingEditScheduleViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGTrainingMyPlanViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGTrainingRecoveryDayEditViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGTrainingSetPlanSelectWorkoutHomeViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGTrainingSetPlanWorkoutListViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGProfileSetDefaultAddressViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLoginInputInvitationCodeViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLoginInputNicknameViewController class], _controllerName)) {
      if (_isCreate)
        return instanceXibClass(_controllerName);
    }
    if (isSubClassByClassName([FGLoginShareYourInvitationViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGProfileSettingsViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
  
  if (isSubClassByClassName([FGClearCacheViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
  if (isSubClassByClassName([FGAboutViewController class], _controllerName)) {
    if (_isCreate)
      return instanceXibClass(_controllerName);
  }
  
    if (isSubClassByClassName([FGBindPhoneNumberViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGBindPhoneNumberNewPhoneViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
    if (isSubClassByClassName([FGLocationBookMultiClassPIckDateViewController class], _controllerName)) {
        if (_isCreate)
            return instanceXibClass(_controllerName);
    }
    
  return nil;
}

- (UIViewController *)initializeViewControllerByName:(NSString *)_controllerName {
  return [self initializeViewControllerByName:_controllerName create:YES];
}

#pragma mark - 获得一个navigationController中所有的viewController
- (NSArray *)getAllControllersByNaviion:(UINavigationController *)_nav {
  assert(_nav);
  return [_nav viewControllers];
}

#pragma mark - 获得指定navigationController中当前的viewController
- (UIViewController *)getCurrentViewControllerInNav:(UINavigationController *)_nav {
  if (!_nav)
    return nil;

  return _nav.topViewController;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  NSLog(@"navigationController=%@  viewController=%@", navigationController, viewController);
}
@end
