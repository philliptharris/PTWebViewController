//
//  PTWebViewController.m
//  PTWebViewControllerExample
//
//  Created by Phillip Harris on 5/6/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "PTWebViewController.h"

@interface PTWebViewController ()

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonTapped:)];
    self.toolbarItems = @[backButton];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:194.0/255.0 alpha:1.0]; // Apple uses this in Safari on iPhone.
    
    if (!self.webView.loading && self.urlString) {
        [self loadRequestFromURLString];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
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

- (void)backButtonTapped:(id)test {
    
}

//
// Copied from https://github.com/TimOliver/TOWebViewController
//
- (UIColor *)webViewPageBackgroundColor {
    
    //Pull the current background colour from the web view
    NSString *rgbString = [self.webView stringByEvaluatingJavaScriptFromString:@"window.getComputedStyle(document.body,null).getPropertyValue('background-color');"];
    
    NSLog(@"rgbString = %@", rgbString);
    
    //if it wasn't found, or if it isn't a proper rgb value, just return white as the default
    if (!rgbString || [rgbString length] == 0 || [rgbString rangeOfString:@"rgb"].location == NSNotFound) {
        return [UIColor whiteColor];
    }
    
    //Assuming now the input is either 'rgb(255, 0, 0)' or 'rgba(255, 0, 0, 255)'
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"rgba() "];
    rgbString = [rgbString stringByTrimmingCharactersInSet:characterSet];
    NSArray *components = [rgbString componentsSeparatedByCharactersInSet:characterSet];
//    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    rgbString = [components componentsJoinedByString:@""];
    
//    //remove the 'rgba' componenet
//    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"rgba" withString:@""];
//    //conversely, remove the 'rgb' component
//    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"rgb" withString:@""];
//    //remove the brackets
//    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    rgbString = [rgbString stringByReplacingOccurrencesOfString:@")" withString:@""];
//    //remove all spaces
//    rgbString = [rgbString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // we should now have something like '0,0,0'. Split it up via the commas
    NSArray *rgbaComponents = [rgbString componentsSeparatedByString:@","];
    
    // Final output componenets
    CGFloat red, green, blue, alpha = 1.0f;
    
    // if the alpha value is 0, this indicates the RGB value wasn't actually set in the page, so just return white
    if ([rgbaComponents count] < 3 || ([rgbaComponents count] >= 4 && [[rgbaComponents objectAtIndex:3] integerValue] == 0)) {
        return [UIColor whiteColor];
    }
    
    red = (CGFloat)[[rgbaComponents objectAtIndex:0] integerValue] / 255.0f;
    green = (CGFloat)[[rgbaComponents objectAtIndex:1] integerValue] / 255.0f;
    blue = (CGFloat)[[rgbaComponents objectAtIndex:2] integerValue] / 255.0f;
    
    if ([rgbaComponents count] >= 4) {
        alpha = (CGFloat)[[rgbaComponents objectAtIndex:3] integerValue] / 255.0f;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//===============================================
#pragma mark -
#pragma mark UIWebViewDelegate
//===============================================

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
