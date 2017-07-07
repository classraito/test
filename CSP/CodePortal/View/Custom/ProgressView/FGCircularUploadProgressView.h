//
//  FGCircularUploadProgressView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CircularUploadButtonStatus_NotUploading = 0,
    CircularUploadButtonStatus_Uploading = 1,
    CircularUploadButtonStatus_ShowText = 2
}CircularUploadButtonStatus;

@interface FGCircularUploadProgressView : UIView
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_uploading;
@property(nonatomic,weak)IBOutlet UIView *view_mask;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property CGFloat processPercent;
@property CircularUploadButtonStatus status;
-(void)setStatusToNotLoading;
-(void)setStatusToUpLoading;
-(void)setStatusToShowText;
@end
