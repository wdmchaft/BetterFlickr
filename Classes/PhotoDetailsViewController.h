//
//  PhotoDetailsViewController.h
//  BetterFlickr
//
//  Created by Johan Attali on 12/4/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBPhoto;
@class DBUser;
@class DBComment;
@class QuartzLineView;

@interface PhotoDetailsViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate>
{
	DBPhoto* _photo;
	DBUser*	_user;
	
	IBOutlet UIButton* _preview;
	IBOutlet UIActivityIndicatorView* _activityPreview;
	IBOutlet UIView* _detailsView;
	IBOutlet UIWebView* _photoDescription;
	IBOutlet UILabel* _photoTitle;
	
	IBOutlet UILabel* _photoViews;
	IBOutlet UILabel* _photoComments;
	IBOutlet UILabel* _photoFavs;
	
	IBOutlet UIView* _commentsView;
	
	IBOutlet QuartzLineView* _separatorDescription;
	IBOutlet QuartzLineView* _separatorComments;
	
	NSInteger _webViewsProcessed;
}

@property (nonatomic, retain) DBPhoto*	photo;
@property (nonatomic, retain) DBUser*	user;

#pragma mark Callback Functions

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData;

#pragma mark Layout Functions

/*! @method		layoutScrollView
 *	@abstract	Updates the main scroll view height depending on the size of its content
 */
- (void)layoutScrollView;

/*! @method		layoutPreviewFromImage:
 *	@abstract	Updates the preview height if needed depending on the image size
 *	@param		aImage		The image that the preview will to for layout
 */
- (void)layoutViewsFromImage:(UIImage*)aImage;

/*! @method		layoutStats
 *	@abstract	Updates Stats view for the current photo (comments,favs ...)
 */
- (void)layoutStats;

/*! @method		layoutComments
 *	@abstract	Updates Comments view for the current photo 
 */
- (void)layoutComments;

/*! @method		addCommentViewFromComment:
 *	@abstract	Adds a UIView based on the passed comment
 *	@param		iComment	The comment from which the view will be built on
 */
- (void)addCommentViewFromComment:(DBComment*)iComment;

@end
