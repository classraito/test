//
//  FGFriendProfileViewController.h
//  CSP
//
//  Created by JasonLu on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGFriendProfileViewController : FGBaseViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFriendId:(id)_str_friendId;
- (void)setupFriendProfileAction;
@end
