//
//  ObjectiveFlickrDelegate.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/1/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "BetterFlickrAppDelegate.h"
#import "ObjectiveFlickrDelegate.h"

#import "Strings.h"


#import "DBUserAccessor.h"
#import "DBPhotoAccessor.h"
#import "DBCommentAccessor.h"

#import "DBUser.h"
#import "DBPhoto.h"
#import "DBComment.h"

@implementation ObjectiveFlickrDelegate


@synthesize flickrContext;

- (ObjectiveFlickrDelegate*)init
{
	if (self = [super init])
	{
		// Creates the context with Application key and secret
		flickrContext			= [[OFFlickrAPIContext alloc] initWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrAPISecret];
		NSString* aToken		= [[NSUserDefaults standardUserDefaults] stringForKey:kFlickrAuthToken];
		
		// Store token if present
		if ( aToken != nil)
			flickrContext.authToken = aToken;
	}
	
	return self;	
}

- (void)dealloc {
	
	[flickrContext release];
	
    [super dealloc];
}

- (BetterFlickrAppDelegate*)betterFlickrDelegate
{
	return (BetterFlickrAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)createRequestFromAPI:(NSString*)iAPI arguments:(NSDictionary*)iArguments
{
REQUIRE(self.flickrContext != nil)
	
	// Creates the request based on current context
	OFFlickrAPIRequest* aFlickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
	
	// The delegate should respond to the download content callback
	[aFlickrRequest setDelegate:self];
	
	// Finally call the corresponding API
	[aFlickrRequest setSessionInfo:iAPI];
	[aFlickrRequest callAPIMethodWithGET:iAPI
							   arguments:iArguments];
}

#pragma mark -
#pragma mark Process Response methods

- (void)processAuthentication:(NSDictionary*)iDicAuth
{
	NSString* aToken = [[iDicAuth valueForKeyPath:@"token"] textContent];
	
	// Create DB DBUser from Dictionary
	DBUser* aUser = [[DBUser alloc] initWithDictionary:[iDicAuth objectForKey:@"user"]];
	aUser.isMainUser = YES;
	
	// Store the Token in App Properties for later on
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFlickrAuthToken];
	[[NSUserDefaults standardUserDefaults] setObject:aToken forKey:kFlickrAuthToken];
	
	// Store Token in Flickr Request
	[flickrContext setAuthToken:aToken];
	
	// And save the current user
	[[DBUserAccessor instance] insertUser:aUser];
	
	// Authentication is sucessfull go back to main action
	[[self betterFlickrDelegate] firstAction];
}

- (void)processUserPhotos:(NSDictionary*)iDicPhotos;
{
	NSArray* aPhotoArray = [iDicPhotos objectForKey:kPhotoFlickrName];
	
REQUIRE(iDicPhotos != nil)
REQUIRE([aPhotoArray superclass] == [NSMutableArray class])
REQUIRE([aPhotoArray count] > 0)
	
	// Will be used to notify the application of new photos fetched
	BOOL aIsPhotoInserted = NO;
	
	for (int i = 0; i < [aPhotoArray count]; i++)
	{
		// Build photo from response
		DBPhoto* aPhoto		= [[DBPhoto alloc] initWithDictionary:[aPhotoArray objectAtIndex:i]];
		
		// Build photo from db (query based on photo id)
		DBPhoto* aDBPhoto	= [[DBPhotoAccessor instance] photoFromId:aPhoto.pid];
		
		//NSURL *aStaticPhotoURL = [aDBPhoto urlForPhotoSize:OFFlickrSmallSquareSize];
		//aStaticPhotoURL = nil;
		
		// Create the photo only if not already existing otheriwse
		// another part of the code should be called
		// TODO: Implement part when already existing photo
		if (aDBPhoto != nil)
			[aPhoto updateFromPhoto:aDBPhoto];
		
		if ([[DBPhotoAccessor instance] savePhoto:aPhoto])
			aIsPhotoInserted = YES; // At least one photo inserted

		
		// Release photo
		[aPhoto release];
	}
	
	
	// Retrieve current information from response
	NSInteger aCurrentPage	= [NSString integerFromDictionary:iDicPhotos key:kPhotoPage];
	NSInteger aNbPages		= [NSString integerFromDictionary:iDicPhotos key:kPhotoPages];
	NSString* aCurrentUser  = [[aPhotoArray objectAtIndex:0] objectForKey:kPhotoOwnerColumnName];
	
	// Fetch other photos if needed
	if (aCurrentPage < aNbPages)
	{
		aCurrentPage++;
		
		[self createRequestFromAPI:kFlickrPeoplePhotos 
						 arguments:[NSDictionary dictionaryWithObjectsAndKeys:
									aCurrentUser, @"user_id", 
									[NSString stringWithFormat:@"%d",aCurrentPage], kPhotoPage, 
									nil]];
	}
	
	// And notify the application that we have fetched some photos
	if (aIsPhotoInserted)
		[[self betterFlickrDelegate] gotNewPhotos:nil data:aPhotoArray];
}

- (void)processPhotoInfo:(NSDictionary*)iDicPhoto
{
REQUIRE(iDicPhoto != nil)
	// Create the photo from based info (but sometimes it's lacking some basic info)
	DBPhoto* aPhoto = [[DBPhoto alloc] initWithDictionary:iDicPhoto];//[[DBPhotoAccessor instance] photoFromId:@""];
	
	// Retreive the DBPhoto with same ID
	DBPhoto* aDBPhoto = [[DBPhotoAccessor instance] photoFromId:aPhoto.pid];
	
	// If photo is present udpate it with information retrieved
	if (aDBPhoto != nil)
	{
		[aDBPhoto updateFromPhoto:aPhoto];
		[[DBPhotoAccessor instance] savePhoto:aDBPhoto];
	}
	
	// Release objects
	[aPhoto release];
	
	// Alert the main delegate about the succesful flickr call
	[[self betterFlickrDelegate] gotUpdatedInfoForPhoto:aPhoto];
}

- (void)processPhotoFavorites:(NSDictionary*)iDicPhoto
{
REQUIRE(iDicPhoto != nil)
	
	DBPhoto* aPhoto = [[DBPhoto alloc] initWithDictionary:iDicPhoto];
	
	// Retreive the DBPhoto with same ID
	DBPhoto* aDBPhoto = [[DBPhotoAccessor instance] photoFromId:aPhoto.pid];
	
	// If photo is present udpate it with information retrieved
	if (aDBPhoto != nil)
	{
		aDBPhoto.favourites = [NSString integerFromDictionary:iDicPhoto key:kPhotoFavoritesTotal];
		[[DBPhotoAccessor instance] savePhoto:aDBPhoto];
	}
	
	// Release Objects
	[aPhoto release];
	
	// Alert the main delegate about the succesful flickr call
	[[self betterFlickrDelegate] gotUpdatedInfoForPhoto:aDBPhoto];
	
	
}

/*! @method		processPhotoComments:
 *	@abstract	Processes data retreived after a Flickr API Call. The response will look like:
 *				<comments photo_id="109722179">
 *					<comment id="6065-109722179-72057594077818641"
 *					 author="35468159852@N01" authorname="Rev Dan Catt" datecreate="1141841470"
 *					 permalink="...">
 *						Umm, I'm not sure, can I get back to you on that one?
 *					</comment>
 *				</comments>
 *	@param		iDicComments	A Dictionary build by ObjectiveFlickr built from
 *	
 */
- (void)processPhotoComments:(NSDictionary*)iDicComments
{
REQUIRE(iDicComments != nil)
	
	NSArray* aComments	= [iDicComments objectForKey:kCommentDictName];
	NSString* aRefPhoto = [iDicComments objectForKey:kCommentRefPhotoDictName];
	
REQUIRE ([aRefPhoto length])
	
	if ([aComments count] > 0)
	{
		for (int i = 0; i < [aComments count]; i++)
		{
			// Build object from dictionary response
			DBComment* aComment = [[DBComment alloc] initWithDictionary:[aComments objectAtIndex:i]
															 refPhotoId:aRefPhoto];
			
			// Save object into local database
			[[DBCommentAccessor instance] insertComment:aComment];
			
			//Release object
			[aComment release];
			
		}
		
		// Alert the main delegate about the succesful flickr call
		DBPhoto* aPhoto = [[DBPhotoAccessor instance] photoFromId:aRefPhoto];
		[[self betterFlickrDelegate] gotUpdatedInfoForPhoto:aPhoto];
	}
}

#pragma mark -
#pragma mark OFFlickrAPIRequestDelegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)iFlickrRequest didCompleteWithResponse:(NSDictionary *)iDicResponse
{
REQUIRE(self.flickrContext)	
	if (iFlickrRequest.sessionInfo == kFlickrAuthToken)
		[self processAuthentication:[iDicResponse objectForKey:@"auth"]];
	if (iFlickrRequest.sessionInfo == kFlickrPeoplePhotos)
		[self processUserPhotos:[iDicResponse objectForKey:@"photos"]];
	if (iFlickrRequest.sessionInfo == kFlickrPhotosInfo)
		[self processPhotoInfo:[iDicResponse objectForKey:@"photo"]];
	if (iFlickrRequest.sessionInfo == kFlickrPhotosFavorites)
		[self processPhotoFavorites:[iDicResponse objectForKey:@"photo"]];
	if (iFlickrRequest.sessionInfo == kFlickrPhotosCommentsList)
		[self processPhotoComments:[iDicResponse objectForKey:@"comments"]];
	
	// We're done with the OFFlickrAPIRequest => release it
	[iFlickrRequest release];
	
			
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)iFlickrRequest didFailWithError:(NSError *)inError
{
	NSString* aDemark = @"*******************************************************";
	NSString* aLog = [NSString stringWithFormat:@"\n%@\nDuring call to %@\n%@%@",
					  aDemark, 
					  iFlickrRequest.sessionInfo, 
					  [inError description],
					  aDemark];
	NSLog(@"%@",aLog);
	
	// We're done with the OFFlickrAPIRequest => release it
	[iFlickrRequest release];
}




@end
