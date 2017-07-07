//
//  AppDelegate.h
//  CSP
//
//  Created by Ryan Gong on 16/8/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//  CSP-Boxing....

#import <UIKit/UIKit.h>
#import "WXApiWrapper.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,copy) NSString *deviceToken;
-(void)logout;
-(BOOL)isLoggedIn;
-(void)setAsGuest;
@end

