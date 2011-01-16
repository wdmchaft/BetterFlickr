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

@interface PhotoDetailsViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
	DBPhoto* _photo;
	DBUser*	_user;
	NSArray* _comments;
	
	IBOutlet UIButton* _preview;
	IBOutlet UIActivityIndicatorView* _activityPreview;
	IBOutlet UIView* _detailsView;
	IBOutlet UIWebView* _photoDescription;
	IBOutlet UILabel* _photoTitle;
	
	IBOutlet UILabel* _photoViews;
	IBOutlet UILabel* _photoComments;
	IBOutlet UILabel* _photoFavs;
	
	IBOutlet UITableView* _commentsView;
	
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

/*! @method		gotUpdatedInformation:
 *	@abstract	Callback for when information such as comments has been sucessfully downloaded
 *	@param		iObjID		The BOM object from which the information has been retreived
 */
- (void)gotUpdatedInformation:(id)iObjID;

#pragma mark Layout Functions


@end
