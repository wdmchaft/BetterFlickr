//
//  Downloader.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/13/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate;

#pragma mark -
#pragma mark Downloader

// Mini Downloader clearly inspired from LazyImageTable's Code.
@interface Downloader : NSObject
{
	// The Object ID will be used to store valuable information when the delegate
	// is callback and the process is done downloading
    id _param;
	
	// The sender will also be sent back to the delegate in order for it
	// to know which view initiated the download
	id _sender;
	
    NSURL* _url;
    
    NSMutableData *_data;
    NSURLConnection *_connection;
	
	id <DownloaderDelegate> _delegate;
}

@property (nonatomic, retain) id param;
@property (nonatomic, retain) id sender;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, assign) id <DownloaderDelegate> delegate;

- (Downloader*)initWithSender:(id)iSender param:(id)iParam;

/*!
 * @method		startDownload:iURL
 * @abstract	Initiates any download given the passed URL
 * @param		iURL	The URL to get content from fetch
 */
- (void)startDownload:(NSURL*)iURL;

/*!
 * @method		startDownloadPhotoOfSize:
 * @abstract	Only Works with photo, fetches the photo information from the 
 *				letter passed in arguments (ex. OFFlickrSmallSquareSize)
 * @param		iSize	The letter representing the size of the image to fetch
 */
- (void)startDownloadPhotoOfSize:(NSString*)iSize;

- (void)cancelDownload;

@end

#pragma mark -
#pragma mark DownloaderDelegate

@protocol DownloaderDelegate 

/*!
 * @method		downloadDidComplete:sender:object:data
 * @abstract	Callback used when the download is completed
 * @param		iDownloader	The downloader that initiated the call
 * @param		iSender		The UIView* object that initiated the call
 * @param		iObj		An object passed during the call
 * @param		iData		The NSData retreived during the download
 */
- (void)downloadDidComplete:(Downloader*)iDownloader sender:(id)iSender object:(id)iObj data:(NSData*)iData;

@end