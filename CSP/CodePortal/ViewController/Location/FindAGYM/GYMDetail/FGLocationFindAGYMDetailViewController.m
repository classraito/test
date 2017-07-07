//
//  FGLocationFindAGYMDetailViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationFindAGYMDetailViewController.h"
#import "Global.h"
@interface FGLocationFindAGYMDetailViewController ()
{
    NSMutableDictionary *dic_data_detail;
}
@end

@implementation FGLocationFindAGYMDetailViewController
@synthesize iv_gymBigImage;
@synthesize lb_gymName;
@synthesize queueView_rating;
@synthesize lb_time1;
@synthesize lb_time2;
@synthesize lb_tel;
@synthesize lb_location;
@synthesize btn_bookNow;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil detail:(NSMutableDictionary *)_dic_data
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        dic_data_detail = [_dic_data mutableCopy];
    }
    return self;
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [commond useDefaultRatioToScaleView:iv_gymBigImage];
    [commond useDefaultRatioToScaleView:lb_gymName];
    [commond useDefaultRatioToScaleView:queueView_rating];
    [commond useDefaultRatioToScaleView:lb_time1];
    [commond useDefaultRatioToScaleView:lb_time2];
    [commond useDefaultRatioToScaleView:lb_tel];
    [commond useDefaultRatioToScaleView:lb_location];
    [commond useDefaultRatioToScaleView:btn_bookNow];
    
    lb_gymName.font = font(FONT_TEXT_REGULAR, 16);
    lb_time1.font = font(FONT_TEXT_REGULAR, 14);
    lb_time2.font = font(FONT_TEXT_REGULAR, 14);
    lb_tel.font = font(FONT_TEXT_REGULAR, 14);
    lb_location.font = font(FONT_TEXT_REGULAR, 14);
    
    btn_bookNow.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    [self setupRating];
    
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"GYM DETAIL");
    [self hideBottomPanelWithAnimtaion:NO];
    
    iv_gymBigImage.image = [UIImage imageNamed:@"gymGallery.png"];
    
    [self bindDataToUI:dic_data_detail];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    dic_data_detail = nil;
}

-(void)setupRating
{
    NSMutableArray *_arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
    NSMutableArray *_arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
    CGRect imgBounds = CGRectMake(0, 0, 20 * ratioW, 20 * ratioH);
    [queueView_rating initalQueueByImageNames:_arr_imgs highlightedImageNames:_arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
}

-(void)bindDataToUI:(NSMutableDictionary *)_dic_data
{
    if(!_dic_data)
        return;
    [iv_gymBigImage sd_setImageWithURL:[NSURL URLWithString:[_dic_data objectForKey:@"Thumbnail"]] placeholderImage:IMG_PLACEHOLDER];
    lb_gymName.text = [_dic_data objectForKey:@"ScreenName"];
    [queueView_rating updateHighliteByCount:[[_dic_data objectForKey:@"Level"] intValue]];
    lb_time1.text = [_dic_data objectForKey:@"Open"];
    lb_tel.text = [NSString stringWithFormat:@"%@ : %@",multiLanguage(@"TEL"),[_dic_data objectForKey:@"Tel"]];
    lb_location.text = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"LOCATION"),[_dic_data objectForKey:@"Address"]] ;
    
}

#pragma mark - 从父类继承的


-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_bookNow:(id)_sender;
{
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"Are you sure?") message:multiLanguage(@"Are you sure need to book now?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            if(buttonIndex == 0)
            {
                
                NSString *str_tel = [dic_data_detail objectForKey:@"Tel"];
                [commond alertPhoneCallWebViewWithMobile:str_tel];
            }
    }];
}
@end
