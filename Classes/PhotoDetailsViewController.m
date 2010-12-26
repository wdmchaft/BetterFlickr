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
	// otherwise update the preview image
	else
	{
		// Build image from content for specified size
		UIImage* aImage = [[UIImage alloc] initWithData:[_photo contentForPhotoSize:OFFlickrMediumSize]];
		
		// Update preview
		[_preview setBackgroundImage:aImage forState:UIControlStateNormal];
		
		// Update layout from image
		[self layoutViewsFromImage:aImage];

		// image is retained inside preview background button release it
		[aImage release];

	}
	
	self.view.autoresizesSubviews = YES;
	
	[_photoTitle setText:_photo.title];
	[_photoDescription loadHTMLString:[_photo descriptionForWebView] baseURL:nil];
	
	[self layoutStats];
	[self layoutComments];
	
	
//	[scrollView addSubview: contentView];
//	[self.view addSubview:scrollView];

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

/*! @method		layoutScrollView
 *	@abstract	Updates the main scroll view height depending on the size of its content
 */
- (void)layoutScrollView
{
	UIScrollView* aScrollView = (UIScrollView*)self.view;
	
	// Retreve the desired size for the webview
	// Note that for this to work, the original size must be smaller than the desired one
	//CGSize s = [_detailsView sizeThatFits:CGSizeZero];
	
	CGFloat aHeight = _detailsView.frame.size.height + _preview.frame.size.height;
	
	aScrollView.contentSize = CGSizeMake(320, aHeight+5);
}

/*! @method		layoutPreviewFromImage:
 *	@abstract	Updates the preview height if needed depending on the image size
 *	@param		aImage		The image that the preview will to for layout
 */
- (void)layoutViewsFromImage:(UIImage*)aImage
{
	CGSize aSize = aImage.size;
	
	// Some image can be very small (though what's the point in uploading to flickr :)
	CGFloat aMaxWidth = aSize.width > 320.0 ? 320.0 : aMaxWidth;
	
	CGFloat aCurrY = _preview.frame.origin.y;
	// Update preview view
	[_preview setFrame:CGRectMake(_preview.frame.origin.x, aCurrY , 
								  aMaxWidth, aMaxWidth*aSize.height/aSize.width)];
	
	// Update all other views contained in 	_detailsView
	aCurrY += _preview.frame.size.height + 5;
	[_detailsView setFrame:CGRectMake(_detailsView.frame.origin.x, aCurrY,
									  _detailsView.frame.size.width, _detailsView.frame.size.height)];
	
	aCurrY += _detailsView.frame.size.height;
	[_commentsView setFrame:CGRectMake(_commentsView.frame.origin.x, aCurrY,
									  _commentsView.frame.size.width, _commentsView.frame.size.height)];
	
	
	// Update ScrollView and leave a little space from the bottom
	aCurrY += _commentsView.frame.size.height;
	UIScrollView* aScrollView = (UIScrollView*)self.view;
	aScrollView.contentSize = CGSizeMake(320, aCurrY);
	
}

/*! @method		layoutStats
 *	@abstract	Updates Stats view for the current photo (comments,favs ...)
 */
- (void)layoutStats
{
REQUIRE (_photo != nil)
	
	[_photoViews setText:[NSString stringWithFormat:@"%d", (_photo.views > 0) ? _photo.views : 0]];
	[_photoFavs setText:[NSString stringWithFormat:@"%d",(_photo.favourites > 0) ? _photo.favourites : 0]];
	[_photoComments setText:[NSString stringWithFormat:@"%d", (_photo.comments > 0) ? _photo.comments : 0]];
}

/*! @method		layoutComments
 *	@abstract	Updates Comments view for the current photo 
 */
- (void)layoutComments
{
REQUIRE (_photo != nil)
	
	// Will hold the webviews that have an updated layout
	_webViewsProcessed = 0;

	NSArray* aComments = [[DBCommentAccessor instance] commentsForPhoto:_photo];
	
	// TODO: Comment Fetching might be migrated directly into the DBPhoto build process
	if (_photo.comments > [aComments count])
	{
		// Retreives application delegate for future callback
		BetterFlickrAppDelegate*aDelegate = (BetterFlickrAppDelegate*)[[UIApplication sharedApplication] delegate];
		
		[[aDelegate flickrDelegate] createRequestFromAPI:kFlickrPhotosCommentsList
											   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
														  [_photo pid], @"photo_id",  nil]];
	}
	
	for (int i = 0; i < [aComments count]; i++)
	{
		// Retreives comment
		DBComment* aComment = (DBComment*)[aComments objectAtIndex:i];
		
		// Creates and add subview to the comment view
		[self addCommentViewFromComment:aComment];
	}

}


/*! @method		addCommentViewFromComment:
 *	@abstract	Adds a UIView based on the passed comment
 *	@param		iComment	The comment from which the view will be built on
 */
- (void)addCommentViewFromComment:(DBComment*)iComment
{
REQUIRE (iComment != nil)
	
	NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DetailCommentView" 
														 owner:self 
													   options:nil];
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
	
	UIView* aCommentView = (UIView*)[nibEnumerator nextObject];
	
NEEDS(aCommentView != nil)
	
	for (int i = 0; i < [aCommentView.subviews count]; i++)
	{
		UIView* aSubView = [aCommentView.subviews objectAtIndex:i];
		if (aSubView.tag > 0)
		{
			// Configure Author
			if ([aSubView class] == [UILabel class])
			{
				UILabel* aAuthor = (UILabel*)aSubView;
				aAuthor.text = iComment.refUser;
			}
			// Configure WebView (comment)
			else if ([aSubView class] == [UIWebView class])
			{
				UIWebView* aCommentWebView = (UIWebView*)aSubView;
				[aCommentWebView setDelegate:self];
				[aCommentWebView setAutoresizesSubviews:YES];
				[aCommentWebView loadHTMLString:[iComment contentForWebView]  baseURL:nil];
			}
		}
	}
	
	[_commentsView addSubview:aCommentView];
	
	//UIView* aCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
//	aCommentView.autoresizesSubviews = YES;
//	aCommentView.opaque = YES;
//	
//	UILabel* aLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 16)];
//	aLabelView.font = [UIFont fontWithName:@"Verdana" size:11];
//	aLabelView.text = iComment.refUser;
//	
//	// Build comment view with zero sized rect to retreive a correct size once loaded
//	UIWebView* aCommentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 16, 300, 5)];
//	aCommentWebView.delegate = self;
//	aCommentWebView.tag = 1;
//	aCommentWebView.opaque = YES;
//	aCommentWebView.autoresizesSubviews = YES;
//	
//	// Load the content with an upgraded version that what's stored (black style, font...)
//	[aCommentWebView loadHTMLString:[iComment contentForWebView]  baseURL:nil];
//	
//	//Add the created webview to the comment view
//	[aCommentView addSubview:aLabelView];
//	[aCommentView addSubview:aCommentWebView];
//	[_commentsView addSubview:aCommentView];
//	
//	// Release already retained objects
//	[aCommentWebView release];
//	[aLabelView release];
//	[aCommentView release];
	
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
	[self layoutViewsFromImage:aImage];
	
	// Release image object since it's retained in the preview button
	[aImage release];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// Retreve the desired size for the webview
	// Note that for this to work, the original size must be smaller than the desired one
	CGSize s = [webView sizeThatFits:CGSizeZero];
	
	
	// Differentiate the webview for description than the one for comments
	// If it's a webview for comments we must update the container view and the scroll view
	if (webView.tag > 0)
	{
//		// Retreive last view object
//		UIWebView* aLastWebView = nil;
//		for (int i = [_commentsView.subviews count] - 1; i >= 0 && aLastWebView == nil; i--)
//		{
//			UIView* aSubView = [_commentsView.subviews objectAtIndex:i];
//			if ([aSubView class] == [UIWebView class])
//				aLastWebView = (UIWebView*)aSubView;
//		}
		
		UIView* aParentView = [webView superview];
		
		// Updates the webview getting the other ones into account
		// Especially the last one Y and Height
		[webView setFrame:CGRectMake(_commentsView.frame.origin.x, 
									 webView.frame.origin.y,
									 _commentsView.frame.size.width, 
									 s.height)];
		
		[aParentView setFrame:CGRectMake(_commentsView.frame.origin.x, 
									 webView.frame.origin.y,
									 _commentsView.frame.size.width, 
									 s.height + 22)];
		
		// Retreives comments for the specified photo
		NSArray* aComments = [[DBCommentAccessor instance] commentsForPhoto:_photo];
		
		// Increment the number of processed comments
		_webViewsProcessed++;
	
		// If we reached the desired number of comments udpate the comment view
		if (_webViewsProcessed == [aComments count])
		{
			CGFloat aCurrY = 0;
			CGFloat aWidth = 300;
			for (int i = 0; i < [_commentsView.subviews count]; i++)
			{
				UIView* aSubView = [_commentsView.subviews objectAtIndex:i];
				//if ([aSubView class] == [UIWebView class])
				//{
					CGFloat aViewHeight = aSubView.frame.size.height;
					[aSubView setFrame:CGRectMake(0, aCurrY, aWidth, aViewHeight)];
					aCurrY += aViewHeight;
				//}
			}
			
//			// Finally update the comment view after adding all subviews height
//			[_commentsView setFrame:CGRectMake(_commentsView.frame.origin.x, _commentsView.frame.origin.y, 
//											   _commentsView.frame.size.width, aCurrY)];
			
			[_detailsView setFrame:CGRectMake(_detailsView.frame.origin.x, _detailsView.frame.origin.y, 
											  _detailsView.frame.size.width, _detailsView.frame.size.height+aCurrY)];
			
			
			// Update main scroll view
			[self layoutScrollView];
		}
		
		
//		[_commentsView setFrame:CGRectMake(_commentsView.frame.origin.x, _commentsView.frame.origin.y, 
//										   _commentsView.frame.size.width, _commentsView.frame.size.height+webView.frame.size.height)];
//		// Update main scroll view
//		[self layoutScrollView];
	}
	// If it's a webview for description we must update 
	else
	{
		[webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, s.height)];
		
		// Update Comment View
		CGFloat y = _detailsView.frame.origin.y + webView.frame.origin.y+s.height;
		[_commentsView setFrame:CGRectMake(_commentsView.frame.origin.x, y, 
										   _commentsView.frame.size.width, _commentsView.frame.size.height)];
		
		// Update main scroll view
		[self layoutScrollView];
		
	}
			
	
}


@end
