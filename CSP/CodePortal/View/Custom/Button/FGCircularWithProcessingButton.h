//
//  FGCircularWithProcessingButton.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"
typedef enum
{
    ProcessingButtonStatus_NotDownload = 0,
    ProcessingButtonStatus_Downloading = 1,
    ProcessingButtonStatus_ReadyToPlay = 2
}ProcessingButtonStatus;

@interface FGCircularWithProcessingButton : FGCustomizableBaseView
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_download;
@property(nonatomic,weak)IBOutlet UIImageView *iv_play;
@property(nonatomic,weak)IBOutlet UIButton *btn_download_play;
@property CGFloat processPercent;
@property ProcessingButtonStatus status;

-(void)setStatusToReadyToPlay;

-(void)setStatusToNotDownload;

-(void)setStatusToDownloading;
@end
