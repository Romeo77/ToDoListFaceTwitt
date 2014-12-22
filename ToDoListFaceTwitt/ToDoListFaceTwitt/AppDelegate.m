//
//  AppDelegate.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property(weak, readonly) UIStoryboard *storyboard;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"VmuluokPJebDy21ZFzvBVnCmk4FOI5zSlFyQo3EE"
                  clientKey:@"yalQa9Uy5FkXc5zEGPJrHhOxZtjBw3dlOFws1xpU"];
    
    [PFFacebookUtils initializeFacebook];
    
    [PFTwitterUtils initializeWithConsumerKey:@"YyvoW8VelrqrlO8f91xEvxdNe"
                               consumerSecret:@"gLZI37ssGqUcwr2RZlFoVcu5PO3rM0vodZ0teo3UuMLSdVoY1d"];
    
    
    
    if([PFUser currentUser].isAuthenticated || [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] || [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        [self setNewRootVc:[self createToDoNavVc]animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidLogin) name:notificationLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidLogout) name:notificationLogout object:nil];
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    return YES;
}

- (id) createToDoNavVc {
    
    return [self.storyboard instantiateViewControllerWithIdentifier:@"todoNav"];
}

- (void)userDidLogin{
    
    [self setNewRootVc:[self createToDoNavVc]animated:YES];
}

- (void)userDidLogout{
    
    [self setNewRootVc:[self.storyboard instantiateInitialViewController]animated:YES];
}

- (void) setNewRootVc:(UIViewController *)newVc animated:(BOOL)animated{
    
    if(!animated) {
        
        self.window.rootViewController = newVc;
        return;
    }
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:newVc.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:^(BOOL finished) {
                        if(!finished)return ;
                        self.window.rootViewController = newVc;
                    }];
    
    
}

-(UIStoryboard*)storyboard{
    
    return self.window.rootViewController.storyboard;
    
}

#pragma Facebook applications

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url   sourceApplication:(NSString *)sourceApplication          annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[PFFacebookUtils session] close];
}

@end
