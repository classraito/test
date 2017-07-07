//
//  FGPostShareView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostShareView.h"
#import "Global.h"
#import "FGPostCameraViewController.h"

#import "NetworkManager_User.h"
@interface FGPostShareView()
{
    AVPlayerLayer *_playerLayer;
}
@end



@implementation FGPostShareView
@synthesize searchAPI;
@synthesize view_whiteBG;
@synthesize tv_post;
@synthesize lb_placeHolderText;

@synthesize iv_imgPlaceHolder1;
@synthesize iv_imgPlaceHolder2;
@synthesize iv_imgPlaceHolder3;
@synthesize btn_placeHolder1;
@synthesize btn_placeHolder2;
@synthesize btn_placeHolder3;

@synthesize iv_close1;
@synthesize iv_close2;
@synthesize iv_close3;
@synthesize btn_close1;
@synthesize btn_close2;
@synthesize btn_close3;

@synthesize btn_topic;

@synthesize iv_atSomeone;
@synthesize iv_place;

@synthesize btn_atSomeone;
@synthesize btn_place;

@synthesize lb_title_share;
@synthesize lb_facebook;
@synthesize lb_wechat;
@synthesize lb_weibo;
@synthesize lb_qzone;
@synthesize lb_moment;

@synthesize iv_facebook;
@synthesize iv_wechat;
@synthesize iv_weibo;
@synthesize iv_qzone;

@synthesize btn_facebook;
@synthesize btn_wechat;
@synthesize btn_weibo;
@synthesize btn_qzone;

@synthesize btn_moment;
@synthesize iv_moment;

@synthesize view_videoContainer;

@synthesize iv_hashTag;

@synthesize lat;
@synthesize lng;

@synthesize iv_share;
@synthesize btn_share;

@synthesize str_addres;
@synthesize str_videoFilePath;

@synthesize lb_address;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
  
    [commond useDefaultRatioToScaleView:view_whiteBG];
    [commond useDefaultRatioToScaleView: tv_post];
    [commond useDefaultRatioToScaleView:lb_placeHolderText];
    
    [commond useDefaultRatioToScaleView: iv_imgPlaceHolder1];
    [commond useDefaultRatioToScaleView: iv_imgPlaceHolder2];
    [commond useDefaultRatioToScaleView: iv_imgPlaceHolder3];
    [commond useDefaultRatioToScaleView: btn_placeHolder1];
    [commond useDefaultRatioToScaleView: btn_placeHolder2];
    [commond useDefaultRatioToScaleView: btn_placeHolder3];
    
    [commond useDefaultRatioToScaleView:iv_close1];
    [commond useDefaultRatioToScaleView:iv_close2];
    [commond useDefaultRatioToScaleView:iv_close3];
    [commond useDefaultRatioToScaleView:btn_close1];
    [commond useDefaultRatioToScaleView:btn_close2];
    [commond useDefaultRatioToScaleView:btn_close3];
    
    [commond useDefaultRatioToScaleView: btn_topic];
    
    [commond useDefaultRatioToScaleView: iv_atSomeone];
    [commond useDefaultRatioToScaleView: iv_place];
    
    [commond useDefaultRatioToScaleView: btn_atSomeone];
    [commond useDefaultRatioToScaleView: btn_place];
    
    [commond useDefaultRatioToScaleView: lb_title_share];
    [commond useDefaultRatioToScaleView: lb_facebook];
    [commond useDefaultRatioToScaleView: lb_wechat];
    [commond useDefaultRatioToScaleView: lb_weibo];
    [commond useDefaultRatioToScaleView: lb_qzone];
    
    [commond useDefaultRatioToScaleView: iv_facebook];
    [commond useDefaultRatioToScaleView: iv_wechat];
    [commond useDefaultRatioToScaleView: iv_weibo];
    [commond useDefaultRatioToScaleView: iv_qzone];
    
    [commond useDefaultRatioToScaleView: btn_facebook];
    [commond useDefaultRatioToScaleView: btn_wechat];
    [commond useDefaultRatioToScaleView: btn_weibo];
    [commond useDefaultRatioToScaleView: btn_qzone];
    
    [commond useDefaultRatioToScaleView:view_videoContainer];
    
    [commond useDefaultRatioToScaleView:iv_moment];
    [commond useDefaultRatioToScaleView:lb_moment];
    [commond useDefaultRatioToScaleView:btn_moment];
    [commond useDefaultRatioToScaleView:iv_hashTag];

    [commond useDefaultRatioToScaleView:lb_address];

  
    [commond useDefaultRatioToScaleView:iv_share];
    [commond useDefaultRatioToScaleView:btn_share];

  
    
    [self setupUI];
    
    self.tv_post.delegate = self;
    self.delegate = self;
    
    lb_address.font = font(FONT_TEXT_REGULAR, 14);
    
    [self.tv_post setupAttributesWithFont:tv_post.font textColor:tv_post.textColor];
    [self.tv_post setupMathPatternsWithArray:@[ @{@"key":@[@"@"],      @"linkPrefix":@"userid:", @"bgColor":[UIColor clearColor], @"font":font(FONT_TEXT_BOLD, 16),     @"color":color_red_panel},
                                                 @{@"key":@[@"#",@"#"],    @"linkPrefix":@"",  @"bgColor":[UIColor clearColor], @"font":font(FONT_TEXT_BOLD, 16),    @"color":color_red_panel}] maxLength:400];
    [self.tv_post setupWithSpecialPattern:@"@" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_User];
    }];
    [self.tv_post setupWithSpecialPattern:@"#" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_Topic];
    }];
    
    btn_placeHolder1.tag = 1;
    btn_placeHolder2.tag = 2;
    btn_placeHolder3.tag = 3;
    
    iv_close1.hidden = YES;
    iv_close2.hidden = YES;
    iv_close3.hidden = YES;
    btn_close1.hidden = YES;
    btn_close2.hidden = YES;
    btn_close3.hidden = YES;
    
}

-(void)clearMemory
{
    self.tv_post.delegate = nil;
    self.tv_post = nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_addres = nil;
    
    if(view_videoContainer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playerLayer removeFromSuperlayer];
        str_videoFilePath = nil;
        
    }
}

-(void)resetStatus
{
    iv_imgPlaceHolder1.image = [UIImage imageNamed:@"addphoto.png"];
    iv_imgPlaceHolder1.hidden = NO;
    iv_imgPlaceHolder2.image = [UIImage imageNamed:@"addphoto.png"];
    iv_imgPlaceHolder2.hidden = NO;
    iv_imgPlaceHolder3.image = [UIImage imageNamed:@"addphoto.png"];
    iv_imgPlaceHolder3.hidden = NO;
    
    iv_close1.hidden = YES;
    btn_close1.hidden = YES;
    iv_close2.hidden = YES;
    btn_close2.hidden = YES;
    iv_close3.hidden = YES;
    btn_close3.hidden = YES;
    
    
}

-(void)bindDataToUI:(NSMutableArray *)_arr_imgs videoFilePath:(NSString *)_str_filePath
{
    if(_arr_imgs)
    {
        SAFE_RemoveSupreView(view_videoContainer);
        view_videoContainer = nil;
        view_videoContainer = nil;
        [self resetStatus];
        for(int i=0 ; i<[_arr_imgs count];i++)
        {
            if(i==0)
            {
                iv_imgPlaceHolder1.image = [_arr_imgs objectAtIndex:0];
                iv_close1.hidden = NO;
                btn_close1.hidden = NO;
            }
            else if(i==1)
            {
                iv_imgPlaceHolder2.image = [_arr_imgs objectAtIndex:1];
                iv_close2.hidden = NO;
                btn_close2.hidden = NO;
            }
            else if(i==2)
            {
                iv_imgPlaceHolder3.image = [_arr_imgs  objectAtIndex:2];
                iv_close3.hidden = NO;
                btn_close3.hidden = NO;
            }
        }
    }
    else if(_str_filePath)
    {
        SAFE_RemoveSupreView(iv_imgPlaceHolder1);
        SAFE_RemoveSupreView(iv_imgPlaceHolder2);
        SAFE_RemoveSupreView(iv_imgPlaceHolder3);
        SAFE_RemoveSupreView(btn_placeHolder1);
        SAFE_RemoveSupreView(btn_placeHolder2);
        SAFE_RemoveSupreView(btn_placeHolder3);
        SAFE_RemoveSupreView(iv_close1);
        SAFE_RemoveSupreView(iv_close2);
        SAFE_RemoveSupreView(iv_close3);
        SAFE_RemoveSupreView(btn_close1);
        SAFE_RemoveSupreView(btn_close2);
        SAFE_RemoveSupreView(btn_close3);
        
        view_videoContainer.layer.cornerRadius = 8;
        view_videoContainer.layer.masksToBounds = YES;
        
        if([_str_filePath isEmptyStr])
            return;
        
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnVideo:)];
        _tap.cancelsTouchesInView = NO;
        [view_videoContainer addGestureRecognizer:_tap];
        str_videoFilePath = _str_filePath;
        NSLog(@"str_videoFilePath = %@",str_videoFilePath);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self setupAVAssetByPath:str_videoFilePath];
        
    }
}

-(void)setupAVAssetByPath:(NSString *)_str_videoPath
{
    AVURLAsset *anAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_str_videoPath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:anAsset];
    AVPlayer *_player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [_playerLayer.player pause];
    _playerLayer.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [_playerLayer.player setMuted:YES];
    [view_videoContainer.layer insertSublayer:_playerLayer atIndex:0];
    _playerLayer.frame = view_videoContainer.bounds;
    if(_playerLayer.player.status == AVPlayerItemStatusReadyToPlay)
    {
        [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                   toleranceBefore: kCMTimeZero
                                    toleranceAfter: kCMTimeZero
                                 completionHandler: ^(BOOL finished)
         {
             if(finished)
             {
                 [_playerLayer.player play];
             }
             
         }];
    }
    else if(_playerLayer.player.status == AVPlayerItemStatusUnknown)
    {
        [_playerLayer.player play];
    }

    
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    AVPlayerItem *_playerItem = [notification object];
    
    if(_playerLayer && [_playerItem isEqual:_playerLayer.player.currentItem])
    {
        if(_playerLayer.player.status == AVPlayerItemStatusReadyToPlay)
        {
            [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                             toleranceBefore: kCMTimeZero
                                              toleranceAfter: kCMTimeZero
                                           completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     [_playerLayer.player play];
                 }
                 
             }];
        }
    }
    else if(_playerLayer.player.status == AVPlayerItemStatusUnknown)
    {
        [_playerLayer.player play];
    }
}


#pragma mark - setupUI
-(void)setupUI
{
    self.tv_post.font = font(FONT_TEXT_REGULAR, 16);
    self.lb_placeHolderText.font = font(FONT_TEXT_REGULAR, 16);
    self.lb_title_share.font = font(FONT_TEXT_BOLD, 16);
    
    self.lb_weibo.font = font(FONT_TEXT_BOLD, 16);
    self.lb_qzone.font = font(FONT_TEXT_BOLD, 16);
    self.lb_wechat.font = font(FONT_TEXT_BOLD, 16);
    self.lb_facebook.font = font(FONT_TEXT_BOLD, 16);
    self.lb_moment.font = font(FONT_TEXT_BOLD, 16);
}

#pragma mark - buttonAction


-(IBAction)buttonAction_topic:(id)_sender;
{
    [tv_post becomeFirstResponder];
    tv_post.text = [tv_post.text stringByAppendingString:@"#"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:tv_post];
    [commond presentUserPickViewFromController:[self viewController] listType:ListType_Topic];
    
}

-(IBAction)buttonAction_at:(id)_sender;
{
    [tv_post becomeFirstResponder];
    tv_post.text = [tv_post.text stringByAppendingString:@"@"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:tv_post];
   [commond presentUserPickViewFromController:[self viewController] listType:ListType_User];
 
}

-(IBAction)buttonAction_place:(id)_sender;
{
    iv_place.highlighted = iv_place.highlighted ? NO : YES;
    if(iv_place.highlighted)
    {
        [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
            if(_lat != DEFAULT_LATITUDE && _lng != DEFAULT_LONTITUDE)
            {
                lat = [commond EnCodeCoordinate:_lat];
                lng = [commond EnCodeCoordinate:_lng];
                [self initASearchAPIWithDelegate:self];
                [self searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(_lat, _lng)];
            }
            
        }];
    }
    else
    {
        lb_address.text = @"";
        str_addres = @"";
    }
    
}

#pragma mark - 地址搜索
-(void)initASearchAPIWithDelegate:(id<AMapSearchDelegate>)_delegate;
{
    if(self.searchAPI)
        return;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = _delegate;
    AMapSearchLanguage _mapLanguage = AMapSearchLanguageEn;
    if([commond isChinese])
        _mapLanguage = AMapSearchLanguageZhCN;
    self.searchAPI.language = _mapLanguage;
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(!self.searchAPI)
        return;
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    regeo.radius = 3000;
    [self.searchAPI AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        AMapReGeocode *regeocode = response.regeocode;
        
        /* 包含 省, 市, 区以及乡镇.  */
        NSString *_str_city = [NSString stringWithFormat:@"%@%@",
                                                 regeocode.addressComponent.province?: @"",
                                                 regeocode.addressComponent.city ?: @""
                                                 
                                                 ];
        
        NSString *_str_adress = [NSString stringWithFormat:@"%@ %@ %@",
                                                               regeocode.addressComponent.streetNumber.street?: @"",
                                                               regeocode.addressComponent.streetNumber.number?: @"",
                                                               regeocode.addressComponent.building?: @""];
        
        lb_address.text = [NSString stringWithFormat:@"%@ %@",_str_city,_str_adress];
        
        str_addres = lb_address.text;
    }
}

-(void)tapGestureOnVideo:(id)_sender
{
    [commond showPhotoVideoGalleryToView:appDelegate.window fromView:view_videoContainer imgs:nil imgIndex:0 videoUrl:str_videoFilePath];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    lb_placeHolderText.hidden = YES;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [tv_post resignFirstResponder];
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)_textView{
    if (_textView.text.length == 0) {
        
        self.lb_placeHolderText.hidden = NO;
    }else{
        self.lb_placeHolderText.hidden = YES;
    }
}


@end
