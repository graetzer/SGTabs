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
#import "UIViewController+TabsController.h"
#import "SGURLProtocol.h"
@interface SGViewController ()

@end

@implementation SGViewController
@synthesize webView = _webView, textField = _textField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 400.0, 30.0)];
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.text = @"http://www.google.com";
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    [self textFieldDidEndEditing:self.textField];
    
    UIBarButtonItem *urlBar = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:nil];
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self action:@selector(reload:)]; 
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                         target:self 
                                                                         action:@selector(add:)];

    
    self.toolbarItems = [NSArray arrayWithObjects:space,urlBar,space,reload,add,nil];
    [SGURLProtocol registerProtocol];
}

- (void)viewDidUnload
{
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    [SGURLProtocol unregisterProtocol];
    [self setTextField:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewDidAppear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
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
    
    if (navigationType != UIWebViewNavigationTypeOther) {
        NSString *title = [request.URL absoluteString];
        self.title = title;
        
        self.textField.text = title;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSString *title = [self.webView.request.URL absoluteString];
    self.title = title;
    
    self.textField.text = title;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text lowercaseString];
    if (![text hasPrefix:@"http://"] && ![text hasPrefix:@"https://"]) {
        text = [NSString stringWithFormat:@"http://%@", text];
    }
    
    self.title = text;
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

    SGViewController *vc = [[SGViewController alloc] 
                            initWithNibName:NSStringFromClass([SGViewController class]) 
                            bundle:nil];
    vc.title = [NSString stringWithFormat:@"Tab %i contents!", self.tabsViewController.count+1];
    [self.tabsViewController addTab:vc];
    
}
@end
