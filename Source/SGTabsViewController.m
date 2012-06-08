//
//  SGTabsViewController.m
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

#import "SGTabsViewController.h"
#import "SGTabsTopView.h"
#import "SGTabsView.h"
#import "SGTabView.h"

#define kTabsTopViewHeigth 7.5
#define kTabsHeigth  35.0

@interface SGTabsViewController ()

@end

@implementation SGTabsViewController
@synthesize delegate, editable = _editable, tabsView = _tabsView;

- (id)initEditable:(BOOL)editable {
    if (self = [super init]) {
        _editable = editable;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.tabsView resizeTabs];
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGRect bounds = self.view.bounds;
    
    CGRect frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, kTabsTopViewHeigth);
    _topView = [[SGTabsTopView alloc] initWithFrame:frame];
    
    frame = CGRectMake(bounds.origin.x, kTabsTopViewHeigth, bounds.size.width, kTabsHeigth);
    _tabsView = [[SGTabsView alloc] initWithFrame:frame];
    _tabsView.tabsController = self;
    
    [self.view addSubview:_topView];
    [self.view addSubview:_tabsView];
}

- (NSUInteger)addBlankTab:(NSString *)title {
    [self.tabsView addTab:title];
    return [self.tabsView.tabs count];
}

- (void)addTabwithContent:(UIViewController *)viewController {
    
}

- (void)showTab:(NSUInteger)index {
    self.tabsView.selected = index;
}

- (void)removeTab:(NSUInteger)index {
    
}

#pragma mark - Propertys

- (NSUInteger)maxTabs {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6 : 3;
}

- (NSUInteger)count {
    return self.tabsView.tabs.count;
}

@end
