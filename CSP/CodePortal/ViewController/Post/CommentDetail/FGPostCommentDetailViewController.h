//
//  FGPostCommentDetailViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGPostCommentDetailView.h"
@interface FGPostCommentDetailViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGPostCommentDetailView *view_comment;
@property(nonatomic,copy)NSMutableDictionary *dic_postInfo;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil postInfo:(NSMutableDictionary *)_dic_postInfo;
@end
