//
//  AudioHomeViewController.h
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/20/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioHomeViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView * myHomeView;
    UIToolbar* mToolbar;
    UIBarButtonItem* mBack;
    UIBarButtonItem* mForward;
    UIBarButtonItem* mRefresh;
    UIBarButtonItem* mStop;
}

@property (nonatomic, retain) IBOutlet UIWebView *myHomeView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* stop;

-(IBAction)backApplication:(id)sender;
- (void)updateButtons;

@end
