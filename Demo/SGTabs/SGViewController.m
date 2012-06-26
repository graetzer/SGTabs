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
@synthesize webView, textField = _textField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300.0, 25.0)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.text = @"http://www.google.com";
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    [self textFieldDidEndEditing:self.textField];
    
    UIBarButtonItem *urlBar = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:nil];
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self action:@selector(reload:)]; 
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                         target:self 
                                                                         action:@selector(add:)];

    
    self.toolbarItems = [NSArray arrayWithObjects:space,urlBar,space2,reload,add,nil];
    
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    } else {
        return YES;
    }
}

-  (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *title = [request.URL absoluteString];
    if (![self.title isEqualToString:title]) {
        self.title = title;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
        self.textField.text = title;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text lowercaseString];
    if (![text hasPrefix:@"http://"] && ![text hasPrefix:@"https://"]) {
        text = [NSString stringWithFormat:@"http://%@", text];
    }
    
    NSURL *url = [NSURL URLWithString:text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLCacheStorageAllowedInMemoryOnly 
                                         timeoutInterval:10.];
    [self.webView loadRequest:request];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)reload:(id)sender {
    [self.webView reload];
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
