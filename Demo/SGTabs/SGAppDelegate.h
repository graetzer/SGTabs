//
//  SGAppDelegate.h
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGTabsViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate> {
    NSTimer *timer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGTabsViewController *viewController;

@end
