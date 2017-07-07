//
//  DailyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li
//
#import "DailyCalendarView.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"

#define TAG_VIEW 1000

@interface DailyCalendarView()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateLabelContainer;
@property (nonatomic, assign) BOOL bool_hiddenSpeator;
@property (nonatomic, assign) BOOL bool_showSelectedTriangle;
@property (nonatomic, assign) BOOL bool_isDoubleTap;

@end


#define DATE_LABEL_SIZE_HEIGHT (60)
#define DATE_LABEL_SIZE_WIDTH (45)

#define DATE_LABEL_FONT_SIZE 15

@implementation DailyCalendarView
@synthesize bool_isClosed;
@synthesize int_dailyCalendarType;

- (id)initWithFrame:(CGRect)frame hideSpeator:(BOOL)isHidden withType:(int)_type {
  if (self = [self initWithFrame:frame]) {
    self.bool_hiddenSpeator = isHidden;
    self.bool_isClosed = NO;
    self.int_dailyCalendarType = _type;
    
    if (_type == 1) {
      self.backgroundColor = [UIColor blackColor];
      self.bool_isClosed = YES;
    } else if (_type == 2) {
      self.backgroundColor = [UIColor clearColor];
    } else
      self.backgroundColor = [UIColor clearColor];
    
    [self updateDateLabelContainer];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame hideSpeator:(BOOL)isHidden {
  return [self initWithFrame:frame hideSpeator:isHidden withType:0];
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self addSubview:self.dateLabelContainer];
    
    [commond useDefaultRatioToScaleView:self.dateLabel];
    [commond useDefaultRatioToScaleView:self.dateLabelContainer];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyViewDidClick:)];
    [self addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dailyViewDidDoubleClick:)];
    [doubleFingerTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleFingerTap];
    
    [singleFingerTap requireGestureRecognizerToFail:doubleFingerTap];

  }
  return self;
}
-(UIView *)dateLabelContainer
{
  if(!_dateLabelContainer){
    float x = (self.bounds.size.width - DATE_LABEL_SIZE_WIDTH)/2;
    _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, DATE_LABEL_SIZE_WIDTH, DATE_LABEL_SIZE_HEIGHT)];
    _dateLabelContainer.backgroundColor = [UIColor clearColor];
    [_dateLabelContainer addSubview:self.dateLabel];
    
    NSLog(@"self=%@,draw==%@,hiddden=%d",self,self.date, self.bool_hiddenSpeator);
    //日历分割线
//    if (!self.bool_hiddenSpeator)
    {
      UIView *view_separator = [[UIView alloc] initWithFrame:CGRectMake(DATE_LABEL_SIZE_WIDTH, 10, 1, 40)];
  
      view_separator.tag = TAG_VIEW;
      view_separator.backgroundColor = [UIColor grayColor];
      CGRect ratio_separator = CGRectMake(ratioW, ratioH, 0.5, ratioH);
      [commond useRatio:ratio_separator toScaleView:view_separator] ;
      [_dateLabelContainer addSubview:view_separator];
    }
  }
  return _dateLabelContainer;
}

//更新日历分割线
- (void)updateDateLabelContainer {
  UIView *view_separator = [_dateLabelContainer viewWithTag:TAG_VIEW];
  view_separator.hidden = self.bool_hiddenSpeator;
}

-(UILabel *)dateLabel
{
  if(!_dateLabel){
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DATE_LABEL_SIZE_WIDTH, DATE_LABEL_SIZE_HEIGHT)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
  }
  
  return _dateLabel;
}

-(void)setDate:(NSDate *)date
{
  _date = date;
  
  [self setNeedsDisplay];
}
-(void)setBlnSelected: (BOOL)blnSelected
{
  _blnSelected = blnSelected;
  [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  self.dateLabel.text = [self.date getDateOfMonth];
  
  if (self.bool_showSelectedTriangle){
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.画三角形
    CGContextMoveToPoint(ctx, self.bounds.size.width/2-10, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2, self.bounds.size.height-10);
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2+10, self.bounds.size.height);
    UIColor *aColor;
    if (self.bool_isClosed)
      aColor = [UIColor whiteColor];
    else
      aColor = color_calendar_lightGray;
    
    CGContextSetFillColorWithColor(ctx, aColor.CGColor);
//    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
    
    // 关闭路径(连接起点和最后一个点)
    CGContextClosePath(ctx);
    // 3.绘制图形
//    CGContextStrokePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
  }
  
  //有课程就下标圆点
  if (self.int_dailyCalendarType == 2) {
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.画圆点
    UIColor *aColor;
    aColor = color_red_panel;
//    CGContextSetFillColorWithColor(ctx, aColor.CGColor);
    
    CGRect _frame = CGRectMake(self.bounds.size.width/2-3, self.bounds.size.height-20, 6, 6);
    CGContextAddEllipseInRect(ctx, _frame);
    [color_red_panel set];
    CGContextFillPath(ctx);
  }
}

-(void)markSelected:(BOOL)blnSelected
{
  //    DLog(@"mark date selected %@ -- %d",self.date, blnSelected);
  if([self.date isDateToday]){
    self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor clearColor]: [UIColor clearColor];//[UIColor colorWithHex:0x0081c1];
    
    if (self.bool_isClosed) {
      self.dateLabel.textColor = [UIColor whiteColor];
    } else {
      self.dateLabel.textColor = (blnSelected)?[UIColor greenColor]:[UIColor greenColor];
    }
  }else{
    self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor clearColor]: [UIColor clearColor];
    
    if (self.bool_isClosed) {
      self.dateLabel.textColor = [UIColor whiteColor];
    } else {
      self.dateLabel.textColor = (blnSelected)?[UIColor blackColor]:[self colorByDate];
    }
  }
  
  
  self.bool_showSelectedTriangle = blnSelected;
  [self setNeedsDisplay];
    //画山角
}
-(UIColor *)colorByDate
{
  //    return [self.date isPastDate]?[UIColor colorWithHex:0x7BD1FF]:[UIColor whiteColor];
//  return [self.date isPastDate]?[UIColor colorWithHex:0x7BD1FF]:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1.0];
  return [self.date isPastDate]?color_calendar_lightGray:color_calendar_featureDay;

}

-(void)dailyViewDidClick: (UIGestureRecognizer *)tap
{
  [self.delegate dailyCalendarViewDidSelect: self.date  isDoubleTap:NO];
}

- (void)dailyViewDidDoubleClick: (UIGestureRecognizer *)tap {
  [self.delegate dailyCalendarViewDidSelect: self.date  isDoubleTap:YES];

}
@end

