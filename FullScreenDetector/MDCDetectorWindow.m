//
//  MDCDetectorWindow.m
//  FullScreenDetector
//
//  Created by Mark Christian on 1/19/13.
//  Copyright (c) 2013 Mark Christian. All rights reserved.
//

#import "MDCDetectorWindow.h"

#pragma mark Notifications
NSString * kMDCFullScreenDetectorSwitchedToFullScreenApp = @"com.whimsicalifornia.fullscreendetector.switchedToFullScreenApp";
NSString * kMDCFullScreenDetectorSwitchedToRegularSpace = @"com.whimsicalifornia.fullscreendetector.switchedToRegularSpace";

@implementation MDCDetectorWindow

- (void)awakeFromNib {
  fullScreenAppIsActive = NO;

  //  Register for notifications
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(activeSpaceDidChange:) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
}

#pragma mark - Notification handlers
- (void)activeSpaceDidChange:(NSNotification *)notification {
  [self updateFullScreenStatus];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [self activeSpaceDidChange:notification];
}

#pragma mark - Detecting full screen state
- (void)updateFullScreenStatus {
  //  We're moved to ordinary spaces automatically, but not fullscreen apps
  BOOL newFullScreenAppIsActive = !self.isOnActiveSpace;

  if (newFullScreenAppIsActive == fullScreenAppIsActive) {
    //  No change
//    return;
  }

  //  Update state
  fullScreenAppIsActive = newFullScreenAppIsActive;

  //  Post notification
  NSString *notificationName;
  if (fullScreenAppIsActive) {
    notificationName = kMDCFullScreenDetectorSwitchedToFullScreenApp;
  } else {
    notificationName = kMDCFullScreenDetectorSwitchedToRegularSpace;
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

#pragma mark - NSWindow overrides
- (CGFloat)alphaValue {
  return 0.5;
}

- (BOOL)canBecomeKeyWindow {
  return NO;
}

- (NSWindowCollectionBehavior)collectionBehavior {
  return NSWindowCollectionBehaviorFullScreenAuxiliary | NSWindowCollectionBehaviorCanJoinAllSpaces;
}

- (BOOL)ignoresMouseEvents {
  return YES;
}

- (NSInteger)level {
  return kCGScreenSaverWindowLevel;
}

#pragma mark - Public interface
- (BOOL)fullScreenAppIsActive {
  return fullScreenAppIsActive;
}

@end