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


@interface PhotostreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,  UISearchDisplayDelegate, UISearchBarDelegate>
{
	IBOutlet UITableView* _tableViewPhotos;
	IBOutlet UISearchBar* _searchBar;
	
	NSArray* _photos;
	DBUser*	_user;
	
}

@property (nonatomic, retain) UITableView* tableViewPhotos;

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData;

/*! @method		layoutTableView
 *	@abstract	Common fucntion for both the PhotoStream and the SearchDisplay Controllers
 *				for applyting the same properties to both tables views
 *	@param		iTableView		The Table View to setup
 */
- (void)layoutTableView:(UITableView*)iTableView;

@end
