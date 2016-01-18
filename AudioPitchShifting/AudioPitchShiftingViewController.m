//
//  AudioPitchShiftingViewController.m
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/16/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import "AudioPitchShiftingViewController.h"
#import "ShareData.h"
#import "AudioHomeViewController.h"

@implementation AudioPitchShiftingViewController


//player.
@synthesize mDiracAudioPlayer;
@synthesize mediaPicker,pitchSwitch,playMusicButton;
@synthesize firstlabel,secondlabel,thirdlabel,forthlabel,timer;
@synthesize hideShowSharePanel,slider,sliderTimer;

-(IBAction)showLogoButtonDown:(UIButton *)showLogoButtonDown
{
    [showLogoButtonDown setImage:[UIImage imageNamed:@"logo_on.png"] forState:UIControlStateNormal];
}
//show play list management view controller

-(IBAction)showPlayListButtonDown:(UIButton *)playListButton
{
    [playListButton setImage:[UIImage imageNamed:@"music_on.png"] forState:UIControlStateNormal];
}
-(IBAction)showPlayList:(UIButton *)playListButton
{
    [playListButton setImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];
}
//complete ui action;
-(IBAction)showSharePanel:(UIButton *)shareButton
{
    if (mSocialPanelFlag == YES) {
        return;
    }
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
     CGRect frame = hideShowSharePanel.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
   
     frame.origin.x -=310;
     hideShowSharePanel.frame = frame;

    [UIView commitAnimations];
    mSocialPanelFlag = YES;
    
}

-(IBAction)showSharePanelButtonDown:(UIButton *)shareButton
{
    [shareButton setImage:[UIImage imageNamed:@"share_on.png"] forState:UIControlStateNormal];
}

//homes'delegate

- (void) touchesEnded:(NSSet *)_touches withEvent:(UIEvent *)_event
{
    if (mSocialPanelFlag == NO) {
        return;
    }
    CGRect frame = hideShowSharePanel.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    
    frame.origin.x +=310;
    hideShowSharePanel.frame = frame;
    [UIView commitAnimations];
    mSocialPanelFlag = NO;
}

-(IBAction)gotoFomePage:(UIButton *)sender
{
    
//    CGRect frame = hideShowSharePanel.frame;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.5];
//    
//    frame.origin.x +=300;
//    hideShowSharePanel.frame = frame;
//    [UIView commitAnimations];
    
    mSocialPanelFlag = NO;
    mHomepageShowFlag = YES;
    NSInteger buttonTag = sender.tag;
    switch (buttonTag)
    {
        case 0:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://frequency432.com"];      
            break;
        case 1:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://www.facebook.com/sharer.php?u=http://www.frequency432.com/"];
            break;
        case 2:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://twitter.com/share?url=http://www.frequency432.com/"];
            break;
        case 3:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"https://plus.google.com/share?url=http://www.frequency432.com/"];
            break;
        case 4:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://pinterest.com/pin/create/link/?url=http://www.frequency432.com/"];
            break;
        case 5:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://www.linkedin.com/shareArticle?mini=true&url=http://www.frequency432.com/"];
            break;
        case 6:
            [ShareData instance].homeUrl = [NSURL URLWithString:@"http://www.stumbleupon.com/submit?url=http://www.frequency432.com/"];
            break;          
        
    }
    
  
    
}

// DiracAudioPlayer's Delegate;
- (void)diracPlayerDidFinishPlaying:(DiracAudioPlayerBase*)player successfully:(BOOL)flag
{
    if (flag == NO ) {
        return;
    }
    
    [slider setValue:0];
    
    int count = [[ShareData instance].currentMediaItems count];

    if (mRepeatFlag == YES && index >= count-1 )
    {
        index = -1;
    }
    
    if (index < count -1 )
    {
        if (mRandomFlag == YES)
        {
           index = arc4random() % count;
        }
        else
        {
          index++;
        }
        
        MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
        NSURL *musicUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
        NSError *error = nil;
        
        mDiracAudioPlayer = [mDiracAudioPlayer initWithContentsOfURL: musicUrl channels:1 error:&error];
        
        [mDiracAudioPlayer setDelegate:self];
        [mDiracAudioPlayer setNumberOfLoops:0];
        
        if (mRetuneFlag == YES)
        {
            [mDiracAudioPlayer changePitch:0.9818181f]; // change the duration time of a 432hz
        }
        else
        {
            [mDiracAudioPlayer changePitch:1.0f]; // change the duration time of a 440hz
        }
        
        [mDiracAudioPlayer play];
        
         mPlayFlag = YES;
        [ShareData instance].PlayAudioFlag = YES;
    }
}


//repeat button
-(IBAction)repeatMusic:(UIButton*)repeatButton
{
    if (mRepeatFlag == YES) {
        mRepeatFlag = NO;
        [repeatButton setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    } else {
        mRepeatFlag = YES;
        [repeatButton setImage:[UIImage imageNamed:@"repeat_on.png"] forState:UIControlStateNormal];
    }
}

//random button
-(IBAction)randomMusic:(UIButton*)randomButton
{
    if (mRandomFlag == YES) {
        mRandomFlag = NO;
        [randomButton setImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
    } else {
        mRandomFlag = YES;
        [randomButton setImage:[UIImage imageNamed:@"random_on.png"] forState:UIControlStateNormal];
    }
}

//next button
-(IBAction)nextMusic:(UIButton*)nextButton
{
    [nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    
    int count = [[ShareData instance].currentMediaItems count];
    
    
    if (index < count -1 )
    {
        if (mRandomFlag == YES)
        {
            index = arc4random() % count;
        }
        else
        {
            index += 1;
        }
        [ShareData instance].selectIndex = index;
        MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
        NSURL *musicUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
        
        NSError *error = nil;
        
        
        if (mPlayFlag == YES)
        {
           [mDiracAudioPlayer stop];
        }
        
        
        mDiracAudioPlayer = [mDiracAudioPlayer initWithContentsOfURL: musicUrl channels:1 error:&error];
        
        [mDiracAudioPlayer setDelegate:self];
        [mDiracAudioPlayer setNumberOfLoops:0];
        
        if (mRetuneFlag == YES)
        {
            [mDiracAudioPlayer changePitch:0.9818181f]; // change the duration time of a 432hz
        }
        else
        {
            [mDiracAudioPlayer changePitch:1.0f]; // change the duration time of a 440hz
        }
        
        [mDiracAudioPlayer play];
        
        playPosition = 0;
        mPlayFlag = YES;
        [ShareData instance].PlayAudioFlag = YES;
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (playingInfoCenter) {
            
            
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            NSString *artist =[item valueForProperty:MPMediaItemPropertyArtist];
            if (artist == nil) {
                artist = @"Unknown Artist";
            }
            NSString *albumTitle =[item valueForProperty:MPMediaItemPropertyAlbumTitle];
            if (albumTitle == nil) {
                albumTitle = @"Unknown";
            }
            NSString *playbackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
            
            [songInfo setObject:[item valueForProperty:MPMediaItemPropertyTitle] forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:artist forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
            [songInfo setObject:playbackDuration forKey:MPMediaItemPropertyPlaybackDuration];
            [songInfo setObject:[item valueForProperty:MPMediaItemPropertyArtwork] forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            
            
        }
    }
    
}
-(IBAction)nextMusicButtonDown:(UIButton *)nextButtonDown
{
    [nextButtonDown setImage:[UIImage imageNamed:@"next_on.png"] forState:UIControlStateNormal];
}

//prev button
-(IBAction)prevMusic:(UIButton*)prevButton
{
    [prevButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    int count = [[ShareData instance].currentMediaItems count];
    
    if (index > 0 )
    {        
        if (mRandomFlag == YES)
        {
            index = arc4random() % count;
        }
        else
        {
            index -= 1;
        }
        
        [ShareData instance].selectIndex = index;
        MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
        NSURL *musicUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
        
        NSError *error = nil;
        
        if (mPlayFlag == YES)
        {
            [mDiracAudioPlayer stop];
        }
        
        mDiracAudioPlayer = [mDiracAudioPlayer initWithContentsOfURL: musicUrl channels:1 error:&error];
        
        [mDiracAudioPlayer setDelegate:self];
        [mDiracAudioPlayer setNumberOfLoops:0];
        
        if (mRetuneFlag == YES)
        {
            [mDiracAudioPlayer changePitch:0.9818181f]; // change the duration time of a 432hz
        }
        else
        {
            [mDiracAudioPlayer changePitch:1.0f]; // change the duration time of a 440hz
        }
        
        [mDiracAudioPlayer play];

        playPosition = 0;
        mPlayFlag = YES;
        [ShareData instance].PlayAudioFlag = YES;
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (playingInfoCenter) {
            
            
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            NSString *artist =[item valueForProperty:MPMediaItemPropertyArtist];
            if (artist == nil) {
                artist = @"Unknown Artist";
            }
            NSString *albumTitle =[item valueForProperty:MPMediaItemPropertyAlbumTitle];
            if (albumTitle == nil) {
                albumTitle = @"Unknown";
            }
            NSString *playbackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
            
            [songInfo setObject:[item valueForProperty:MPMediaItemPropertyTitle] forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:artist forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
            [songInfo setObject:playbackDuration forKey:MPMediaItemPropertyPlaybackDuration];
            [songInfo setObject:[item valueForProperty:MPMediaItemPropertyArtwork] forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            
            
        }
        
    }
}
-(IBAction)prevMusicButtonDown:(UIButton *)prevButtonDown
{
    [prevButtonDown setImage:[UIImage imageNamed:@"previous_on.png"] forState:UIControlStateNormal];
}


//status change
-(IBAction)changeStatus:(UISwitch *)sender
{
    if (mRetuneFlag == YES)
    {
        mRetuneFlag = NO;
       [mDiracAudioPlayer changePitch:1.0f];
        
    }
    else
    {
        mRetuneFlag = YES;
        [mDiracAudioPlayer changePitch:0.981818181f];
        
    }
}
//play button

-(IBAction)playMusicButtonDown:(UIButton*)playButtonDown
{
    if (mPlayFlag == NO)
    {
       [playButtonDown setImage:[UIImage imageNamed:@"play_on.png"] forState:UIControlStateNormal];
    }
    else
    {
       [playButtonDown setImage:[UIImage imageNamed:@"pause_on.png"] forState:UIControlStateNormal];
    }
    
}



-(IBAction)playMusic:(UIButton*)playButton
{
    if (mPlayFlag == NO)
    {
        if ([[ShareData instance].currentMediaItems count] < 1)
        {
            [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            return;
        }
        [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
      
    }
    else
    {
        [ShareData instance].PlayAudioFlag = NO;
        mPlayFlag = NO;
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];        
        [mDiracAudioPlayer pause];
        playPosition = [mDiracAudioPlayer currentTime];
        toatlSize = [mDiracAudioPlayer fileDuration];
        return;
    }
    
    if ([ShareData instance].selectIndex == -1)
    {
        index =0;
    }
    else
    {
        index = [ShareData instance].selectIndex;
    }
    
    
    MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
    NSURL *musicUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
    
    NSError *error = nil;
    
    
    if (playPosition > 0)
    {
        
        [mDiracAudioPlayer setCurrentTime:playPosition];        
    }
    else
    {
        mDiracAudioPlayer = [mDiracAudioPlayer initWithContentsOfURL: musicUrl channels:1 error:&error];
        
        [mDiracAudioPlayer setDelegate:self];
        [mDiracAudioPlayer setNumberOfLoops:0];
        
        if (mRetuneFlag == YES)
        {
            [mDiracAudioPlayer changePitch:0.9818181f]; // change the duration time of a 432hz
        }
        else
        {
            [mDiracAudioPlayer changePitch:1.0f]; // change the duration time of a 440hz
        }
    }
    [mDiracAudioPlayer play];
    
    
     mPlayFlag = YES;
    [ShareData instance].PlayAudioFlag = YES;
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter)
    {
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        NSString *artist =[item valueForProperty:MPMediaItemPropertyArtist];
        if (artist == nil) {
            artist = @"Unknown Artist";
        }
        NSString *albumTitle =[item valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (albumTitle == nil) {
            albumTitle = @"Unknown";
        }
        NSString *playbackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        
        [songInfo setObject:[item valueForProperty:MPMediaItemPropertyTitle] forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:artist forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:playbackDuration forKey:MPMediaItemPropertyPlaybackDuration];
        [songInfo setObject:[item valueForProperty:MPMediaItemPropertyArtwork] forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//slider animation.
-(IBAction)beginTouch:(id)sender
{
    mTouchFlag = YES;
}
-(IBAction)endTouch:(id)sender
{
    mTouchFlag = NO;
}

// animation
-(void)animationPlayName
{
    
    if (mPlayFlag == NO )
    {
        firstlabel.text = @"Please select music files!";
        secondlabel.text = @"Please select music files!";
        
    }
    else
    {
        MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
        NSString *musicTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *musicAlbumTitle = [item valueForProperty: MPMediaItemPropertyAlbumTitle];
        
        if (musicAlbumTitle == nil) {
            musicAlbumTitle = @"Unknown Album";
        }
        NSString *musicArtistName = [item valueForProperty: MPMediaItemPropertyArtist];
        if (musicArtistName == nil) {
            musicArtistName = @"Unknown Artist";
        }
        if ([ShareData instance].easterEggs == YES) {
            musicTitle = [[NSString alloc] initWithFormat:@"%@",@"Imagine"];
            musicArtistName = [[NSString alloc] initWithFormat:@"%@",@"Know thyself, remember what you are"];
        }
        firstlabel.text = [[NSString alloc] initWithFormat:@"%@",musicTitle];
        secondlabel.text = [[NSString alloc] initWithFormat:@"%@",musicArtistName];
      //  forthlabel.text = [[NSString alloc] initWithFormat:@"%@",musicAlbumTitle];
    }
    
    CGRect frame = firstlabel.frame;
    if (frame.origin.x < -310)
    {
        frame.origin.x = 319;
        [firstlabel setFrame:frame];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.4];
    frame.origin.x -=319;
    firstlabel.frame = frame;
    [UIView commitAnimations];
    
    CGRect frame1 = secondlabel.frame;
    if (frame1.origin.x < -310)
    {
        frame1.origin.x = 319;
        [secondlabel setFrame:frame1];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.4];
    frame1.origin.x -=319;
    secondlabel.frame = frame1;
    [UIView commitAnimations];
//    
//    CGRect frame2 = forthlabel.frame;
//    if (frame2.origin.x < -330)
//    {
//        frame2.origin.x = 319;
//        [forthlabel setFrame:frame2];
//    }
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.5];
//    frame2.origin.x -=319;
//    forthlabel.frame = frame2;
//    [UIView commitAnimations];
    
    if (mPlayFlag == YES)
    {
    
        int maxium = [mDiracAudioPlayer fileDuration];
        [slider setMinimumValue:0];
        [slider setMaximumValue:maxium];
        int ms = maxium % 60;
        thirdlabel.text = [[NSString alloc] initWithFormat:@"%d.%d",maxium/60 ,ms];
        if (mTouchFlag == NO)
        {
            int current = [mDiracAudioPlayer currentTime];
            [slider setValue:current animated:YES];
        }
        
        MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
        NSURL *musicTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        playFileName = [[NSString alloc] initWithFormat:@"%@",musicTitle];
    }
}

- (void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    NSLog(@"Session interrupted > --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan)
    {
       
        [self playMusic:playMusicButton];       
        
    }
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeEnded)
    {
        // make sure to activate the session
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        if (nil != error) NSLog(@"AVAudioSession set active failed with error: %@", error);
        
        [self playMusic:playMusicButton];
    }
}

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    NSLog(@"Route change:");
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"     NewDeviceAvailable");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"     OldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"     CategoryChange");
            NSLog(@" New Category: %@", [[AVAudioSession sharedInstance] category]);
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            NSLog(@"     Override");
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            NSLog(@"     WakeFromSleep");
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            NSLog(@"     NoSuitableRouteForCategory");
            break;
        default:
            NSLog(@"     ReasonUnknown");
    }
    
    NSLog(@"Previous route:\n");
    NSLog(@"%@", routeDescription);
  
    
    
}


- (void)viewDidLoad
{
       
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.

    NSError *error = nil;
    
    // Configure the audio session
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    
    // our default category -- we change this for conversion and playback appropriately
    [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    UInt32 doSetProperty = 0;
    AudioSessionSetProperty (kAudioSessionCategory_MediaPlayback,sizeof (doSetProperty), &doSetProperty );
    
    
    // we don't do anything special in the route change notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:sessionInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:sessionInstance];
    // activate the audio session
    [sessionInstance setActive:YES error:&error];

    timer = [NSTimer scheduledTimerWithTimeInterval: 1.5 target:self selector:@selector(animationPlayName) userInfo:nil repeats: YES];
   // [DiracAudioPlayer initSession];
    
    
    mediaItems = nil;
    
    mPlayFlag = NO;
    mTouchFlag = NO;
    mRepeatFlag = NO;
    mRandomFlag = NO;
    mRetuneFlag = YES;
    mSocialPanelFlag = NO;
    playPosition = 0;
    [ShareData instance].easterEggs = NO;
    mDiracAudioPlayer = [DiracAudioPlayer sharedManager];
}


// set current
-(IBAction)setCurrentPos:(UISlider*)sender
{
    if (mDiracAudioPlayer != nil)
    {
        int current = sender.value;
        [mDiracAudioPlayer pause];
        [mDiracAudioPlayer setCurrentTime:current];
        [mDiracAudioPlayer play];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([ShareData instance].easterEggs == YES)
    {      
        [playMusicButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        NSString *soundFilePath = [[NSBundle mainBundle]	pathForResource:	@"1"
                                                                  ofType:				@"mp3"];
        
        // Converts the sound's file path to an NSURL object
        NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
        NSError *error = nil;
        
        mDiracAudioPlayer = [mDiracAudioPlayer initWithContentsOfURL: musicUrl channels:1 error:&error];
        
        [mDiracAudioPlayer setDelegate:self];
        [mDiracAudioPlayer setNumberOfLoops:0];
        
        if (mRetuneFlag == YES)
        {
            [mDiracAudioPlayer changePitch:0.9818181f]; // change the duration time of a 432hz
        }
        else
        {
            [mDiracAudioPlayer changePitch:1.0f]; // change the duration time of a 440hz
        }
        
        [mDiracAudioPlayer play];
        
        
        mPlayFlag = YES;
        [ShareData instance].PlayAudioFlag = YES;
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (playingInfoCenter)
        {
            
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            
            NSString *artist =@"John Lennon";
            NSString *albumTitle =@"Imagine";
            NSString *playbackDuration = @"3:07";
            
//            UIImage *artImage =[[UIImage alloc] initWithContentsOfFile:@"flower-of-life.png"];
            
            
            [songInfo setObject:@"Imagine" forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:artist forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
            [songInfo setObject:playbackDuration forKey:MPMediaItemPropertyPlaybackDuration];
//            [songInfo setObject:artImage forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            [ShareData instance].easterEggs = NO;
            
        }
    }
    else
    {
        if ([ShareData instance].selectIndex != -1 && mHomepageShowFlag == NO)
        {
            if (mPlayFlag  == YES) {
                [mDiracAudioPlayer stop];
                mPlayFlag = NO;
            }
            playPosition = 0;
            [self playMusic:playMusicButton];
        }
    }
    mHomepageShowFlag = NO;
    [ShareData instance].PlayAudioFlag = NO;

    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set itself as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                

            case UIEventSubtypeRemoteControlPause:
                [self playMusic:playMusicButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self playMusic:playMusicButton];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self prevMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextMusic:nil];
                break;
                
            default:
                break;
        }
    }
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.//dis
}

- (void)dealloc {
   
	[mDiracAudioPlayer release];
    [mediaPicker release];
    mediaPicker = nil;
    mDiracAudioPlayer = nil;
    [sliderTimer release];
    [timer release];
    [super dealloc];
}

@end
