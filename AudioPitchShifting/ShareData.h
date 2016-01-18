//
//  ShareData.h
//  AudioPitchShifting
//
//  Created by So Kyong Il on 9/18/13.
//  Copyright (c) 2013 So Kyong Il. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareData : NSObject
{
   
  
    NSURL *homeUrl;
    BOOL PlayAudioFlag;
    BOOL PlayListFlag;
    BOOL easterEggs;
    NSInteger selectIndex;
    NSString *selectMusic;
    NSMutableArray *currentMediaItems;;
    NSMutableArray *playListManager;
}


@property (nonatomic, retain) NSURL *homeUrl;
@property (nonatomic, assign) BOOL PlayAudioFlag;
@property (nonatomic, assign) BOOL PlayListFlag;
@property (nonatomic, assign) BOOL easterEggs;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, retain) NSString *selectMusic;

@property (nonatomic, retain) NSMutableArray *currentMediaItems;
@property (nonatomic, retain) NSMutableArray *playListManager;

+ (ShareData *)instance;

- (void)loadPlayListManagerFromDisk;
- (void)savePlayListManagerToDisk;
- (void)loadCurrentPlayListFromDisk:(NSString *)filename;
- (void)saveCurrentPlayListToDisk:(NSString *)filename;

+ (NSString *)pathForDocumentsDirectoryFile:(NSString*)filename;

@end
