//  CSP
//
//  Created by Ryan Gong on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWindowsStyleProgressView.h"
#import "Global.h"
const CGFloat CHUNK_WIDTH = 4.0f;

const NSInteger CHUNK_COUNT = 12;

CGFloat maxPullPower;

@interface FGWindowsStyleProgressView()
{
    UIView *view_leftLine;
    UIView *view_rightLine;
}
@end

@implementation FGWindowsStyleProgressView
@synthesize progressStatus;
@synthesize pullPower;
@synthesize scrollView;
@synthesize pullToRefreshActionHandler;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInital];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self internalInital];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.progressChunks = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)internalInital
{
    progressStatus = ProgressStatus_Inital;
    maxPullPower = 100 * ratioH;
    self.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];//监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];//监听是否重新进入程序程序.
    
    
    view_leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0 , 2)];
    view_rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width , 0, 0, 2)];
    [self addSubview:view_leftLine];
    [self addSubview:view_rightLine];
    view_leftLine.center = CGPointMake(view_leftLine.center.x, self.frame.size.height / 2);
    view_rightLine.center = CGPointMake(view_rightLine.center.x, self.frame.size.height / 2);
    
    self.trackTintColor = [UIColor whiteColor];
    self.progressTintColor = [UIColor blueColor];
    
//    self.hidden = YES;
    
    _progressChunks = [NSMutableArray arrayWithCapacity:1];

}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.backgroundColor = trackTintColor;
    
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    view_leftLine.backgroundColor = progressTintColor;
    view_rightLine.backgroundColor = progressTintColor;
    for (UIView *v in self.progressChunks) {
        v.backgroundColor = progressTintColor;
    }
}

-(void)updatePullPowerByScrollOffset:(CGPoint)_contentOffset
{
    CGFloat _offsetY = _contentOffset.y;
    
    if(progressStatus == ProgressStatus_Pull)
    {
        
        _offsetY = _offsetY < 0?_offsetY:0;
        pullPower = fabs(_offsetY) / maxPullPower;
        
        CGFloat lineWidth  = pullPower * self.frame.size.width/2;
        CGRect _frame = view_leftLine.frame;
        _frame.origin.x = 0;
        _frame.size.width = lineWidth;
        view_leftLine.frame = _frame;
        
        _frame = view_rightLine.frame;
        _frame.origin.x = self.frame.size.width - lineWidth;
        _frame.size.width = lineWidth;
        view_rightLine.frame = _frame;
        if(pullPower > 1 )
        {
            [self startAnimating];
             pullToRefreshActionHandler();
        }
    }
}

- (void)startAnimating
{
    if (progressStatus == ProgressStatus_Refreshing)
        return;
    
    
    progressStatus = ProgressStatus_Refreshing;

    [self.progressChunks removeAllObjects];
    view_leftLine.hidden = YES;
    view_rightLine.hidden = YES;
    
    
    
    for(int i=0;i<CHUNK_COUNT;i++)
    {
        UIView *view_chunck = [[UIView alloc] initWithFrame:CGRectMake(-CHUNK_WIDTH, 0, CHUNK_WIDTH, CHUNK_WIDTH)];
        view_chunck.center = CGPointMake(view_chunck.center.x, self.frame.size.height / 2);
        view_chunck.layer.cornerRadius = CHUNK_WIDTH / 2;
        view_chunck.layer.masksToBounds = YES;
        [self.progressChunks addObject:view_chunck];
    }
    
    
    NSTimeInterval delay = 0;
    for (UIView *v in self.progressChunks) {
        v.backgroundColor = self.progressTintColor;

        [self addSubview:v];

        [self animateProgressChunk:v delay:(delay += 0.15)];
    }
    
   
}

- (void)stopAnimating
{
    if (progressStatus != ProgressStatus_Refreshing)
        return;
    
    progressStatus = ProgressStatus_Refreshed;
    view_leftLine.hidden = NO;
    view_rightLine.hidden = NO;
    CGRect _frame = view_leftLine.frame;
    _frame.size.width = 0;
    view_leftLine.frame = _frame;
    
    _frame = view_rightLine.frame;
    _frame.origin.x = self.frame.size.width;
    _frame.size.width = 0;
    view_rightLine.frame = _frame;
    
    
    pullPower = 0;
    
    for (UIView *v in self.progressChunks) {
        [v removeFromSuperview];
    }
    [self.progressChunks removeAllObjects];
    
    
    
}

- (void)animateProgressChunk:(UIView *)chunk delay:(NSTimeInterval)delay
{
    
    [UIView animateWithDuration:1.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect chuckFrame = chunk.frame;
        chuckFrame.origin.x = self.frame.size.width;
        chunk.frame = chuckFrame;
    } completion:^(BOOL finished) {
        
        if(finished)
        {
            CGRect chuckFrame = chunk.frame;
            chuckFrame.origin.x = -CHUNK_WIDTH;
            chunk.frame = chuckFrame;
            [self animateProgressChunk:chunk delay:1.6];
        }
        
        
    }];
}

-(void)recoveryAnimtaionIfNeeded
{
    if(progressStatus == ProgressStatus_Refreshing)
    {
        [self.layer removeAllAnimations];
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"])
        [self handleScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey]
                                   CGPointValue]];
    
}

- (void)handleScrollViewDidScroll:(CGPoint)_conentOffset {
    
    CGFloat _offsetY = _conentOffset.y;
    
    CGRect _frame = self.frame;
    _frame.origin.y = _offsetY;
    self.frame = _frame;
    
    if(progressStatus == ProgressStatus_Refreshed)
    {
        if(self.frame.origin.y <= 0)
        {
            progressStatus = ProgressStatus_Inital;
        }
    }
    
    if(progressStatus == ProgressStatus_Inital)
        progressStatus = ProgressStatus_Pull;
    
    [self updatePullPowerByScrollOffset:_conentOffset];
    
}

#pragma mark - 处理程序生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
    [self recoveryAnimtaionIfNeeded];
}

@end
