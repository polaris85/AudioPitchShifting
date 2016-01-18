//
//  AudioPlayListViewController.m
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/29/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import "AudioPlayListViewController.h"
#import "ShareData.h"

@interface AudioPlayListViewController ()

@end

@implementation AudioPlayListViewController

@synthesize mediaPicker,musicTable;

//show music list
-(IBAction)showMusicList:(UIButton*)musicButton
{
    [musicButton setImage:[UIImage imageNamed:@"play_list_on.png"] forState:UIControlStateNormal];
}
-(IBAction)showMusicListButtonDown:(UIButton*)musicButton
{
    [musicButton setImage:[UIImage imageNamed:@"play_list_on.png"] forState:UIControlStateNormal];
}

//save music list
-(IBAction)saveMusicList:(UIButton *)saveMusicListButton
{
    
    [saveMusicListButton setImage:[UIImage imageNamed:@"save_playlist.png"] forState:UIControlStateNormal];
    if ([[ShareData instance].currentMediaItems count] == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add Playlist?"
                                                          message:@"Please select music files"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add Playlist?"
                                                      message:@"Please enter playlist name"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        NSString *filename = [[NSString alloc]initWithFormat:@"%@.archive",inputText];
        [[ShareData instance] loadPlayListManagerFromDisk];
        [[ShareData instance].playListManager addObject:filename];
        [[ShareData instance] savePlayListManagerToDisk];
        
        [[ShareData instance] saveCurrentPlayListToDisk:filename];
        
    }
}


-(IBAction)saveMusicListButtonDown:(UIButton *)saveMusicListButtonDown
{
    [saveMusicListButtonDown setImage:[UIImage imageNamed:@"save_playlist_on.png"] forState:UIControlStateNormal];
}
//select music
-(IBAction)selectMusic:(UIButton*)selectMusicButton
{
    [selectMusicButton setImage:[UIImage imageNamed:@"music_select.png"] forState:UIControlStateNormal];
    
    if ([ShareData instance].PlayAudioFlag == YES) {
        if ([ShareData instance].PlayAudioFlag == YES) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                              message:@"Please stop player and select songs"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles: nil];
            [message show];
            return;
        }
        return;
    }
    //pick the music list of ipod by using MPMediaPickerController.
    mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    [mediaPicker setDelegate:self];
    [mediaPicker setAllowsPickingMultipleItems:YES];
    [mediaPicker setPrompt:NSLocalizedString(@"Please select a song to play","Prompt in media item picker")];
    
    @try
    {
        [self presentViewController:mediaPicker animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!",@"Error title")
                                    message:NSLocalizedString(@"The music library is not available.",@"Error message when MPMediaPickerController fails to load")
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }    
    
    
}

// MPMeidaPickerController's delegate
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion: NULL];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection
{
    //get the music list that user select in the picker controller.
    [self dismissViewControllerAnimated:YES completion: NULL];
    if (mediaItems != nil) {
        [mediaItems release];
        mediaItems = nil;
    }
    mediaItems = [collection retain];
    
    int count = [mediaItems count];
    if ([[ShareData instance].currentMediaItems count] !=0 )
    {
        [[ShareData instance].currentMediaItems removeAllObjects];
    }
    
    for (int i = 0; i < count; i++)
    {
        MPMediaItem *item = [[mediaItems items] objectAtIndex:i];
        [[ShareData instance].currentMediaItems addObject:item];
    }
    [self.musicTable reloadData];
}

-(IBAction)selectMusicButtonDown:(UIButton*)selectMusicButton
{
    [selectMusicButton setImage:[UIImage imageNamed:@"music_select_on.png"] forState:UIControlStateNormal];
}
//UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ShareData instance].currentMediaItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      
        // create a music name label:      x    y   width  height
        UILabel *musicName = [[UILabel alloc] initWithFrame:CGRectMake(87.0, 0.0, 214.0, 34.0)];
        [musicName setTag:101];
        [musicName setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [musicName setFont:[UIFont systemFontOfSize:20.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:musicName];
        [musicName release];
        
        // create a music detail label:      x    y   width  height
        UILabel *musicDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(87.0, 33.0, 106.0, 21.0)];
        [musicDetailLabel setTag:102];
        [musicDetailLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [musicDetailLabel setFont:[UIFont systemFontOfSize:15.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:musicDetailLabel];
        [musicDetailLabel release];
        
        // create a artist  label:      x    y   width  height
        UILabel *atristName = [[UILabel alloc] initWithFrame:CGRectMake(201.0, 33.0, 114.0, 21.0)];
        [atristName setTag:103];
        [atristName setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [atristName setFont:[UIFont systemFontOfSize:15.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:atristName];
        [atristName release];
        
        // create a album image :      x    y   width  height
        UIImageView *albumImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 0.0, 59.0, 59.0)];
        [albumImage setTag:100];
        [cell.contentView addSubview:albumImage];
        [albumImage release];
        
    }
    
    int index = [indexPath row];
    //setting the music name.
    MPMediaItem *item = [[ShareData instance].currentMediaItems objectAtIndex:index];
    
    NSString *musicTitle = [item valueForProperty: MPMediaItemPropertyTitle];
    NSString *musicArtist = [item valueForProperty: MPMediaItemPropertyArtist];
    if (musicArtist == nil)
    {
        musicArtist = @"unknown artist";
    }
    NSString *musicAlbumTitle = [item valueForProperty: MPMediaItemPropertyAlbumTitle];
    if (musicAlbumTitle == nil)
    {
        musicAlbumTitle = @"unknown album";
    }
    UIImage *artworkImage=nil;
    artworkImage=[[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(59, 59)];
    
    [(UILabel *)[cell.contentView viewWithTag:101] setText:musicTitle];
    [(UILabel *)[cell.contentView viewWithTag:103] setText:musicAlbumTitle];
    [(UILabel *)[cell.contentView viewWithTag:102] setText:musicArtist];
    [(UIImageView *)[cell.contentView viewWithTag:100] setImage:artworkImage];
   
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    [ShareData instance].selectIndex = row;
    [ShareData instance].easterEggs = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)returnHome:(id)sender
{
    [ShareData instance].easterEggs = NO;
    [ShareData instance].selectIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];

}
-(IBAction)returnHomeButtonDown:(UIButton *)returnHomeButton
{
    [returnHomeButton setImage:[UIImage imageNamed:@"exit_on.png"] forState:UIControlStateNormal];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.musicTable reloadData];
    if ([ShareData instance].easterEggs == YES )
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    if ([ShareData instance].PlayListFlag == YES) {
        
        [ShareData instance].selectIndex = 0;
        [ShareData instance].PlayListFlag = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
