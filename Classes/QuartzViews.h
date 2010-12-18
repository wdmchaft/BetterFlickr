//
//  QuartzViews.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/27/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuartzView : UIView
{ }

// As a matter of convinience we'll do all of our drawing here in subclasses of QuartzView.
-(void)drawInContext:(CGContextRef)context;

@end


@interface QuartzLineView : QuartzView
{ }

@end
