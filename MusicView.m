@interface MusicView : UIView
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel *trackLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UIView *metaContainerView;
@property (nonatomic, strong) UIImageView *skipButton;
@property (nonatomic, strong) UIImageView *playPauseButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) NSTimer *progressUpdateTimer;
- (void)updateNowPlayingInfo;
@end

#define CONSTANT_TO_BORDER 20

@implementation MusicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundView.layer.cornerRadius = 10;
        self.backgroundView.layer.masksToBounds = YES;
        [self addSubview:self.backgroundView];

        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;

        self.coverView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
        self.coverView.layer.cornerRadius = 10;
        self.coverView.clipsToBounds = YES;
        [self addSubview:self.coverView];

        self.metaContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.metaContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.metaContainerView];

        self.trackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.trackLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        self.trackLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.metaContainerView addSubview:self.trackLabel];

        self.artistLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // Instantiate artistLabel
        self.artistLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]; // Set font
        self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO; // Set translatesAutoresizingMaskIntoConstraints to NO
        [self.metaContainerView addSubview:self.artistLabel]; // Add artistLabel as subview

        self.skipButton = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.skipButton.userInteractionEnabled = YES;
        self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage *image = [UIImage systemImageNamed:@"forward.fill"];
        self.skipButton.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.skipButton.tintColor = [UIColor blackColor];
        [self addSubview:self.skipButton];

        self.playPauseButton = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.playPauseButton.userInteractionEnabled = YES;
        self.playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
        image = [UIImage systemImageNamed:@"play.fill"];
        self.playPauseButton.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.playPauseButton.tintColor = [UIColor blackColor];
        [self addSubview:self.playPauseButton];

        UITapGestureRecognizer *skipRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipButtonTapped:)];
        [self.skipButton addGestureRecognizer:skipRecognizer];

        UITapGestureRecognizer *playPauseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseButtonTapped:)];
        [self.playPauseButton addGestureRecognizer:playPauseRecognizer];

        self.progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        self.progressSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.progressSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
        [self addSubview:self.progressSlider];

        // Set up a timer to update the progress slider every second
        //self.progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressSlider) userInfo:nil repeats:YES];

        // Activate constraints
        [NSLayoutConstraint activateConstraints:@[
            [self.backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

            [self.coverView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.coverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:CONSTANT_TO_BORDER],
            [self.coverView.widthAnchor constraintEqualToConstant:64],
            [self.coverView.heightAnchor constraintEqualToAnchor:self.coverView.widthAnchor],

            [self.metaContainerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.metaContainerView.leadingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor constant:10],
            [self.metaContainerView.trailingAnchor constraintEqualToAnchor:self.playPauseButton.leadingAnchor constant:-10], // Add trailing constraint to keep a distance from the edge
            [self.metaContainerView.heightAnchor constraintEqualToAnchor:self.coverView.heightAnchor],

            [self.trackLabel.leadingAnchor constraintEqualToAnchor:self.metaContainerView.leadingAnchor], // Center horizontally
            [self.trackLabel.centerYAnchor constraintEqualToAnchor:self.metaContainerView.centerYAnchor constant:-12], // Center vertically
            [self.trackLabel.trailingAnchor constraintEqualToAnchor:self.metaContainerView.trailingAnchor],

            // Constraints for artistLabel
            [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.metaContainerView.leadingAnchor], // Center horizontally
            [self.artistLabel.topAnchor constraintEqualToAnchor:self.trackLabel.bottomAnchor constant:5],
            [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.metaContainerView.trailingAnchor],

            [self.skipButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-CONSTANT_TO_BORDER],
            [self.skipButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.skipButton.widthAnchor constraintEqualToConstant:30],
            [self.skipButton.heightAnchor constraintEqualToAnchor:self.skipButton.widthAnchor],

            [self.playPauseButton.trailingAnchor constraintEqualToAnchor:self.skipButton.leadingAnchor constant:-CONSTANT_TO_BORDER],
            [self.playPauseButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.playPauseButton.widthAnchor constraintEqualToConstant:28],
            [self.playPauseButton.heightAnchor constraintEqualToConstant:32],

            [self.progressSlider.leadingAnchor constraintEqualToAnchor:self.metaContainerView.leadingAnchor],
            [self.progressSlider.trailingAnchor constraintEqualToAnchor:self.skipButton.leadingAnchor constant:-CONSTANT_TO_BORDER],
            [self.progressSlider.heightAnchor constraintEqualToConstant:10],
            [self.progressSlider.bottomAnchor constraintEqualToAnchor:self.metaContainerView.bottomAnchor]
        ]];

        [self updateNowPlayingInfo];
    }
    return self;
}

- (void)skipButtonTapped:(UITapGestureRecognizer *)recognizer {
    SBFloatingDockView *superview = (SBFloatingDockView *)self.superview.superview;
   // NSLog(@"[Dock] Skipping song %@", superview);
    [superview skipSong];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self updateNowPlayingInfo];
    });
}

- (void)updateProgressSlider {
    [self getCurrentPlaybackTimeAndDuration:^(double currentPlaybackTime, double duration) {
        // Update the progress slider
        NSLog(@"[Dock] Current playback time: %f", currentPlaybackTime);
        NSLog(@"[Dock] Duration: %f", duration);
        self.progressSlider.value = (duration > 0.0) ? (currentPlaybackTime / duration) : 0.0;
    }];
}

- (void)getCurrentPlaybackTimeAndDuration:(void (^)(double, double))completion {
    MRMediaRemoteGetNowPlayingInfo(
        dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        if (result) {
            NSNumber *elapsedTime = [(__bridge NSDictionary *)result
                objectForKey:@"kMRMediaRemoteNowPlayingInfoElapsedTime"];
            NSNumber *totalTime = [(__bridge NSDictionary *)result
                objectForKey:@"kMRMediaRemoteNowPlayingInfoTotalTime"];
            if (elapsedTime && totalTime) {
                completion([elapsedTime doubleValue], [totalTime doubleValue]);
            } else {
                completion(0.0, 0.0);
            }
        } else {
            completion(0.0, 0.0);
        }
    });
}

- (void)updateNowPlayingInfo {
    MRMediaRemoteGetNowPlayingInfo(
        dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        if (result) {
            NSData *imageData = [(__bridge NSDictionary *)result
                objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"];
            NSString *fullTitle = [(__bridge NSDictionary *)result
                objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
            NSArray *titleComponents = [fullTitle componentsSeparatedByString:@" • "];
            NSString *title = titleComponents[0];
            NSString *artist = (titleComponents.count > 1) ? titleComponents[1] : @"";
            [UIView transitionWithView:self.coverView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^{
                    self.coverView.image = [UIImage imageWithData:imageData];
                    self.trackLabel.text = title;
                    self.artistLabel.text = artist;
                } 
            completion:nil];
            NSLog(@"[Dock] Now playing info: %@", (__bridge NSDictionary *)result);
        } else {
            self.trackLabel.text = @"No music playing";
            self.artistLabel.text = @"";
            NSLog(@"[Dock] No now playing info");
        }
    });
}

- (void)playPauseButtonTapped:(UITapGestureRecognizer *)recognizer {
    SBFloatingDockView *superview = (SBFloatingDockView *)self.superview.superview;
    [superview playPauseSong];
}

- (void)dealloc {
    // Invalidate the timer when the view is deallocated
    [self.progressUpdateTimer invalidate];
    self.progressUpdateTimer = nil;
}
@end
