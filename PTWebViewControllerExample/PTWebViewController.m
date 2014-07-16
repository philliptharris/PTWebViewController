//
//  PTWebViewController.m
//  PTWebViewControllerExample
//
//  Created by Phillip Harris on 5/6/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "PTWebViewController.h"

@interface PTWebViewController ()

@property (nonatomic, strong) NSMutableArray *mutableToolbarItems;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *shareButton;
@property (nonatomic, strong) UIBarButtonItem *reloadButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;

@end

@implementation PTWebViewController

//===============================================
#pragma mark -
#pragma mark Setters
//===============================================

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if (!self.webView) {
        return;
    }
    [self loadRequestFromURLString];
}

//===============================================
#pragma mark -
#pragma mark Initialization
//===============================================

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

//===============================================
#pragma mark -
#pragma mark View Methods
//===============================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.webView) {
        [self createTheWebView];
    }
    
    [self setupToolbar];
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:194.0/255.0 alpha:1.0]; // Apple uses this background color in Safari for iPhone.
    
    if (!self.webView.loading && self.urlString) {
        [self loadRequestFromURLString];
    }
}

/// If this view controller was instantiated using a nib or Storyboard with the webView added as a subview of view and connected to the IBOutlet, then we don't have to use this. Otherwise we do.
- (void)createTheWebView {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
}

- (void)setupToolbar {
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftArrow"] style:UIBarButtonItemStyleBordered target:self.webView action:@selector(goBack)];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightArrow"] style:UIBarButtonItemStyleBordered target:self.webView action:@selector(goForward)];
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.webView action:@selector(reload)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self.webView action:@selector(stopLoading)];
    
    NSArray *allButtons = @[self.backButton, self.forwardButton, self.shareButton, self.reloadButton];
    NSMutableArray *mutableToolbarItems = [NSMutableArray array];
    [allButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != 0) {
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [mutableToolbarItems addObject:flexibleSpace];
        }
        [mutableToolbarItems addObject:obj];
    }];
    
    self.mutableToolbarItems = mutableToolbarItems;
    
    self.toolbarItems = mutableToolbarItems;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [self enableOrDisableBackAndForwardButtons];
}

//===============================================
#pragma mark -
#pragma mark Actions
//===============================================

- (void)loadRequestFromURLString {
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)share {
    
    NSURL *URLtoShare = [self.webView.request URL];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[URLtoShare] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

//===============================================
#pragma mark -
#pragma mark UIWebViewDelegate
//===============================================

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"🔄");
    
    [self showTheStopButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"✅");
    
    [self showTheReloadButton];
    
    [self enableOrDisableBackAndForwardButtons];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"❌ | %@", [error localizedDescription]);
    
    [self showTheReloadButton];
    
    [self enableOrDisableBackAndForwardButtons];
}

//===============================================
#pragma mark -
#pragma mark Toolbar Management
//===============================================

- (void)showTheReloadButton {
    
    NSUInteger index = [self.mutableToolbarItems indexOfObject:self.stopButton];
    if (index != NSNotFound) {
        [self.mutableToolbarItems replaceObjectAtIndex:index withObject:self.reloadButton];
    }
    
    [self setToolbarItems:[NSArray arrayWithArray:self.mutableToolbarItems] animated:YES];
}

- (void)showTheStopButton {
    
    NSUInteger index = [self.mutableToolbarItems indexOfObject:self.reloadButton];
    if (index != NSNotFound) {
        [self.mutableToolbarItems replaceObjectAtIndex:index withObject:self.stopButton];
    }
    
    [self setToolbarItems:[NSArray arrayWithArray:self.mutableToolbarItems] animated:YES];
}

- (void)enableOrDisableBackAndForwardButtons {
    
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

@end
