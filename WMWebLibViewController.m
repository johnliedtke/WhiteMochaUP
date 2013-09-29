//
//  WMWebLibViewController.m
//  WhiteMochaUP
//
//  Created by John Liedtke on 9/27/13.
//
//

#import "WMWebLibViewController.h"

@interface WMWebLibViewController ()

@end

@implementation WMWebLibViewController

-(void)loadView
{
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    // Tell the web view to scale web content to fit within bounds of webview
    //[wv setScalesPageToFit:NO];
    //[wv stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];
    
    [self setView:wv];
}

- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

@end
