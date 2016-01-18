//
//  AudioPitchShiftingViewController.h
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/16/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiracAudioPlayer.h"
#import "Dirac.h"

@interface AudioPitchShiftingViewController : UIViewController <MPMediaPickerControllerDelegate> 
{
    int index;
    int playPosition;
    int toatlSize;
        
    BOOL mPlayFlag;
    BOOL mTouchFlag;
    BOOL mRetuneFlag;
    BOOL mRepeatFlag;
    BOOL mRandomFlag;
    BOOL mSocialPanelFlag;
    BOOL mHomepageShowFlag;
    
    NSString *playFileName;
    
    NSTimer * timer;
    NSTimer *sliderTimer;
    
    IBOutlet UIView *hideShowSharePanel;
    IBOutlet UILabel *firstlabel;
    IBOutlet UILabel *secondlabel;
    IBOutlet UILabel *forthlabel;
    
    IBOutlet UILabel *thirdlabel;
    IBOutlet UISlider *slider;
    
    IBOutlet UIButton *playMusicButton;
    
    IBOutlet UISwitch *pitchSwitch;
	   

    MPMediaPickerController *mediaPicker;
    MPMediaItemCollection *mediaItems;

    DiracAudioPlayer *mDiracAudioPlayer;
}


@property (nonatomic,strong) DiracAudioPlayer *mDiracAudioPlayer;

@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) NSTimer * sliderTimer;

@property (nonatomic,retain) UISlider *slider;

@property (nonatomic,retain) UISwitch *pitchSwitch;

@property (nonatomic,retain) UILabel*firstlabel;
@property (nonatomic,retain) UILabel*secondlabel;
@property (nonatomic,retain) UILabel*thirdlabel;
@property (nonatomic,retain) UILabel *forthlabel;

@property (nonatomic,retain) UIButton *playMusicButton;

@property (nonatomic,retain) UIView *hideShowSharePanel;
@property (nonatomic,retain) MPMediaPickerController *mediaPicker;



-(IBAction)gotoFomePage:(UIButton *)sender;

//repeat button
-(IBAction)repeatMusic:(UIButton*)repeatButton;

//random button
-(IBAction)randomMusic:(UIButton*)randomButton;

//next button
-(IBAction)nextMusic:(UIButton*)nextButton;
-(IBAction)nextMusicButtonDown:(UIButton *)nextButtonDown;

//prev button
-(IBAction)prevMusic:(UIButton*)prevButton;
-(IBAction)prevMusicButtonDown:(UIButton *)prevButtonDown;

//play button
-(IBAction)playMusic:(UIButton*)playButton;
-(IBAction)playMusicButtonDown:(UIButton*)playButtonDown;

// UI action
-(IBAction)showSharePanel:(UIButton *)shareButton;
-(IBAction)showSharePanelButtonDown:(UIButton *)shareButton;

// PlayList management.
-(IBAction)showPlayList:(UIButton *)playListButton;
-(IBAction)showPlayListButtonDown:(UIButton *)playListButton;

// logo action
-(IBAction)showLogoButtonDown:(UIButton *)showLogoButtonDown;

// animation
-(void)animationPlayName;
-(IBAction)beginTouch:(id)sender;
-(IBAction)endTouch:(id)sender;

// set current
-(IBAction)setCurrentPos:(UISlider*)sender;

// 440/432 button
-(IBAction)changeStatus:(UISwitch *)sender;

@end