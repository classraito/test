//
//  FGContactsViewController.h
//  CSP
//
//  Created by JasonLu on 16/11/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGContactsViewControllerDelegate <NSObject>
@optional
-(void)didClickContactWithPhones:(NSArray *)_arr_phones;
@end


@interface FGContactsViewController : FGUserPickupViewController
@property (nonatomic, assign) id<FGContactsViewControllerDelegate>delegate;

@end
