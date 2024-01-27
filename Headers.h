#define NSLog(args...) NSLog(@"[Dock]" args)

@interface MRContentItemMetadata : NSObject
@property CGFloat calculatedPlaybackPosition;
@end

@interface MRContentItem : NSObject
@property MRContentItemMetadata *metadata;
- (instancetype)initWithNowPlayingInfo:(NSDictionary *)nowPlayingInfo;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)playForEventSource:(long long)arg1;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (void)setNowPlayingInfo:(id)arg1;
- (id)_nowPlayingInfo;
- (void)updatePomPomPlayButton;
@end

@interface SBDockIconListView : UIView
@end

@interface SBFloatingDockPlatterView : UIView
@end

@interface SBFloatingDockView : UIView
@property (nonatomic, retain) SBDockIconListView *userIconListView;
@property (nonatomic, retain) SBFloatingDockPlatterView *mainPlatterView;
- (void)skipSong;
- (void)playPauseSong;
@end

@interface SBFloatingDockViewController : UIViewController
@property (nonatomic, retain) UIView *bView;
@property (nonatomic, retain) SBFloatingDockView *dockView;
- (void)updateNowPlayingInfo;
@end