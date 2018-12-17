#import "RCTVideoPlayerViewController.h"

@interface RCTVideoPlayerViewController ()

@property (assign, nonatomic) BOOL isFullscreenMode;

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

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [_rctDelegate videoPlayerViewControllerWillDismiss:self];
  [_rctDelegate videoPlayerViewControllerDidDismiss:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([self contentOverlayView]) {
        BOOL isFullscreenMode = self.contentOverlayView.frame.size.height == UIScreen.mainScreen.bounds.size.height;
        
        if (isFullscreenMode) {
            if (!self.isFullscreenMode) {
                [NSNotificationCenter.defaultCenter postNotificationName:@"goToFullscreenMode" object:nil];
            }
            
            self.isFullscreenMode = true;
        }
        
        if (self.isFullscreenMode && !isFullscreenMode) {
            self.isFullscreenMode = false;
            
            [NSNotificationCenter.defaultCenter postNotificationName:@"exitFromFullscreenMode" object:nil];
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
