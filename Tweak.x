#import "Tweak.h"

%hook SBFloatingDockView
%new
- (void)skipSong {
	[[%c(SBMediaController) sharedInstance] changeTrack:1 eventSource:0];
}

%new
- (void)playPauseSong{
	if (![[%c(SBMediaController) sharedInstance] _nowPlayingInfo]) { // check if music is already playing
        [[%c(SBMediaController) sharedInstance] playForEventSource:0];
    } else {
        [[%c(SBMediaController) sharedInstance] togglePlayPauseForEventSource:0];
    }
}
%end

%hook SBFloatingDockViewController
%property (nonatomic, retain) UIView *bView;
- (void)viewDidLoad {
	%orig;
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
}

%new
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.dockView.userIconListView];
    CGPoint velocity = [gesture velocityInView:self.dockView.userIconListView];
    
    CGFloat threshold = 1000; // Adjust the threshold value as needed
    
	CGFloat originX = self.dockView.userIconListView.frame.origin.x;

    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.dockView.userIconListView.frame;
        frame.origin.x += translation.x;
        self.dockView.userIconListView.frame = frame;
        [gesture setTranslation:CGPointZero inView:self.dockView.userIconListView];
        
        // Scale up the bView
        if (!self.bView) {
            self.bView = [[UIView alloc] initWithFrame:CGRectMake(self.dockView.mainPlatterView.frame.origin.x, self.dockView.mainPlatterView.frame.origin.y, self.dockView.mainPlatterView.frame.size.width, self.dockView.mainPlatterView.frame.size.height)];
            self.bView.alpha = 0.0;
			[self.bView addSubview:[[MusicView alloc] initWithFrame:CGRectMake(0, 0, self.bView.frame.size.width, self.bView.frame.size.height)]];
            [self.dockView addSubview:self.bView];
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        // Determine if the velocity exceeds the threshold
        if (fabs(velocity.x) > threshold) {
            // If velocity is greater than threshold, slide the view automatically
            CGFloat targetX = velocity.x > 0 ? self.view.bounds.size.width : -self.view.bounds.size.width;
            [UIView animateWithDuration:0.3 animations:^{
				self.bView.alpha = 1.0;
				MusicView *musicView = (MusicView *)self.bView.subviews[0];
				[musicView updateNowPlayingInfo];
                CGRect frame = self.dockView.userIconListView.frame;
                frame.origin.x = targetX;
                self.dockView.userIconListView.frame = frame;
            }];
        } else {
            // If velocity is below threshold, animate back to original position
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.dockView.userIconListView.frame;
                frame.origin.x = 0;
                self.dockView.userIconListView.frame = frame;
				self.bView.alpha = 0.0;
            } completion:nil];
			CGRect frame = self.dockView.userIconListView.frame;
            frame.origin.x = 9;
			self.dockView.userIconListView.frame = frame;
		}
    }
}
%end