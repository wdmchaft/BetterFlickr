//
//  ObjectiveFlickrDelegate.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/1/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveFlickr.h"

#define kFlickrAuthToken			@"flickr.auth.getToken"
#define kFlickrPeoplePhotos			@"flickr.people.getPhotos"
#define kFlickrPhotosInfo			@"flickr.photos.getInfo"
#define kFlickrPhotosFavorites		@"flickr.photos.getFavorites"

#define kFlickrPhotosCommentsList	@"flickr.photos.comments.getList"

@class BetterFlickrAppDelegate;

@interface ObjectiveFlickrDelegate : NSObject <OFFlickrAPIRequestDelegate>
{
	OFFlickrAPIContext* flickrContext;
}

@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;

- (void)processAuthentication:(NSDictionary*)iDicAuth;
- (void)processUserPhotos:(NSDictionary*)iDicPhotos;
- (void)processPhotoInfo:(NSDictionary*)iDicPhotos;
- (void)processPhotoFavorites:(NSDictionary*)iDicPhotos;

/*! @method		processPhotoComments:
 *	@abstract	Processes data retreived after a Flickr API Call. The response will look like:
 *				<comments photo_id="109722179">
 *					<comment id="6065-109722179-72057594077818641"
 *					 author="35468159852@N01" authorname="Rev Dan Catt" datecreate="1141841470"
 *					 permalink="http://www.flickr.com/photos/straup/109722179/#comment72057594077818641">
 *						Umm, I'm not sure, can I get back to you on that one?
 *					</comment>
 *				</comments>
 *	@param		iDicComments	A Dictionary build by ObjectiveFlickr built from
 *	
 */
- (void)processPhotoComments:(NSDictionary*)iDicComments;

/*! @method		createRequestFromAPI:arguments
 *	@abstract	Does two things:
 *				1. Creates a OFFlickrAPIRequest based on the current OFFlickrAPIContext.
 *				2. Calls callAPIMethodWithGET with the arguments. 
 *				The delegate shoud always be an instance of ObjectiveFlickrDelegate.
 *	@param		iAPI		ex flickr.photos.getInfo
 *	@param		iArguments	The list of arguments you would normally give to callAPIMethodWithGET
 */
- (void)createRequestFromAPI:(NSString*)iAPI arguments:(NSDictionary*)iArguments;


- (BetterFlickrAppDelegate*)betterFlickrDelegate;	

@end
