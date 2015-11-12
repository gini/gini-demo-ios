//
//  AppDelegate.h
//  gini-demo
//
//  Created by Gini on 11/11/15.
//  Copyright © 2015 Gini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Gini-iOS-SDK/GiniSDK.h>

@interface GiniDemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// GiniSDK property to have global access to the Gini API
@property GiniSDK *giniSDK;

@end

