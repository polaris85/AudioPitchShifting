//
//  AudioPlaylistManageViewController.h
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/30/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlaylistManageViewController : UIViewController<UITableViewDataSource , UITableViewDelegate, UIAlertViewDelegate>
{
    BOOL deleteFlag;
    NSInteger select;
    IBOutlet UITableView *table;
}
@property(nonatomic,retain) UITableView *table;
// back button
-(IBAction)back:(UIButton*)backButton;
-(IBAction)backButtonDown:(UIButton*)backButtonDown;

//delete button
-(IBAction)deleteMusicList:(UIButton*)deleteMusicButton;
-(IBAction)deleteMusicListButtonDown:(UIButton*)deleteMusicButton;

//edit button
-(IBAction)editMusicList:(UIButton *)editMusicButton;
-(IBAction)editMusicListButtonDown:(UIButton *)editMusicButton;
@end
