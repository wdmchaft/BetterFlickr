//
//  PhotoViewCell.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/11/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPhotoViewCellIdentifier @"kPhotoViewCellIdentifier"

@class DBPhoto;
@class QuartzLineView;

@interface PhotoViewCell : UITableViewCell
{
	IBOutlet	UILabel* _title;
	IBOutlet	UIImageView* _preview;
	IBOutlet	UIActivityIndicatorView* _activity;
	IBOutlet	UILabel* _description;
	IBOutlet	QuartzLineView* _line;
	
	DBPhoto* _photo;
}

@property (nonatomic, retain) UILabel* title;
@property (nonatomic, retain) UIImageView* preview;
@property (nonatomic, retain) DBPhoto* photo;
@property (nonatomic, retain) UIActivityIndicatorView* activity;
@property (nonatomic, retain) UILabel* description;

/*! @method		layoutFromPhoto:
 *	@abstract	Creates the layout of the current cell depending on the photo.
 *	@param		iPhoto		The BOM object from which the view will be built
 */
- (void) layoutFromPhoto:(DBPhoto*)iPhoto;

@end
