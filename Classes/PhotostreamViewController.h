//
//  PhotostreamViewController.h
//  BetterFlickr
//
//  Created by Johan Attali on 6/27/10.
//  Copyright Johan Attali. http://www.jjbrothers.net 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBUser;

#define kPhotoStreamContextMainUser 0
#define kPhotoStreamContextContacts 1
#define kPhotoStreamContextEveryone 2

@class SettingsViewController;

@interface PhotostreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,  UISearchDisplayDelegate, UISearchBarDelegate>
{
	IBOutlet UITableView* _tableViewPhotos;
	IBOutlet UISearchBar* _searchBar;
	
	NSArray* _photos;
	DBUser*	_user;
	
	SettingsViewController* _settingsController;
	
}

@property (nonatomic, retain) UITableView* tableViewPhotos;

#pragma mark -
#pragma mark Callback Functions

/*! @method		updateIsNeeded:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)updateIsNeeded:(id)iObjID data:(NSData*)iData;

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData;


#pragma mark -
#pragma mark Layout Functions

/*!
 * @method		layoutTopBar
 * @abstract	Creates all buttons required by the photostream controller and attach
 *				them to the navigation item.
 */
- (void) layoutTopBar;

/*!
 * @method		settingsClicked:
 * @abstract	Called when the user clicked a specific button
 * @param		sender	The object initializing the call
 */
- (void) settingsClicked:(id)sender;

/*! @method		layoutTableView
 *	@abstract	Common fucntion for both the PhotoStream and the SearchDisplay Controllers
 *				for applyting the same properties to both tables views
 *	@param		iTableView		The Table View to setup
 */
- (void)layoutTableView:(UITableView*)iTableView;

@end
