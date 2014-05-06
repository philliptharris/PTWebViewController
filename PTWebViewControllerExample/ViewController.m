//
//  ViewController.m
//  PTWebViewControllerExample
//
//  Created by Phillip Harris on 5/6/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "ViewController.h"

#import "PTWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//===============================================
#pragma mark -
#pragma mark Segue
//===============================================

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"modalSegue"]) {
        
        UINavigationController *vc = (UINavigationController *)segue.destinationViewController;
        PTWebViewController *webVC = (PTWebViewController *)[vc.viewControllers firstObject];
        webVC.urlString = @"http://www.apple.com";
    }
    else if ([segue.identifier isEqualToString:@"pushSegue"]) {
        
        PTWebViewController *webVC = (PTWebViewController *)segue.destinationViewController;
        webVC.urlString = @"http://www.apple.com";
    }
}

- (IBAction)presentWebView:(id)sender {
    
    PTWebViewController *webVC = [[PTWebViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:webVC];
    webVC.urlString = @"http://www.apple.com";
    [self presentViewController:nc animated:YES completion:nil];
}

- (IBAction)pushWebView:(id)sender {
    
    PTWebViewController *webVC = [[PTWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.urlString = @"http://www.apple.com";
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
