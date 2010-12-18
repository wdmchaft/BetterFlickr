//
//  PhotoDetailsViewController.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/4/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "ObjectiveFlickr.h"

#import "DBUser.h"
#import "DBPhoto.h"

#import "Downloader.h"

@implementation PhotoDetailsViewController

@synthesize photo = _photo;
@synthesize user = _user;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
REQUIRE(_photo != nil)
	
    [super viewDidLoad];
	
	self.title = _photo.title;
	
	if ([_photo photoIsStoredForSize:OFFlickrMediumSize] == NO)
	{
		// Creates and start the downloader
		[[[Downloader alloc] initWithSender:self param:_photo] startDownloadPhotoOfSize:OFFlickrMediumSize];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[_photo release];
	[_user release];
	
    [super dealloc];
}


@end
