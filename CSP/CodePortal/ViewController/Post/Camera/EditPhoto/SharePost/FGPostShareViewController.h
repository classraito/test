//
//  FGPostShareViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGPostShareView.h"

#import "NetworkManager_UploadFile.h"
@interface FGPostShareViewController : FGBaseViewController<NetworkManagerUploadFileDelegate,ASIHTTPRequestDelegate>
{
    
}
@property(nonatomic,strong)FGPostShareView *view_postShare;
@property(nonatomic,strong)NSString *str_videoFilePath;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)_img videoFilePath:(NSString *)_str_videoFilePath;
-(void)addImage:(UIImage *)_img orVideoFilePath:(NSString *)_str_videoFilePath;
@end
