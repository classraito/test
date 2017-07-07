//
//  FGPostShareView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomButton.h"
#import "FGUserInputPageBaseView.h"
#import "FGVideoModel.h"
#import "FGCircularUploadProgressView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>
@interface FGPostShareView : FGUserInputPageBaseView<UITextViewDelegate,FGVideoModelPlayQueueVideoDelegate,MAMapViewDelegate,AMapSearchDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UITextView *tv_post;
@property(nonatomic,weak)IBOutlet UILabel *lb_placeHolderText;

@property(nonatomic,weak)IBOutlet UIImageView *iv_imgPlaceHolder1;
@property(nonatomic,weak)IBOutlet UIImageView *iv_imgPlaceHolder2;
@property(nonatomic,weak)IBOutlet UIImageView *iv_imgPlaceHolder3;
@property(nonatomic,weak)IBOutlet UIButton *btn_placeHolder1;
@property(nonatomic,weak)IBOutlet UIButton *btn_placeHolder2;
@property(nonatomic,weak)IBOutlet UIButton *btn_placeHolder3;

@property(nonatomic,weak)IBOutlet UIImageView *iv_close1;
@property(nonatomic,weak)IBOutlet UIImageView *iv_close2;
@property(nonatomic,weak)IBOutlet UIImageView *iv_close3;
@property(nonatomic,weak)IBOutlet UIButton *btn_close1;
@property(nonatomic,weak)IBOutlet UIButton *btn_close2;
@property(nonatomic,weak)IBOutlet UIButton *btn_close3;

@property(nonatomic,weak)IBOutlet UIButton *btn_topic;

@property(nonatomic,weak)IBOutlet UIImageView *iv_atSomeone;
@property(nonatomic,weak)IBOutlet UIImageView *iv_place;

@property(nonatomic,weak)IBOutlet UIButton *btn_atSomeone;
@property(nonatomic,weak)IBOutlet UIButton *btn_place;

@property(nonatomic,weak)IBOutlet UILabel *lb_title_share;
@property(nonatomic,weak)IBOutlet UILabel *lb_facebook;
@property(nonatomic,weak)IBOutlet UILabel *lb_wechat;
@property(nonatomic,weak)IBOutlet UILabel *lb_weibo;
@property(nonatomic,weak)IBOutlet UILabel *lb_qzone;
@property(nonatomic,weak)IBOutlet UILabel *lb_moment;
@property (weak, nonatomic) IBOutlet UILabel *lb_instagram;

@property(nonatomic,weak)IBOutlet UIImageView *iv_facebook;
@property(nonatomic,weak)IBOutlet UIImageView *iv_wechat;
@property(nonatomic,weak)IBOutlet UIImageView *iv_weibo;
@property(nonatomic,weak)IBOutlet UIImageView *iv_qzone;
@property(nonatomic,weak)IBOutlet UIImageView *iv_moment;
@property (weak, nonatomic) IBOutlet UIImageView *iv_instagram;

@property(nonatomic,weak)IBOutlet UIButton *btn_facebook;
@property(nonatomic,weak)IBOutlet UIButton *btn_wechat;
@property(nonatomic,weak)IBOutlet UIButton *btn_weibo;
@property(nonatomic,weak)IBOutlet UIButton *btn_qzone;
@property(nonatomic,weak)IBOutlet UIButton *btn_moment;
@property (weak, nonatomic) IBOutlet UIButton *btn_instagram;

@property(nonatomic,weak)IBOutlet UILabel *lb_address;


@property (weak, nonatomic) IBOutlet UIImageView *iv_share;
@property (weak, nonatomic) IBOutlet UIButton *btn_share;


@property(nonatomic,weak)IBOutlet UIView *view_videoContainer;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property(nonatomic,weak)IBOutlet UIImageView *iv_hashTag;
@property(nonatomic,weak)IBOutlet UIButton *btn_hashTag;

@property(nonatomic,strong)NSString *str_videoFilePath;
@property long lat;
@property long lng;
@property(nonatomic,strong)NSString *str_addres;

-(IBAction)buttonAction_topic:(id)_sender;
-(IBAction)buttonAction_at:(id)_sender;
-(IBAction)buttonAction_place:(id)_sender;


-(void)clearMemory;

-(void)bindDataToUI:(NSMutableArray *)_arr_imgs videoFilePath:(NSString *)_str_filePath;
@end
