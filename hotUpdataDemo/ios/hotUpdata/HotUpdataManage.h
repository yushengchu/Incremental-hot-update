//
//  HotUpdataManage.h
//  hotUpdataDemo
//
//  Created by joker on 2017/9/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface HotUpdataManage : NSObject

//单例方法
+ (HotUpdataManage*)getInstance;

//获取加载URL
- (NSURL*)getBridge;

//检查更新
- (void)checkUpdate:(NSString*)checkUrl;

@property (nonatomic,strong) RCTBridge *bridge;

@end
