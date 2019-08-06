//
//  ViewController.m
//  MultiSceneTest
//
//  Created by adam on 7/6/19.
//  Copyright © 2019 adam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.label.text = self.view.window.windowScene.title;
}

- (IBAction)didTapNewScene:(id)sender {
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"whatever"];
    [UIApplication.sharedApplication requestSceneSessionActivation:nil userActivity:userActivity options:nil errorHandler:nil];
}

- (IBAction)didTapActivateExistingScene:(id)sender {
    
    UISceneSession *session = nil;
    if (UIApplication.sharedApplication.openSessions.count > 1) {
        // if there are any open sessions that aren't the current session, pick one
        NSArray *sessions = UIApplication.sharedApplication.openSessions.allObjects;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", self.view.window.windowScene.session];
        NSArray *otherSessions = [sessions filteredArrayUsingPredicate:predicate];
        
        NSUInteger i = arc4random() % otherSessions.count;
        session = otherSessions[i];
    }
    
    if (session) {
        // attempt to activate the session we found above
        [UIApplication.sharedApplication requestSceneSessionActivation:session userActivity:nil options:nil errorHandler:nil];
    } else {
        // show an error — there's no existing session to activate
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Scenes to Activate" message:@"Create at least one new scene before trying to activate." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
