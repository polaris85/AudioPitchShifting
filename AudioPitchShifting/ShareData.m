//
//  ShareData.m
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/18/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData

@synthesize selectIndex,easterEggs,selectMusic,PlayListFlag,PlayAudioFlag,playListManager,homeUrl,currentMediaItems;

static ShareData *instance = nil;

+ (ShareData *)instance
{
	if (instance == nil)
	{
		instance = [[ShareData alloc] init];
	}
	return instance;
}

- (id) init
{
	if((self = [super init]))
	{
        self.selectIndex = -1;
        self.selectMusic = @"";
        self.PlayAudioFlag = NO;
        self.PlayListFlag = NO;
        self.easterEggs = NO;
        self.homeUrl = nil;
        self.currentMediaItems = [NSMutableArray arrayWithCapacity:0];
        self.playListManager =  [NSMutableArray arrayWithCapacity:0];
    }
	return self;
}

#pragma mark -

#pragma mark LifeCycle
- (void)loadPlayListManagerFromDisk {
  
    //get play list manager
    NSString *playListManagerFilePath = [ShareData pathForDocumentsDirectoryFile:@"playListManager.archive"];
    self.playListManager = [NSKeyedUnarchiver unarchiveObjectWithFile:playListManagerFilePath];
  
    if (self.playListManager == nil) {
        self.playListManager = [NSMutableArray arrayWithCapacity:0];
    }
}

- (void)savePlayListManagerToDisk {
    
    NSString *playListManagerFilePath = [ShareData pathForDocumentsDirectoryFile:@"playListManager.archive"];
    [NSKeyedArchiver archiveRootObject:self.playListManager toFile:playListManagerFilePath];
}

- (void)loadCurrentPlayListFromDisk:(NSString *)filename
{
    //get current play list
    NSString *playCurrentPlayListFilePath = [ShareData pathForDocumentsDirectoryFile:filename];
    self.currentMediaItems = [NSKeyedUnarchiver unarchiveObjectWithFile:playCurrentPlayListFilePath];
    
    if (self.currentMediaItems == nil) {
        self.currentMediaItems = [NSMutableArray arrayWithCapacity:0];
    }
}
- (void)saveCurrentPlayListToDisk:(NSString *)filename
{
    NSString *playCurrentPlayListFilePath = [ShareData pathForDocumentsDirectoryFile:filename];
    [NSKeyedArchiver archiveRootObject:self.currentMediaItems toFile:playCurrentPlayListFilePath];
    
}
#pragma mark -

#pragma mark helpers
+ (NSString *)pathForDocumentsDirectoryFile:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}
#pragma mark -


- (void)dealloc
{
   
    playListManager = nil;
    currentMediaItems = nil;
    selectMusic = nil;
    homeUrl = nil;
    [super dealloc];
}

@end
