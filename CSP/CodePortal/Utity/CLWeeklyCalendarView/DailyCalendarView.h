//
//  DailyCalendarView.h
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DailyCalendarViewDelegate <NSObject>
-(void)dailyCalendarViewDidSelect: (NSDate *)date isDoubleTap:(BOOL)_isDoubleTap;

@end
@interface DailyCalendarView : UIView
@property (nonatomic, weak) id<DailyCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) BOOL blnSelected;
@property (nonatomic, assign) BOOL bool_isClosed;
@property (nonatomic, assign) int int_dailyCalendarType;

-(void)markSelected:(BOOL)blnSelected;

- (id)initWithFrame:(CGRect)frame hideSpeator:(BOOL)isHidden withType:(int)_type;
- (id)initWithFrame:(CGRect)frame hideSpeator:(BOOL)isHidden;
@end
