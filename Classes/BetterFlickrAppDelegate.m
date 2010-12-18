//
//  BetterFlickrAppDelegate.m
//  BetterFlickr
//
//  Created by Johan Attali on 6/27/10.
//  Copyright Johan Attali. http://www.jjbrothers.net 2010. All rights reserved.
//

#import "BetterFlickrAppDelegate.h"

#import "Locales.h"

#import "Downloader.h"

#import "DBUser.h"
#import "DBPhoto.h"

#import "DBUserAccessor.h"
#import "DBPhotoAccessor.h"


#import "ObjectiveFlickr.h"
#import "ObjectiveFlickrDelegate.h"

#import "PhotostreamViewController.h"
#import "PhotoDetailsViewController.h"

#import "PhotoViewCell.h"


static const NSInteger kAlertViewLogin = 1;

@implementation BetterFlickrAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize flickrDelegate;
//@synthesize flickrRequest;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	// Create the initial Controller
	PhotostreamViewController* rViewController = [[[PhotostreamViewController alloc] initWithNibName:@"PhotostreamView" bundle:[NSBundle mainBundle]] autorelease];
	rViewController.title = @"BetterFlickr";
	
	// Add it to a navigation controller
	UINavigationController *rNavController = [[UINavigationController alloc] initWithRootViewController:rViewController];          

	
	//Set up the tab controller
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = [NSArray arrayWithObjects:rNavController,  nil];
	

    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	// Database initialization
	//[self resetDatabase];
	[self createsDatabaseIfNeeded];
	
	// Create the Flickr Delegate
	flickrDelegate = [[ObjectiveFlickrDelegate alloc] init];
	
	// Determine Main User existance in local DB
	DBUser* aMainUser = [[DBUserAccessor instance] getMainUser];
	
	// If user has not logged in yet, launch login screen
	if (aMainUser == nil)
	{
		UIAlertView* aAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(kLocaleInformation, nil) 
															 message:NSLocalizedString(kLocaleFirstLogin, nil) 
															delegate:self
												   cancelButtonTitle:NSLocalizedString(kLocaleYes, nil)
												   otherButtonTitles:NSLocalizedString(kLocaleNo, nil), nil];
		[aAlertView setTag:kAlertViewLogin];
		[aAlertView show];
	}
	
	// DBUser was already signed in, process first action
	else 
		[self firstAction];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. 
	 This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) 
	 or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to 
	 restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. 
	 If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

#pragma mark -
#pragma mark BetterFlickr methods

- (void) firstAction
{
REQUIRE([self flickrDelegate] != nil)	
	
	DBUser* aMainUser = [[DBUserAccessor instance] getMainUser];
	
	if (aMainUser)
	{
		[[self flickrDelegate] createRequestFromAPI:kFlickrPeoplePhotos 
										  arguments:[NSDictionary dictionaryWithObjectsAndKeys:
															   [aMainUser nsid], @"user_id", nil]];

		
		NSArray* aPhotos = [[DBPhotoAccessor instance] photosFromUser:aMainUser];
		aPhotos = nil;
	}
		
}

- (void)gotNewPhotos
{
REQUIRE([self flickrDelegate] != nil)
	
	
	
}

#pragma mark -
#pragma mark Objective Flickr methods



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	// query has the form of "&frob=", the rest is the frob
	NSString *aURLString = [url absoluteString];
	NSString* aFrob = nil;
	
	NSRange aRange = [aURLString rangeOfString:@"frob="];
	
	// Frob = substring from range location + length (skip =)
	if (aRange.location != NSNotFound)
		aFrob = [aURLString substringFromIndex:(aRange.location + aRange.length)];
		
	[[self flickrDelegate] createRequestFromAPI:kFlickrAuthToken 
									  arguments:[NSDictionary dictionaryWithObjectsAndKeys:aFrob, @"frob", nil]];

	return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
REQUIRE(self.flickrDelegate);
	
	if (buttonIndex == 0 && alertView.tag == kAlertViewLogin)
	{
		// Force Token to be nil
		[[self.flickrDelegate flickrContext] setAuthToken:nil];
		
		// Creates Login url
		NSURL* aURL = [[self.flickrDelegate flickrContext] loginURLFromFrobDictionary:nil requestedPermission:OFFlickrWritePermission];
		
		// Open safari, the callback url of the flickr app should be handled by the application
		// this is done in the plist file of the project.
		// Once callback is activated and handled by the application, it calls:
		// - (BOOL)application:(UIApplication *) handleOpenURL:(NSURL *)
		[[UIApplication sharedApplication] openURL: aURL];
	}
}

#pragma mark -
#pragma mark  DownloaderDelegate Methods

- (void)downloadDidComplete:(Downloader*)iDownloader sender:(id)iSender object:(id)iObj data:(NSData*)iData
{
	
	if ([iObj class] == [DBPhoto class])
	{
		// Save Photo locally
		DBPhoto* aPhoto = (DBPhoto*)iObj;
		
		// This is key for application BetterFlickr
		// Save photo on the file system so that there is no need
		// to downlaod it again next time it runs out of the cache
		// TODO: optimization depending on disk space used by the application
		[self savePhotoOnFileSystem:aPhoto data:iData];

	}
	// We need to know which view has focus in order to avoid core dumps
	// when trying to refresh a view that doesn't exist anymore
	if (tabBarController.selectedIndex == kTabBarUserPhotoStreamIndex)
	{
		// Get the corresponding View Controller for a callback
		UINavigationController* aController = (UINavigationController*)tabBarController.selectedViewController;
		
		// Get the navigation controller top view controller
		UIViewController* aTopController = aController.topViewController;
		
		// 1. It can come from a thumbnail download and the user is still on the photo stream view
		if ([iDownloader.sender class] == [PhotoViewCell class] && [aTopController class] == [PhotostreamViewController class])
		{
			
			PhotostreamViewController* aPhotoStreamController = (PhotostreamViewController*)aTopController;
			
			[aPhotoStreamController photoDownloadDidComplete:iSender data:iData];
		}
		
		// 2. It can come from a detail view and the user is still on the detail view
		else if ([iDownloader.sender class] == [PhotoDetailsViewController class] && 
				 [aTopController class] == [PhotoDetailsViewController class])
		{
			PhotoDetailsViewController* aPhotoStreamController = (PhotoDetailsViewController*)aTopController;
			
			[aPhotoStreamController photoDownloadDidComplete:iSender data:iData];
		}
				 
	}
	
	// No longer do we need the downloader release it
	[iDownloader release];

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
	
	[flickrDelegate release];
	
    [super dealloc];
}
	 
#pragma mark -
#pragma mark DB Methods
- (Boolean) createsDatabaseIfNeeded
{
	NSString *aDocumentsDir = [self rootApplicationPath];
	NSString* aDatabasePath = [aDocumentsDir stringByAppendingPathComponent:kDatabaseName];
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	Boolean isDBAlreadyExisting = [aFileManager fileExistsAtPath:aDatabasePath];
	
	if (!isDBAlreadyExisting)
		return [self resetDatabase];

	return NO;
}

/*!
 * @method		resetDatabase
 * @abstract	Restores original database with default settings by copying
 *				the sqlite3 database located in Resources into the application directory
 * @result		True if the reset was correctly processed.
 */
- (Boolean) resetDatabase
{
	NSString *aDocumentsDir = [self rootApplicationPath];
	NSString* aDatabasePath = [aDocumentsDir stringByAppendingPathComponent:kDatabaseName];
	NSError* aError = nil;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	
	// Check if the database has already been created in the users filesystem
	Boolean isDBAlreadyExisting = [aFileManager fileExistsAtPath:aDatabasePath];

	// Removes the existing database if already existing
	if (isDBAlreadyExisting)
	{
		[aFileManager removeItemAtPath:aDatabasePath error:&aError];
		
		// Handle the error if any
		if (aError != nil)
			NSLog(@"%@", [aError description]);
		
	}
	
	// Do not forget to include the db inside the XCode project itself for it to be copied
	// to its final path. Also this should only host the first and original version !
	// All other changes should be made through the the copy inside the Documents Folder
	NSString *aDatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseName];
	
	[aFileManager copyItemAtPath:aDatabasePathFromApp toPath:aDatabasePath error:&aError];
	
	
	// Handle the error if any
	if (aError != nil)
		NSLog(@"%@", [aError description]);
	
	return YES;
	
}



#pragma mark -
#pragma mark  Useful Methods

/*!
 * @method		rootApplicationPath:data
 * @abstract	The complete path to the application Documents Folder (unique on the app)
 *				for example /Users/.../iPhone Simulator/4.0/Applications/CCA4418E-4915-4303-A5F3-CE7353FBC1B0/Documents
 * @result		A string with the complete path
 */
- (NSString*) rootApplicationPath
{
	NSArray *aDocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return ([aDocumentPaths count] > 0) ? [aDocumentPaths objectAtIndex:0] : nil;
}

/*!
 * @method		extenstionFromImage:data
 * @abstract	Returns the extension (ex _s or _t) depending on the image size
 * @param		iImage	The image from which the extension will be calculated
 * @result		A string with the current extension
 */
- (NSString*) extenstionFromImage:(UIImage*)iImage
{
REQUIRE(iImage != nil)
	NSString* aRes = @"_";
	
	CGFloat aWidth = iImage.size.width;
	CGFloat aHeight = iImage.size.height;
	
	if (MAX(aWidth,aHeight) == OFFlickrSmallSquareMaxSize)
		aRes = OFFlickrSmallSquareSize;
	else if (MAX(aWidth,aHeight) == OFFlickrThumbnailMaxSize)
		aRes = OFFlickrThumbnailSize;
	else if (MAX(aWidth,aHeight) == OFFlickrSmallMaxSize)
		aRes = OFFlickrSmallSize;
	else if (MAX(aWidth,aHeight) == OFFlickrMediumMaxSize)
		aRes = @"";
	
	return aRes;
}

/*!
 * @method		savePhotoOnFileSystem:data
 * @abstract	Saves the photo locally on the iPhone inside the application Documents folder.
 *				The purpose is to have the application runs extremly fast and avoid
 *				downloading the images each time they go out of the cache.
 * @param		iPhoto	The photo associated to the image that will be saved
 * @param		iData	The data holding the image.
 * @result		YES if correctly saved on the filesystemm, NO otherwise.
 */
- (BOOL)savePhotoOnFileSystem:(DBPhoto*)iPhoto data:(NSData*)iData
{
REQUIRE(iPhoto)
REQUIRE([iPhoto owner])
	
	NSString *aDocumentsPath	= [self rootApplicationPath];
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	BOOL aFolderExists	= NO;
	BOOL aSuccess		= NO;
	NSError* aError		= nil;
	
	// The folder name will look like Documents/Username
    NSString* aUserPath = [aDocumentsPath stringByAppendingPathComponent:iPhoto.owner];
	

	// Check if folder already exists
	[aFileManager fileExistsAtPath:aUserPath isDirectory:&aFolderExists];
	
	// Create folder if not existing
    if (aFolderExists == NO)
		[aFileManager createDirectoryAtPath:aUserPath
				withIntermediateDirectories:NO 
								 attributes:nil 
									  error:&aError];
	
	// Now check image size to see what extenstion will be written
	UIImage* aImage = [[UIImage alloc]initWithData:iData];
	NSString* aPath = [aUserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.jpg", 
																 iPhoto.pid, 
																 [self extenstionFromImage:aImage]]];
	
	
	// Finally Create the file on the iPhone filesystem if not already existing
	if ([aFileManager fileExistsAtPath:aPath isDirectory:&aFolderExists] == NO)
		aSuccess = [aFileManager createFileAtPath:aPath contents:iData attributes:nil];
	
	// Update DB with photo path without extension
	iPhoto.path = [aUserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", iPhoto.pid] ];
	
	// Save it on the local DB
	[[DBPhotoAccessor instance] savePhoto:iPhoto];
	
	// Release unused objects
	[aImage release];
	
	return aSuccess;
	
}

		 

@end

