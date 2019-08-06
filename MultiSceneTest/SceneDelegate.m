#import "SceneDelegate.h"

static NSInteger _counter = 1;

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // find a userActivity, if there is one
    NSUserActivity *userActivity;
    if (session.stateRestorationActivity) {
        // if we're doing a state restore, get that activity
        userActivity = session.stateRestorationActivity;
    } else {
        // else grab anything in connectionOptions.userActivities
        userActivity = connectionOptions.userActivities.anyObject;
    }
    
    if (userActivity) {
        // give each new scene a unique title
        scene.title = [NSString stringWithFormat:@"Scene %ld", (long)_counter++];
        
        // save whatever userActivity was passed in (we may use it for state restoration later)
        scene.userActivity = userActivity;
        
    } else {
        // no user activity or state restoration
        scene.title = @"Initial Scene";
    }
}

- (NSUserActivity *)stateRestorationActivityForScene:(UIScene *)scene {
    return scene.userActivity;
}

@end
