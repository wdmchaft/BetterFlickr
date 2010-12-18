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
}

@property (nonatomic, retain) DBPhoto*	photo;
@property (nonatomic, retain) DBUser*	user;

@end
