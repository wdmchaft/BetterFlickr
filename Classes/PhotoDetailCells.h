//
//  PhotoDetailCommentCell.h
//  BetterFlickr
//
//  Created by Johan Attali on 12/20/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBComment;
@class DBPhoto;
@class QuartzLineView;

#define kPhotoDetailCommentCellIdentifier	@"kPhotoDetailCommentCellIdentifier"
#define kPhotoDetailInfoCellIdentifier		@"kPhotoDetailInfoCellIdentifier"
#define kPhotoPreviewCellIdentifier			@"kPhotoPreviewCellIdentifier"

#define kPhotoCellsNoComments 2

#pragma mark -
#pragma mark PhotoDetailCommentCell

@interface PhotoDetailCommentCell : UITableViewCell 
{
	DBComment* _comment;
	
	IBOutlet UILabel* _user;
	IBOutlet UILabel* _dateCreated;
	IBOutlet UILabel* _content;
	
	
}

/*! @method		layoutFromComment:
 *	@abstract	Creates the layout of the current cell depending on the comment.
 *	@param		iComment		The BOM object from which the view will be built
 */
- (void) layoutFromComment:(DBComment*)iComment;

@end

#pragma mark -
#pragma mark PhotoDetailInfoCell

@interface PhotoDetailInfoCell : UITableViewCell
{
	IBOutlet QuartzLineView* _separatorDescription;
	IBOutlet UILabel* _photoDescription;
	IBOutlet UILabel* _photoTitle;
	
	IBOutlet UILabel* _photoViews;
	IBOutlet UILabel* _photoComments;
	IBOutlet UILabel* _photoFavs;
	IBOutlet UIImageView* _photoPrivacy;
}

/*! @method		layoutFromComment:
 *	@abstract	Creates the layout of the current cell depending on the comment.
 *	@param		iPhoto		The BOM object from which the view will be built
 */
- (void) layoutFromPhoto:(DBPhoto*)iPhoto;

	
@end