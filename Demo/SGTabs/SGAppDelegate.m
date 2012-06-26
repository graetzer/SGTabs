//
//  SGAppDelegate.m
//  SGTabs
//
//  Created by simon on 07.06.12.
//
//
//  Copyright (c) 2012 Simon Grätzer
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "SGAppDelegate.h"

#import "SGViewController.h"

@implementation SGAppDelegate

@synthesize window = _window;
@synthesize tabController = _tabController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.tabController = [[SGTabsViewController alloc] init];
    self.tabController.delegate = self;
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    
    [self performSelector:@selector(openTab) withObject:nil afterDelay:1];

    return YES;
}

- (void)openTab {
    [self.tabController setToolbarHidden:NO animated:YES];
    SGViewController *vc = [[SGViewController alloc] 
                            initWithNibName:NSStringFromClass([SGViewController class]) 
                            bundle:nil];
    [self.tabController addTab:vc];
}

- (BOOL)canRemoveTab:(UIViewController *)viewController {
        return self.tabController.count > 1;
}
@end
