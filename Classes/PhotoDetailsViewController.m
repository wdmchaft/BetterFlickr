//
//  PhotoDetailsViewController.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/4/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "ObjectiveFlickr.h"

#import "DBUser.h"
#import "DBPhoto.h"

#import "Downloader.h"

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
	// otherwise update the preview image
	else
	{
		// Build image from content for specified size
		UIImage* aImage = [[UIImage alloc] initWithData:[_photo contentForPhotoSize:OFFlickrMediumSize]];
		
		// Update preview
		[_preview setBackgroundImage:aImage forState:UIControlStateNormal];
		
		// Update layout from image
		[self layoutPreviewFromImage:aImage];

		// image is retained inside preview background button release it
		[aImage release];

	}

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
	
    [super dealloc];
}

#pragma mark Layout Functions

/*! @method		layoutPreviewFromImage:
 *	@abstract	Updates the preview height if needed depending on the image size
 *	@param		aImage		The image that the preview will to for layout
 */
- (void)layoutPreviewFromImage:(UIImage*)aImage
{
	CGSize aSize = aImage.size;
	
	// Some image can be very small (though what's the point in uploading to flickr :)
	CGFloat aMaxWidth = aSize.width > 320.0 ? 320.0 : aMaxWidth;
	
	if (aSize.width > aSize.height)
		[_preview setFrame:CGRectMake(_preview.frame.origin.x, _preview.frame.origin.y, 
									  aMaxWidth, aMaxWidth*aSize.height/aSize.width)];
	else
		[_preview setFrame:CGRectMake(_preview.frame.origin.x, _preview.frame.origin.y, 
									  aMaxWidth, aMaxWidth*aSize.height/aSize.width)];
}

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
	[self layoutPreviewFromImage:aImage];
	
	// Release image object since it's retained in the preview button
	[aImage release];
}

@end
