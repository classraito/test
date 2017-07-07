//
//  FGPostCommentMorePopupView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCustomButton.h"
@interface FGPostCommentMorePopupView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_repoert;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_cancel;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_deletePost;
@end
