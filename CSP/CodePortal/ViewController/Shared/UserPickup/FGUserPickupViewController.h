//
//  FGUserPickupViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseViewController.h"
typedef enum{
    ListType_User = 0,
    ListType_Topic = 1,
    ListType_Contacts = 2,
  ListType_WeChatContacts = 3
}ListType;

@interface FGUserPickupViewController : FGBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,weak)IBOutlet UITextField *tf_search;
@property ListType listType;
-(void)setupByListType:(ListType)_listType;
@end
