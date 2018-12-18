#import "RCTVideoPlayerViewController.h"

@interface RCTVideoPlayerViewController ()

@property (assign, nonatomic) BOOL isFullscreenMode;
@property (assign, nonatomic) BOOL isVisible;

@end

@implementation RCTVideoPlayerViewController

- (BOOL)shouldAutorotate {
    
    if (self.autorotate || self.preferredOrientation.lowercaseString == nil || [self.preferredOrientation.lowercaseString isEqualToString:@"all"])
        return YES;
    
    return NO;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFullscreenMode = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.isVisible = NO;
    
    [_rctDelegate videoPlayerViewControllerWillDismiss:self];
    [_rctDelegate videoPlayerViewControllerDidDismiss:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([self contentOverlayView]) {
        BOOL isFullscreenMode = self.contentOverlayView.frame.size.height == UIScreen.mainScreen.bounds.size.height;
        
        if (isFullscreenMode) {
            if (!self.isFullscreenMode && self.isVisible) {
                __weak RCTVideoPlayerViewController *weakSelf = self;
                
                [NSNotificationCenter.defaultCenter postNotificationName:@"goToFullscreenMode"
                                                                  object:nil
                                                                userInfo:@{@"object": weakSelf}];
            }
            
            self.isFullscreenMode = YES;
        }
        
        if (self.isFullscreenMode && !isFullscreenMode && self.isVisible) {
            self.isFullscreenMode = NO;
            
            __weak RCTVideoPlayerViewController *weakSelf = self;
            [NSNotificationCenter.defaultCenter postNotificationName:@"exitFromFullscreenMode"
                                                              object:nil
                                                            userInfo:@{@"object": weakSelf}];
        }
    }
}

#if !TARGET_OS_TV
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.preferredOrientation.lowercaseString isEqualToString:@"landscape"]) {
        return UIInterfaceOrientationLandscapeRight;
    }
    else if ([self.preferredOrientation.lowercaseString isEqualToString:@"portrait"]) {
        return UIInterfaceOrientationPortrait;
    }
    else { // default case
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        return orientation;
    }
}
#endif

@end
