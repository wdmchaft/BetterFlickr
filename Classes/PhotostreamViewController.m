//
//  PhotostreamViewController.m
//  BetterFlickr
//
//  Created by Johan Attali on 6/27/10.
//  Copyright Johan Attali. http://www.jjbrothers.net 2010. All rights reserved.
//

#import "PhotostreamViewController.h"
#import "PhotoDetailsViewController.h"

#import "DBPhoto.h"
#import "DBUser.h"

#import "DBPhotoAccessor.h"
#import "DBUserAccessor.h"

#import "PhotoViewCell.h"


@implementation PhotostreamViewController

@synthesize tableViewPhotos = _tableViewPhotos;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma mark -
#pragma mark UIView inherited functions

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
REQUIRE (_tableViewPhotos != nil)
	
	// Update TableView Style
	[self layoutTableView:_tableViewPhotos];	

	
	// Retreive Information from current context
	_user	= [[[DBUserAccessor instance] getMainUser] retain];
	_photos = [[[DBPhotoAccessor instance] photosFromUser:_user] retain];
	
	// Black style to match application style
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	_tableViewPhotos = nil;
	_searchBar = nil;
}


- (void)dealloc
{	
	[_user release];
	[_photos release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Layout Methods

/*! @method		layoutTableView
 *	@abstract	Common fucntion for both the PhotoStream and the SearchDisplay Controllers
 *				for applyting the same properties to both tables views
 *	@param		iTableView		The Table View to setup
 */
- (void)layoutTableView:(UITableView*)iTableView
{
	iTableView.rowHeight		= 90.0;	
	iTableView.backgroundColor	= [UIColor blackColor];
	iTableView.separatorColor	= [UIColor darkGrayColor];	
}

#pragma mark -
#pragma mark Callbacks from BetterFlickrAppDelegate

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData
{
	PhotoViewCell* aCell = (PhotoViewCell*)iObjID;
NEEDS ([aCell class] == [PhotoViewCell class])
REQUIRE(iData != nil)
	
	UIImage* aImage = [[UIImage alloc] initWithData:iData];
	
	[aCell.preview setImage:aImage];
	[aCell.activity stopAnimating];
	
	[aImage release];
	
}

#pragma mark -
#pragma mark UITableView delegate methods

/* numberOfSectionsInTableView:
 * Right now, should only return 1 because there is only 
 * 1 section in the tableview
 * @return  Always 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{ return 1; }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return [_photos count];
		
	else
	//DBUser* aUser = [[DBUserAccessor instance] getMainUser];
	//NSArray* aPhotos = [[DBPhotoAccessor instance] photosFromUser:aUser];
		return 200;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PhotoViewCell *cell = (PhotoViewCell*)[_tableViewPhotos dequeueReusableCellWithIdentifier:kPhotoViewCellIdentifier];
	if (cell == nil) 
	{
		UIViewController *c = [[UIViewController alloc] initWithNibName:@"PhotoViewCell" bundle:nil];
REQUIRE([c.view class] == [PhotoViewCell class])
		
		// Set current cell to the main view cell/
		// Caution: it has to be set via IB by connecting the ViewController.view 
		// to the PhotoViewCell
		cell = (PhotoViewCell	*)c.view;
		
		
		
		// the cell will be retained so we can safely release the controller
		[c release];
	}
	
	[cell.title setText:[NSString stringWithFormat:@"%d", indexPath.row]];
	
		
	// Now build the cell based on the associated photo
	if (_photos != nil)
	{
		// Build current cell with the photo located at index.row
		// TODO: Sort photos based on specific parameters
		if (indexPath.row < [_photos count])
		{
			DBPhoto* aPhoto = [_photos objectAtIndex:indexPath.row];
			[cell layoutFromPhoto:aPhoto];
		}

	}
	
	return cell;
}

- (void)tableView:(UITableView *)iTableView didSelectRowAtIndexPath:(NSIndexPath *)iIndexPath
{
REQUIRE(iIndexPath.row < [_photos count])
	
	[iTableView deselectRowAtIndexPath:iIndexPath animated:NO];
	
	// Creates the detail view controller
	PhotoDetailsViewController *aDetailsViewController = [[PhotoDetailsViewController alloc] initWithNibName:@"PhotoDetailsViewController"
																									   bundle:nil];
	
	// Associate View Controller with corresponding Data
	aDetailsViewController.photo = (DBPhoto*)[_photos objectAtIndex:iIndexPath.row];
	
	[[self navigationController] pushViewController:aDetailsViewController animated:YES];
	
	//Release already retained objects
	[aDetailsViewController release];
	
	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
	// Done wil the search, unload photos
	SAFE_RELEASE(_photos);
	
	// And load back with the current user photos
	_photos = [[[DBPhotoAccessor instance] photosFromUser:_user] retain];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
	// Update TableView Style
	[self layoutTableView:tableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
	// TODO: Maybe some optimization can be done here
	[tableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	// Safely realease old array of photos
	SAFE_RELEASE(_photos);
	
	// Retreive new array from search
	_photos = [[[DBPhotoAccessor instance] photosFromSearch:searchString] retain];
	
	
    return YES;
}


//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}


@end
