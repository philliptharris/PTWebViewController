//
//  PTWebViewController.h
//  PTWebViewControllerExample
//
//  Created by Phillip Harris on 5/6/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *urlString;

@end
