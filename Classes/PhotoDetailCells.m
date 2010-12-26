//
//  CommentViewCell.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/20/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "CommentViewCell.h"

#import "DBComment.h"


@implementation CommentViewCell


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

#pragma mark -
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
