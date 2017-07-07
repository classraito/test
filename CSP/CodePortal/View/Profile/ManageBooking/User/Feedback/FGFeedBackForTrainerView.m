//
//  FGFeedBackForTrainerView.m
//  CSP
//
//  Created by JasonLu on 16/12/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFeedBackForTrainerView.h"
#import "UIImageView+Circle.h"

#define TAG_STARBUTTON 100

@interface FGFeedBackForTrainerView () <UITextViewDelegate> {
  NSInteger int_count;
  NSMutableArray *arr_imgs;
  NSMutableArray *arr_imgs_highlighted;
  CGRect imgBounds;
}

@end

@implementation FGFeedBackForTrainerView
@synthesize lb_textViewPlaceHolder;
#pragma mark - 生命周期
- (void)awakeFromNib {
  arr_imgs = (NSMutableArray *)@[@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png",@"popup_star_stoke.png"];
  arr_imgs_highlighted = (NSMutableArray *)@[@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png",@"popup_star_filled.png"];
  imgBounds = CGRectMake(0, 0, 16 * ratioW, 16 * ratioH);
  
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:self.view_whiteBg];
  [commond useDefaultRatioToScaleView:self.lb_textViewPlaceHolder];
  
  self.lb_textViewPlaceHolder.font = font(FONT_TEXT_REGULAR, 18);
  self.tv_feedback.delegate = self;
  
  [self.iv_trainerThumbnail makeCicleWithRaduis:self.iv_trainerThumbnail.bounds.size.width/2];
}

- (void)dealloc {
  _dic_trainerInfo = nil;
  arr_imgs = nil;
  arr_imgs_highlighted = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 初始化
-(void)setupRating
{
  NSArray *_arr_images = [self.queueView_rating initalQueueByImageNames:arr_imgs highlightedImageNames:arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
  
  int_count = _arr_images.count;
  //添加五个对应的按钮
  for (int i = 0; i < _arr_images.count; i++) {
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.tag = TAG_STARBUTTON+i;
    [_btn addTarget:self action:@selector(buttonAction_starClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *_iv_star = _arr_images[i];
    _btn.frame = _iv_star.frame;
    
    [_btn setBackgroundColor:[UIColor clearColor]];
    [self.queueView_rating addSubview:_btn];
  }
  [self setupSelectedStatusWithCount:int_count];
}

- (void)setupViewWithTrainerInfo:(NSDictionary *)_dic_info {
  _dic_trainerInfo = [NSDictionary dictionaryWithDictionary:_dic_info];
  
  
  NSString *_str_userIcon = _dic_info[@"user"][@"UserIcon"];
  [self.iv_trainerThumbnail sd_setImageWithURL:[NSURL URLWithString:_str_userIcon] placeholderImage:IMG_PLACEHOLDER];
  
  
    [self setupTextPlaceHoldaerLabel: multiLanguage(@"How was your session? Did you have a great workout?") showPlaceHoldaer:YES];
  self.tv_feedback.text = @"";

}

- (void) setupTextPlaceHoldaerLabel:(NSString *)text showPlaceHoldaer:(BOOL)showPlaceHoldaer {
  self.lb_textViewPlaceHolder.hidden = !showPlaceHoldaer;
  self.lb_textViewPlaceHolder.text = text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
  [self setupTextPlaceHoldaerLabel:multiLanguage(@"How was your session? Did you have a great workout?") showPlaceHoldaer:NO];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
  if ([self.tv_feedback.text isEqualToString:@""]) {
    [self setupTextPlaceHoldaerLabel:multiLanguage(@"How was your session? Did you have a great workout?") showPlaceHoldaer:YES];
  }
}

#pragma mark - 点击事件
- (void)buttonAction_starClicked:(id)sender {
  //clear all button selected status
  [self clearAllSelectedStatus];
  
  UIButton *_btn = (UIButton *)sender;
  NSInteger _int_selectTag = _btn.tag - TAG_STARBUTTON;
  [self setupSelectedStatusWithCount:_int_selectTag+1];
}

#pragma mark - 其它
- (void)clearAllSelectedStatus {
  [self.queueView_rating initalQueueByImageNames:arr_imgs highlightedImageNames:arr_imgs_highlighted padding:5 imgBounds:imgBounds increaseMode:ViewsQueueIncreaseMode_CENTER];
}

- (void)setupSelectedStatusWithCount:(NSInteger)_int_count {
  [self.queueView_rating updateHighliteByCount:_int_count];
  int_count = _int_count;
}

- (NSInteger)ratingCount {
  return int_count;
}

- (NSString *)reviewContent {
  if (ISNULLObj(self.tv_feedback.text))
    return @"";
  return self.tv_feedback.text;
}

@end
