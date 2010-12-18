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

@interface PhotoDetailsViewController : UIViewController 
{
	DBPhoto* _photo;
	DBUser*	_user;
	
	IBOutlet UIButton* _preview;
	IBOutlet UIActivityIndicatorView* _activityPreview;
}

@property (nonatomic, retain) DBPhoto*	photo;
@property (nonatomic, retain) DBUser*	user;

/*! @method		downloadDidComplete:data
 *	@abstract	Callback for when a photo had been completely downloaded
 *	@param		iObjID		The BOM object from which the download had been started
 *	@param		iData		The Data holding the image
 */
- (void)photoDownloadDidComplete:(id)iObjID data:(NSData*)iData;

/*! @method		layoutPreviewFromImage:
 *	@abstract	Updates the preview height if needed depending on the image size
 *	@param		aImage		The image that the preview will to for layout
 */
- (void)layoutPreviewFromImage:(UIImage*)aImage;

@end
