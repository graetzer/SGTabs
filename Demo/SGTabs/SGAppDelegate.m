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
#import "SGTabsViewController.h"

@implementation SGAppDelegate

@synthesize window = _window;
@synthesize tabController = _tabController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[SGViewController alloc] initWithNibName:@"SGViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[SGViewController alloc] initWithNibName:@"SGViewController_iPad" bundle:nil];
//    }
    
    self.tabController = [[SGTabsViewController alloc] initEditable:YES];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    [self openTab];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(openTab) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)openTab {
    if (3 > self.tabController.count) { // You can add up to tabController.maxCount Tabs
        SGViewController *vc = [[SGViewController alloc] 
                                initWithNibName:NSStringFromClass([SGViewController class]) 
                                bundle:nil];
        vc.title = [NSString stringWithFormat:@"Tab %i content", self.tabController.count+1];
        [self.tabController addTab:vc];
    }
}

@end
