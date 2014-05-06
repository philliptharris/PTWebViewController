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
    
    if ([segue.identifier isEqualToString:@"presentWebViewModally"]) {
        
        UINavigationController *vc = (UINavigationController *)segue.destinationViewController;
        PTWebViewController *webVC = (PTWebViewController *)[vc.viewControllers firstObject];
        webVC.urlString = @"http://www.apple.com";
    }
}

@end
