//
//  PhotoDetailsViewController.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/4/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "PhotoDetailsViewController.h"

#import "BetterFlickrAppDelegate.h"
#import "ObjectiveFlickrDelegate.h"

#import "ObjectiveFlickr.h"

#import "DBUser.h"
#import "DBPhoto.h"
#import "DBComment.h"

#import "PhotoDetailCells.h"

#import "DBCommentAccessor.h"

#import "Downloader.h"

#import "QuartzViews.h"

@implementation PhotoDetailsViewController

@synthesize photo = _photo;	
@synthesize user = _user;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
REQUIRE(_photo != nil)
	
    [super viewDidLoad];
	
	self.title = _photo.title;
	
	// If photo has not been stored download it
	if ([_photo photoIsStoredForSize:OFFlickrMediumSize] == NO)
	{
		// Creates and start the downloader
		[[[Downloader alloc] initWithSender:self param:_photo] startDownloadPhotoOfSize:OFFlickrMediumSize];
		
		// Start Activity
		[_activityPreview startAnimating];
	}
	
	self.view.autoresizesSubviews = YES;
	
	
	// Comments
	_comments = [[[DBCommentAccessor instance] commentsForPhoto:_photo] retain];
	
	// TableView Setup
	_commentsView.backgroundColor	= [UIColor blackColor];
	_commentsView.separatorColor	= [UIColor darkGrayColor];


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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[_photo release];
	[_user release];
	[_comments release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Callbacks

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData
{
REQUIRE (iData != nil)
	
	UIImage* aImage = [[UIImage alloc] initWithData:iData];
	
	[_preview setBackgroundImage:aImage forState:UIControlStateNormal];
	
	// Stop Activity
	[_activityPreview stopAnimating];
	
	// Update layout from image
	//[self layoutViewsFromImage:aImage];
	
	// Release image object since it's retained in the preview button
	[aImage release];
}

#pragma mark -
#pragma mark UITableView delegate methods

/* numberOfSectionsInTableView:
 * Right now, should only return 1 because there is only 1 section in the tableview
 * @return  Always 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{ return 1; }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
REQUIRE (_comments != nil)
	
	return [_comments count] + kPhotoCellsNoComments;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
REQUIRE (_photo != nil)
	
	CGFloat aRowHeight = 40.0;
	if (indexPath.row == 0)
	{
		CGSize aPhotoSize = [_photo sizeForPhotoSize:OFFlickrMediumSize];
		if (!CGSizeEqualToSize(aPhotoSize, CGSizeZero)) 
		{
			// Some image can be very small (though what's the point in uploading to flickr :)
			CGFloat aMaxWidth = aPhotoSize.width > 320.0 ? 320.0 : aMaxWidth;
			
			aRowHeight = aMaxWidth*aPhotoSize.height/aPhotoSize.width;
		}
		else
			aRowHeight = 90;
	}
	else
	{
		NSString* aContent = nil;
		CGFloat	aTopPad = 20;
		CGFloat aBottomPad = 0;
		NSInteger aSizeFont = 20;
		
		if (indexPath.row == 1)
		{
			aTopPad		= 52;
			aSizeFont	= 12;
			aContent	= _photo.descr;
			aBottomPad	= 10;
		}
		else
		{
REQUIRE (indexPath.row < [_comments count] + kPhotoCellsNoComments)
			DBComment* aComment = (DBComment*)[_comments objectAtIndex:(indexPath.row - kPhotoCellsNoComments)];
			aContent = aComment.content;
		}
		
		// Calculate size the string would take taking only the width into account
		CGSize aSize = [aContent sizeWithFont:[UIFont fontWithName:@"Verdana" size:aSizeFont]];
		
		// Calculate the height this should take by getting dividing with window max width
		CGFloat aMaxHeight =  ceilf(aSize.width/320.0);
		
		// Don't forget the extra height from comment information
		
		
		aRowHeight =aMaxHeight*15+aTopPad+aBottomPad;
	}
	
	return aRowHeight;

	
	
	//PhotoDetailCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
REQUIRE (indexPath.row < [_comments count] + kPhotoCellsNoComments)
	
	UITableViewCell* aCell = nil;
	
	// First Row: Image View
	if (indexPath.row == 0)
	{
		aCell = [tableView dequeueReusableCellWithIdentifier:kPhotoPreviewCellIdentifier];
		
		// Create Cell if needed
		if (aCell == nil)
			aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain 
											reuseIdentifier:kPhotoPreviewCellIdentifier] autorelease];
		// Build image from content for specified size
		UIImage* aImage = [[UIImage alloc] initWithData:[_photo contentForPhotoSize:OFFlickrMediumSize]];
		aCell.imageView.image = aImage;
		
		// Release objects
		[aImage release];
		
	}
	
	else if (indexPath.row == 1)
	{
		aCell = (PhotoDetailInfoCell*)[tableView dequeueReusableCellWithIdentifier:kPhotoDetailInfoCellIdentifier];
		if (aCell == nil) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:@"DetailInfoCell" bundle:nil];
REQUIRE([c.view class] == [PhotoDetailInfoCell class])
			
			// Set current cell to the main view cell/
			// Caution: it has to be set via IB by connecting the ViewController.view 
			// to the PhotoViewCell
			aCell = (PhotoDetailInfoCell*)c.view;
			
			// the cell will be retained so we can safely release the controller
			[c release];
		}
		
REQUIRE (_photo != nil)
		[(PhotoDetailInfoCell*)aCell layoutFromPhoto:_photo];

		
	}
	else
	{
		aCell = (PhotoDetailCommentCell*)[tableView dequeueReusableCellWithIdentifier:kPhotoDetailCommentCellIdentifier];
		if (aCell == nil) 
		{
			UIViewController *c = [[UIViewController alloc] initWithNibName:@"CommentViewCell" bundle:nil];
REQUIRE([c.view class] == [PhotoDetailCommentCell class])
			
			// Set current cell to the main view cell/
			// Caution: it has to be set via IB by connecting the ViewController.view 
			// to the PhotoViewCell
			aCell = (PhotoDetailCommentCell	*)c.view;
			
			// the cell will be retained so we can safely release the controller
			[c release];
		}
		
		// Build UITableViewCell from object
		DBComment* aComment = (DBComment*)[_comments objectAtIndex:(indexPath.row - kPhotoCellsNoComments)];
REQUIRE (aComment != nil)
		[(PhotoDetailCommentCell*)aCell layoutFromComment:aComment];
		
		//TODO: Add special line if number of comments is to high
		
	}
		 
	return aCell;
}

- (void)tableView:(UITableView *)iTableView didSelectRowAtIndexPath:(NSIndexPath *)iIndexPath
{
//	[iTableView deselectRowAtIndexPath:iIndexPath animated:NO];		
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//	// Retreve the desired size for the webview
//	// Note that for this to work, the original size must be smaller than the desired one
//	CGSize s = [webView sizeThatFits:CGSizeZero];
//	
//	
//	[webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, s.height)];
//		
//	// Update Comment View
//	CGFloat y = 0; //_detailsView.frame.origin.y + webView.frame.origin.y+s.height + 5;
//	[_commentsView setFrame:CGRectMake(_commentsView.frame.origin.x, y, 
//									   _commentsView.frame.size.width, _commentsView.frame.size.height)];
//	
//	// Update main scroll view
//	[self layoutScrollView];
		
			
	
}


@end
