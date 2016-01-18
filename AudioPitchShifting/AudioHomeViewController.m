//
//  AudioHomeViewController.m
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/20/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import "AudioHomeViewController.h"
#import "ShareData.h"

@interface AudioHomeViewController ()

@end

@implementation AudioHomeViewController

@synthesize myHomeView;
@synthesize toolbar;
@synthesize back ;
@synthesize forward ;
@synthesize refresh ;
@synthesize stop ;

-(IBAction)backApplication:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)updateButtons
{
    self.forward.enabled = self.myHomeView.canGoForward;
    self.back.enabled = self.myHomeView.canGoBack;
    self.stop.enabled = self.myHomeView.loading;
}

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
        
    self.myHomeView.delegate = self;
    self.myHomeView.scalesPageToFit = YES;
    NSURL* url = [ShareData instance].homeUrl;
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.myHomeView loadRequest:request];
    [self updateButtons];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [myHomeView release];    
    [super dealloc];
}
@end
