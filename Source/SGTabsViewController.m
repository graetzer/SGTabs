//
//  SGTabsViewController.m
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
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
@synthesize delegate, editableTabs = _editableTabs, tabsView = _tabsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
}

#pragma mark - Propertys

- (NSUInteger)maxTabs {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6 : 3;
}

- (void)setEditableTabs:(BOOL)editableTabs {
    for (SGTabView *tab in self.tabsView.tabs) {
        tab.editable = editableTabs;
    }
    editableTabs = editableTabs;
}

- (NSUInteger)count {
    return self.tabsView.tabs.count;
}

@end
