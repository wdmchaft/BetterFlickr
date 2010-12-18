//
//  ObjectiveFlickrDelegate.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/1/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveFlickr.h"

#define kFlickrAuthToken	@"flickr.auth.getToken"
#define kFlickrPeoplePhotos	@"flickr.people.getPhotos"
#define kFlickrPhotosInfo	@"flickr.photos.getInfo"

@class BetterFlickrAppDelegate;

@interface ObjectiveFlickrDelegate : NSObject <OFFlickrAPIRequestDelegate>
{
	OFFlickrAPIContext* flickrContext;
}

@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;

- (void)processAuthentication:(NSDictionary*)iDicAuth;
- (void)processUserPhotos:(NSDictionary*)iDicPhotos;
- (void)processPhotoInfo:(NSDictionary*)iDicPhotos;

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
