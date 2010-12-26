//
//  PhotoDetailCommentCell.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/20/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "PhotoDetailCells.h"

#import "DBComment.h"
#import "DBPhoto.h"

#pragma mark -
#pragma mark PhotoDetailCommentCell

@implementation PhotoDetailCommentCell

#pragma mark Init Functions


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc
{
	[_comment release];
	
    [super dealloc];
}

#pragma mark Layout Functions

/*! @method		layoutFromComment:
 *	@abstract	Creates the layout of the current cell depending on the comment.
 *	@param		iComment		The BOM object from which the view will be built
 */
- (void) layoutFromComment:(DBComment*)iComment
{
	_comment = [iComment retain];
	
	_user.text = [iComment refUser];
	_content.text = [iComment content];
	
}

@end


#pragma mark -
#pragma mark PhotoDetailInfoCell

@implementation PhotoDetailInfoCell

#pragma mark Init Functions

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc
{
	
    [super dealloc];
}

#pragma mark Layout Functions

/*! @method		layoutFromComment:
 *	@abstract	Creates the layout of the current cell depending on the comment.
 *	@param		iPhoto		The BOM object from which the view will be built
 */
- (void) layoutFromPhoto:(DBPhoto*)iPhoto
{
	[_photoTitle setText:iPhoto.title];
	
	[_photoDescription setText:iPhoto.descr];
	
	[_photoViews setText:[NSString stringWithFormat:@"%d", (iPhoto.views > 0) ? iPhoto.views : 0]];
	[_photoFavs setText:[NSString stringWithFormat:@"%d",(iPhoto.favourites > 0) ? iPhoto.favourites : 0]];
	[_photoComments setText:[NSString stringWithFormat:@"%d", (iPhoto.comments > 0) ? iPhoto.comments : 0]];
	
	
	
}


@end
