//
//  SGViewController.m
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

#import "SGViewController.h"
#import "SGTabsViewController.h"
@interface SGViewController ()

@end

@implementation SGViewController
@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.label.text = self.title;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:nil];
    UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
                                                                           target:self 
                                                                           action:@selector(remove:)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                         target:self 
                                                                         action:@selector(add:)];
    self.toolbarItems = [NSArray arrayWithObjects:space, trash, add, nil];
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"ViewDidDisappear");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    } else {
        return YES;
    }
}
                             
- (IBAction)remove:(id)sender {
    SGTabsViewController *tabs = (SGTabsViewController *) self.parentViewController;
    [tabs removeViewController:self];
}

- (IBAction)add:(id)sender {
    SGTabsViewController *tabs = (SGTabsViewController *) self.parentViewController;

    SGViewController *vc = [[SGViewController alloc] 
                            initWithNibName:NSStringFromClass([SGViewController class]) 
                            bundle:nil];
    vc.title = [NSString stringWithFormat:@"Tab %i contents!", tabs.count+1];
    [tabs addTab:vc];
    
}

@end
