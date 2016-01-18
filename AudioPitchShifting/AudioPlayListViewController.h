//
//  AudioPlayListViewController.h
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/29/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaPickerController.h>

@interface AudioPlayListViewController : UIViewController< UITableViewDataSource , UITableViewDelegate , MPMediaPickerControllerDelegate , UIAlertViewDelegate >
{
    MPMediaPickerController *mediaPicker;
    MPMediaItemCollection *mediaItems;
    IBOutlet UITableView *musicTable;    
}

@property(nonatomic,retain) MPMediaPickerController *mediaPicker;
@property(nonatomic,retain) UITableView *musicTable;

-(IBAction)returnHome:(id)sender;
-(IBAction)returnHomeButtonDown:(UIButton *)returnHomeButton;
//select music
-(IBAction)selectMusic:(UIButton*)selectMusicButton;
-(IBAction)selectMusicButtonDown:(UIButton*)selectMusicButton;
//save music list
-(IBAction)saveMusicList:(UIButton *)saveMusicListButton;
-(IBAction)saveMusicListButtonDown:(UIButton *)saveMusicListButtonDown;
//show music list
-(IBAction)showMusicList:(UIButton*)musicButton;
-(IBAction)showMusicListButtonDown:(UIButton*)musicButton;
@end
