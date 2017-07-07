//
//  FGLoginViewController.h
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGLoginViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)NSString *str_myInvitationCode;//我自己的邀请码
- (void)buttonAction_loginUseQQ:(id)sender ;
- (void)buttonAction_loginUseWeibo:(id)sender;
- (void)buttonAction_loginUseWechat:(id)sender;
- (void)buttonAction_loginUseFB:(id)sender;
- (void)go2HomeViewController;
@end
