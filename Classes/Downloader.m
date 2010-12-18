//
//  Downloader.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/13/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "Downloader.h"

#import "BetterFlickrAppDelegate.h"

#import "DBPhoto.h"
#import "DBPhotoAccessor.h"

@implementation Downloader

@synthesize param	= _param;
@synthesize sender	= _sender;
@synthesize delegate = _delegate;
@synthesize url	 = _url;

//@synthesize data = _data;
//@synthesize connnection = _connection;

- (Downloader*)initWithSender:(id)iSender param:(id)iParam
{
REQUIRE(iSender != nil)
REQUIRE(iParam != nil)
	
	if (self = [super init])
	{
		_param	= [iParam retain];
		_sender = [iSender retain];
	}
	return self;
}

- (void)dealloc
{
    [_param release];
	[_sender release];
	[_url release];
	
	// Some object can have been released earlier in the stack
	// do not free them if they are set to nil or the app will core dump
    SAFE_RELEASE(_data);
	SAFE_RELEASE(_connection);
	
    [super dealloc];
}

- (void)startDownload:(NSURL*)iURL
{
NEEDS(iURL != nil)
	
	// Save URL 
	_url = [iURL retain];

	// Create data
    _data = [[NSMutableData alloc] init];
	
    // alloc+init and start an NSURLConnection; release on completion/failure
    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url]
												  delegate:self];
}


- (void)startDownloadPhotoOfSize:(NSString*)iSize
{
NEEDS (_param != nil)
NEEDS ([_param class] == [DBPhoto class])
	
	// Retreives application delegate for future callback
	BetterFlickrAppDelegate*aDelegate = (BetterFlickrAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	// Construct photo URL before retreiving
	NSURL *aStaticPhotoURL  = [(DBPhoto*)_param urlForPhotoSize:iSize];
	
	// The reason the main application delegate should be the downloader delegate is pretty simple.
	// Since the download can be done at any time of the process, the thread initiating the download can
	// be killed before the download (done on a separate thread) is completed.
	// Therefore the main application thread should be used as delegate	
	[self setDelegate:aDelegate];
	
	// And finally starts the download
	[self startDownload:aStaticPhotoURL];
	
}

- (void)cancelDownload
{
    [_connection cancel];
	
    SAFE_RELEASE(_data);
	SAFE_RELEASE(_connection);
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)iData
{
    [_data appendData:iData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	LOG_ERROR(error);
	
	SAFE_RELEASE(_data);
	SAFE_RELEASE(_connection);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Build a temporary data that will be autoreleased
	// We can't keep the _data object since it will soon be freed
	NSData* aData = [NSData dataWithData:_data];
    
//    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
//	{
//        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
//		UIGraphicsBeginImageContext(itemSize);
//		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//		[image drawInRect:imageRect];
//		self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//    }
//    else
//    {
//        self.appRecord.appIcon = image;
//    }
    
	// Release used object
	SAFE_RELEASE(_data);
	SAFE_RELEASE(_connection);
	
    // call our delegate and tell it that our icon is ready for display
    [_delegate downloadDidComplete:self sender:_sender object:_param data:aData];
	
	
}

@end
