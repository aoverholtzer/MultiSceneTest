//
//  SceneDelegate.h
//  MultiSceneTest
//
//  Created by adam on 7/6/19.
//  Copyright © 2019 adam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const DEFAULT_CONFIG_NAME;
extern NSString *const SECONDARY_CONFIG_NAME;
extern NSString *const SECONDARY_SCENE_ACTIVITY_TYPE;

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

