/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import "HotUpdataManage.h"

@interface AppDelegate()

@property (nonatomic,strong) RCTBridge *bridge;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  HotUpdataManage* manage = [HotUpdataManage getInstance];
  NSURL* localUrl = nil;
  #ifdef  DEBUG
    localUrl = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
  #else
    localUrl = [manage getBridge];
  #endif
  _bridge = [[RCTBridge alloc] initWithBundleURL:localUrl moduleProvider:nil launchOptions:nil];
  manage.bridge = _bridge;
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:_bridge moduleName:@"hotUpdataDemo" initialProperties:nil];
  
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [manage checkUpdate:@"http://rapapi.org/mockjsdata/13203/checkUpdate"];
  });
  
  return YES;
}


@end
