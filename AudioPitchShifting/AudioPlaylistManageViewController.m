//
//  AudioPlaylistManageViewController.m
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/30/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import "AudioPlaylistManageViewController.h"
#import "ShareData.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AudioPlaylistManageViewController ()

@end

@implementation AudioPlaylistManageViewController

@synthesize table;

//delete button
-(IBAction)deleteMusicList:(UIButton*)deleteMusicButton
{
    [deleteMusicButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    if ([ShareData instance].PlayAudioFlag == YES) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"Please stop player"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles: nil];
        [message show];
        return;
    }
    if (select != -1)
    {
        deleteFlag = YES;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rename Playlist?"
                                                          message:@"Please enter playlist name"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok", nil];
        [message show];
    }
}
-(IBAction)deleteMusicListButtonDown:(UIButton*)deleteMusicButton
{
    [deleteMusicButton setImage:[UIImage imageNamed:@"delete_on.png"] forState:UIControlStateNormal];
}

//edit button
-(IBAction)editMusicList:(UIButton *)editMusicButton
{
    
    [editMusicButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    
    if ([ShareData instance].PlayAudioFlag == YES) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"Please stop player"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles: nil];
        [message show];
        return;
    }
    
    if (select == -1) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rename Playlist?"
                                                          message:@"Please select playlist"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles: nil];
        [message show];
        return;
    }
    
        
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rename Playlist?"
                                                      message:@"Please enter playlist name"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
 
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        if (deleteFlag == YES) {
            NSString *filename = [[ShareData instance].playListManager objectAtIndex:select];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            BOOL fileExists;
            
            fileExists = [fileManager fileExistsAtPath:[ShareData pathForDocumentsDirectoryFile:filename]];
            
            NSLog(@"File exists: %d", fileExists);
            if (fileExists)
            {
                BOOL success = [fileManager removeItemAtPath:[ShareData pathForDocumentsDirectoryFile:filename] error:&error];
                if (!success) NSLog(@"Error: %@", [error localizedDescription]);
            }
            [[ShareData instance].playListManager removeObjectAtIndex:select];
            [[ShareData instance] savePlayListManagerToDisk];
            [self.table reloadData];
            select = -1;
            [ShareData instance].PlayListFlag = NO;
            
            [[ShareData instance].currentMediaItems removeAllObjects];
            deleteFlag = NO;
            return;
        }
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        NSString *filerename = [[NSString alloc]initWithFormat:@"%@.archive",inputText];
        
        NSString *filename = [[ShareData instance].playListManager objectAtIndex:select];
        
        if ([inputText isEqualToString:@"*Awaken*"])
        {
            [ShareData instance].easterEggs = YES;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            BOOL fileExists;
        
            fileExists = [fileManager fileExistsAtPath:[ShareData pathForDocumentsDirectoryFile:filename]];
            
            NSLog(@"File exists: %d", fileExists);
            if (fileExists)
            {
                BOOL success = [fileManager removeItemAtPath:[ShareData pathForDocumentsDirectoryFile:filename]     error:&error];
                if (!success) NSLog(@"Error: %@", [error localizedDescription]);
            }
        
            [[ShareData instance].playListManager removeObjectAtIndex:select];
            [[ShareData instance].playListManager addObject:filerename];
            [[ShareData instance] saveCurrentPlayListToDisk:filerename];
            [[ShareData instance] savePlayListManagerToDisk];
            [self.table reloadData];
            select = -1;
            [ShareData instance].PlayListFlag = NO;
        }
    }
    
    deleteFlag = NO;
}

-(IBAction)editMusicListButtonDown:(UIButton *)editMusicButton
{
    [editMusicButton setImage:[UIImage imageNamed:@"edit_on.png"] forState:UIControlStateNormal];
}

//back button
-(IBAction)back:(UIButton*)backButton
{
    [backButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [ShareData instance].easterEggs = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)backButtonDown:(UIButton*)backButtonDown
{
    [backButtonDown setImage:[UIImage imageNamed:@"exit_on.png"] forState:UIControlStateNormal];
}
//UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [[ShareData instance] loadPlayListManagerFromDisk];
    int count = [[ShareData instance].playListManager count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    NSString *string = [[ShareData instance].playListManager  objectAtIndex:indexPath.row];
    NSArray *extlist = [string componentsSeparatedByString:@"."];
  
    NSString *listName = [extlist firstObject];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",listName];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = [indexPath row];
    int index = [indexPath row];
    NSString *filename = [[ShareData instance].playListManager objectAtIndex:index];
    [[ShareData instance] loadCurrentPlayListFromDisk:filename];
    select  =  index;
    [ShareData instance].easterEggs = NO;
    [ShareData instance].PlayListFlag = YES;
   
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
    select = -1;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
