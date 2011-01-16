//
//  BetterFlickrAppDelegate.h
//  BetterFlickr
//
//  Created by Johan Attali on 6/27/10.
//  Copyright Johan Attali. http://www.jjbrothers.net 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Downloader.h"

#define kTabBarUserPhotoStreamIndex 0

#define kUserSettingPhotostreamLayout @"photostream_layout"
#define kUserSettingPhotostreamLayoutGrid @"grid"
#define kUserSettingPhotostreamLayoutList @"list"

@class ObjectiveFlickrDelegate;
@class DBPhoto;
@class OFFlickrAPIContext;
@class OFFlickrAPIRequest;

@interface BetterFlickrAppDelegate : NSObject <UIApplicationDelegate, 
	UITabBarControllerDelegate, 
	UIAlertViewDelegate, DownloaderDelegate> 
{
    UIWindow *window;
    UITabBarController *tabBarController;
	
	
	ObjectiveFlickrDelegate* flickrDelegate;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, readonly) ObjectiveFlickrDelegate *flickrDelegate;

#pragma mark -
#pragma mark Database Functions
// Creates the database if it has not already been created by a previous launch
- (Boolean) createsDatabaseIfNeeded;

/*!
 * @method		resetDatabase
 * @abstract	Restores original database with default settings by copying
 *				the sqlite3 database located in Resources into the application directory
 * @result		True if the reset was correctly processed.
 */
// 
- (Boolean) resetDatabase;

#pragma mark -
#pragma mark BetterFlickr Controlling Functions

/*!
 * @method		firstAction
 * @abstract	Process the first action done when all conditions are met.
 *				The purpose of this method is to gather all actions during first time of launch
 *				and to be used whatever the previous steps (call back from url or first launch)
 */
- (void) firstAction;

/*!
 * @method		gotNewPhotos
 * @abstract	Called whenever a new photo is inserted and an update on the current view is needed.
 *				The behaviour will be calculated depending on the current controller called.
 * @param		idObj	always nil
 * @param		data	The array of photos just fetched
 */
- (void)gotNewPhotos:(id)idObj data:(id)data;

/*!
 * @method		gotUpdatedInfoForPhoto
 * @abstract	Called whenever information such as comments for favourites for a specific
 *				photo has been retreived.
 *				The behaviour will be calculated depending on the current controller called.
 * @param		iPhoto
 */
- (void)gotUpdatedInfoForPhoto:(DBPhoto*)iPhoto;


#pragma mark -
#pragma mark Useful Application Functions
/*!
 * @method		rootApplicationPath:data
 * @abstract	The complete path to the application Documents Folder (unique on the app)
 *				for example /Users/.../iPhone Simulator/4.0/Applications/CCA4418E-4915-4303-A5F3-CE7353FBC1B0/Documents
 * @result		A string with the complete path
 */
- (NSString*) rootApplicationPath;

/*!
 * @method		extenstionFromImage:data
 * @abstract	Returns the extension (ex _s or _t) depending on the image size
 * @param		iImage	The image from which the extension will be calculated
 * @result		A string with the current extension
 */
- (NSString*) extenstionFromImage:(UIImage*)iImage;

/*!
 * @method		registerUserSetting:
 * @abstract	Calls NSUserDefaults interface to register application shared settings
 *				Useful to have it at main thread level to always call the same function
 * @param		iValue	The image from which the extension will be calculated
 */
- (void) registerUserSetting:(NSObject*)iValue forKey:(NSString*)iKey;

/*!
 * @method		savePhotoOnFileSystem:data
 * @abstract	Saves the photo locally on the iPhone inside the application Documents folder.
 *				The purpose is to have the application runs extremly fast and avoid
 *				downloading the images each time they go out of the cache.
 * @param		iPhoto	The photo associated to the image that will be saved
 * @param		iData	The data holding the image.
 * @result		YES if correctly saved on the filesystemm, NO otherwise.
 */
- (BOOL)savePhotoOnFileSystem:(DBPhoto*)iPhoto data:(NSData*)iData;


@end
