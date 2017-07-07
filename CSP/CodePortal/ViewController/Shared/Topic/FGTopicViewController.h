//
//  FGTopicViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTopicView.h"
@interface FGTopicViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGTopicView *view_topic;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil topicId:(NSString *)_str_topicId topicName:(NSString *)_str_topicName;
@end
