//
//  CommentViewCell.h
//  BetterFlickr
//
//  Created by Johan Attali on 12/20/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBComment;
@class PhotoDetailsViewController;
@class QuartzLineView;

#define kCommentViewCellIdentifier @"kCommentViewCellIdentifier"

@interface CommentViewCell : UITableViewCell 
{
	DBComment* _comment;
	PhotoDetailsViewController*	_controller;
	
	IBOutlet UIWebView* _webview;
	

}

@property (nonatomic, retain) PhotoDetailsViewController* controller;
@property (nonatomic, assign) UIWebView* webview;



/*! @method		layoutFromComment:
 *	@abstract	Creates the layout of the current cell depending on the comment.
 *	@param		iComment		The BOM object from which the view will be built
 */
- (void) layoutFromComment:(DBComment*)iComment;

@end
